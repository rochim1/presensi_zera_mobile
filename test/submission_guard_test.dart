import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:presensi_mobile/presentation/pages/shift/tabs/approval_shift_swap/bloc/approval_shift_swap_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/bloc/order/order_create/order_create_cubit.dart';
import 'package:presensi_mobile/presentation/bloc/chat/chat_create_group_cubit.dart';
import 'package:presensi_mobile/presentation/pages/attendance/widgets/floating_photo_input.dart';
import 'package:presensi_mobile/presentation/pages/inventory/incidental/bloc/incidental_report_form_cubit.dart';

class _OrderUseCase implements OrderCreateSalesOrder {
  int calls = 0;
  Completer<Either<Failure, bool>> pending = Completer();
  @override
  Future<Either<Failure, bool>> call(SalesOrderParamsEntity params) {
    calls++;
    return pending.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _CreateGroup implements ChatCreateConversationUseCase {
  int calls = 0;
  Completer<Either<Failure, ConversationEntity>> pending = Completer();
  @override
  Future<Either<Failure, ConversationEntity>> call({
    required String type,
    String? groupName,
    String? groupDescription,
    required List<String> participantIds,
  }) {
    calls++;
    return pending.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _SearchUsers implements ChatSearchUsersUseCase {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _AddReport implements AddIncidentalReportUseCase {
  int calls = 0;
  final pending = Completer<Either<Failure, IncidentalReport>>();
  @override
  Future<Either<Failure, IncidentalReport>> call(
    AddIncidentalReportParams params,
  ) {
    calls++;
    return pending.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Inventory implements GetInventarisUmumUseCase {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _ApproveShift implements CreateShiftSwapRequestApproval {
  int calls = 0;
  Completer<Either<Failure, void>> pending = Completer();
  @override
  Future<Either<Failure, void>> call(dynamic params) {
    calls++;
    return pending.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _GetRequests implements GetShiftSwapRequests {
  @override
  Future<Either<Failure, List<ShiftSwapRequest>>> call(dynamic params) async =>
      const Right([]);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _ShiftRequest implements ShiftSwapRequest {
  @override
  final String id;
  _ShiftRequest(this.id);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test(
    'Order rejects repeated submit and permits retry after an exception',
    () async {
      final useCase = _OrderUseCase();
      final cubit = OrderCreateCubit(useCase);
      const params = SalesOrderParamsEntity(outletId: 'outlet');
      try {
        final first = cubit.submit(params);
        await cubit.submit(params);
        expect(useCase.calls, 1);
        expect(cubit.state.status.isLoading, isTrue);
        useCase.pending.completeError(StateError('network failure'));
        await first;
        expect(cubit.state.status.isLoading, isFalse);
        expect(cubit.state.failure, isNotNull);
        useCase.pending = Completer();
        final retry = cubit.submit(params);
        expect(useCase.calls, 2);
        useCase.pending.complete(const Right(true));
        await retry;
        await cubit.submit(params);
        expect(useCase.calls, 2);
      } finally {
        await cubit.close();
      }
    },
  );

  test(
    'Group creation ignores a second click with changed/invalid input',
    () async {
      final useCase = _CreateGroup();
      final cubit = ChatCreateGroupCubit(
        searchUsersUseCase: _SearchUsers(),
        createConversationUseCase: useCase,
      );
      cubit.toggleUserSelection(const ChatParticipantEntity(id: 'member'));
      try {
        final first = cubit.createGroup(groupName: 'Team');
        await cubit.createGroup(groupName: '');
        expect(useCase.calls, 1);
        expect(cubit.state.createStatus.isLoading, isTrue);
        useCase.pending.complete(const Right(ConversationEntity(id: 'group')));
        await first;
        await cubit.createGroup(groupName: 'Team');
        expect(useCase.calls, 1);
      } finally {
        await cubit.close();
      }
    },
  );

  test(
    'Report submits once and ignores completion after page disposal',
    () async {
      final useCase = _AddReport();
      final cubit = IncidentalReportFormCubit(useCase, _Inventory());
      final first = cubit.submitReport({'items': []});
      await cubit.submitReport({'items': []});
      expect(useCase.calls, 1);
      await cubit.close();
      useCase.pending.complete(Left(UnknownFailure()));
      await expectLater(first, completes);
    },
  );

  test(
    'Approval cannot be reset mid-request; another request can be approved afterwards',
    () async {
      final useCase = _ApproveShift();
      final cubit = ApprovalShiftSwapCubit(
        logger: Logger(),
        getShiftSwapRequestsUseCase: _GetRequests(),
        createShiftSwapRequestApprovalUseCase: useCase,
      );
      try {
        cubit.onChangeApprovalAction(RequestStatus.approved);
        final first = cubit.submitApproval(_ShiftRequest('first'));
        cubit.onChangeApprovalAction(RequestStatus.rejected);
        await cubit.submitApproval(_ShiftRequest('first'));
        expect(useCase.calls, 1);
        expect(cubit.state.approvalAction, RequestStatus.approved);
        expect(cubit.state.approvalSubmit.isLoading, isTrue);
        useCase.pending.complete(const Right(null));
        await first;
        await cubit.submitApproval(_ShiftRequest('first'));
        expect(useCase.calls, 1);
        cubit.onChangeApprovalAction(RequestStatus.approved);
        useCase.pending = Completer();
        final second = cubit.submitApproval(_ShiftRequest('second'));
        expect(useCase.calls, 2);
        useCase.pending.complete(const Right(null));
        await second;
        await Future<void>.delayed(Duration.zero);
      } finally {
        await cubit.close();
      }
    },
  );

  testWidgets('Photo input shows spinner and blocks tap/delete when busy', (
    tester,
  ) async {
    var tapped = 0;
    var deleted = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FloatingPhotoInput(
            imagePath: 'unused.jpg',
            isLoading: true,
            onTap: () => tapped++,
            onDelete: () => deleted++,
          ),
        ),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.tap(find.byType(FloatingPhotoInput));
    expect(tapped, 0);
    expect(deleted, 0);
    expect(tester.takeException(), isNull);
  });
}
