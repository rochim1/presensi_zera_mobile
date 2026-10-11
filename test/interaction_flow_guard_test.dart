import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_cubit.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presensi_mobile/presentation/interaction_gate.dart';
import 'package:presensi_mobile/presentation/pages/delivery/delivery_submission_controller.dart';
import 'package:presensi_mobile/presentation/widgets/app_bottom_sheet.dart';

class _GetActiveAttendance implements GetActiveAttendance {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _GetAttendances implements GetAttendances {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _GetEffectiveScheduleToday implements GetEffectiveScheduleToday {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _GetAuthSession implements GetAuthSession {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _GetSettingByOrganizationId implements GetSettingByOrganizationId {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _GetCurrentUser implements GetCurrentUser {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _CreateOvertimeRequest implements CreateOvertimeRequest {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _GetActiveOvertimeSession implements GetActiveOvertimeSession {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _StartOvertimeSession implements StartOvertimeSession {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FinishOvertimeSession implements FinishOvertimeSession {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _CancelOvertimeSession implements CancelOvertimeSession {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'Overtime start/finish/cancel share one guard and release on invalid session',
    () async {
      SharedPreferences.setMockInitialValues({});
      final cubit = AppCubit(
        getActiveAttendanceUseCase: _GetActiveAttendance(),
        getAttendancesUseCase: _GetAttendances(),
        getEffectiveScheduleTodayUseCase: _GetEffectiveScheduleToday(),
        getAuthSessionUseCase: _GetAuthSession(),
        getSettingByOrganizationIdUseCase: _GetSettingByOrganizationId(),
        getCurrentUserUseCase: _GetCurrentUser(),
        createOvertimeRequestUseCase: _CreateOvertimeRequest(),
        getActiveOvertimeSessionUseCase: _GetActiveOvertimeSession(),
        startOvertimeSessionUseCase: _StartOvertimeSession(),
        finishOvertimeSessionUseCase: _FinishOvertimeSession(),
        cancelOvertimeSessionUseCase: _CancelOvertimeSession(),
      );
      try {
        final starting = cubit.startOvertime();
        expect(cubit.overtimeAction.value, isTrue);
        expect(await cubit.cancelOvertime(), 'Proses lembur sedang berjalan');
        expect(
          await cubit.finishOvertime('reason'),
          'Proses lembur sedang berjalan',
        );
        expect(await starting, 'Data pengguna tidak ditemukan');
        expect(cubit.overtimeAction.value, isFalse);
        expect(await cubit.cancelOvertime(), 'Data pengguna tidak ditemukan');
      } finally {
        await cubit.close();
      }
    },
  );

  test('Shared gate prevents another entry point and releases for retry', () {
    final gate = InteractionGate();
    expect(gate.tryAcquire(), isTrue);
    expect(gate.tryAcquire(), isFalse);
    gate.release();
    expect(gate.tryAcquire(), isTrue);
    gate.dispose();
    expect(gate.tryAcquire(), isFalse);
    expect(gate.release, returnsNormally);
  });

  test('Delivery retry only resubmits order after visit success', () async {
    final flow = DeliverySubmissionController();
    var visits = 0;
    var orders = 0;
    Future<bool> visit() async {
      visits++;
      return true;
    }

    Future<bool> order() async {
      orders++;
      return orders > 1;
    }

    expect(await flow.submit(submitVisit: visit, submitOrder: order), isFalse);
    expect(flow.visitCompleted, isTrue);
    expect(flow.value, isFalse);
    expect(await flow.submit(submitVisit: visit, submitOrder: order), isTrue);
    expect(visits, 1);
    expect(orders, 2);
    expect(await flow.submit(submitVisit: visit, submitOrder: order), isFalse);
    expect(orders, 2);
    flow.dispose();
  });

  test('Delivery ignores another click and retries a failed visit', () async {
    final flow = DeliverySubmissionController();
    final pending = Completer<bool>();
    var visits = 0;
    Future<bool> visit() {
      visits++;
      return pending.future;
    }

    final first = flow.submit(submitVisit: visit);
    expect(await flow.submit(submitVisit: visit), isFalse);
    expect(visits, 1);
    pending.complete(false);
    expect(await first, isFalse);
    expect(flow.visitCompleted, isFalse);
    expect(
      await flow.submit(
        submitVisit: () async {
          visits++;
          return true;
        },
      ),
      isTrue,
    );
    expect(visits, 2);
    flow.dispose();
  });

  test(
    'Delivery releases gate after exception and ignores late disposal',
    () async {
      final flow = DeliverySubmissionController();
      await expectLater(
        flow.submit(submitVisit: () async => throw StateError('failure')),
        throwsStateError,
      );
      expect(flow.value, isFalse);
      final pending = Completer<bool>();
      final sending = flow.submit(submitVisit: () => pending.future);
      flow.dispose();
      pending.complete(true);
      await expectLater(sending, completion(isTrue));
    },
  );

  testWidgets(
    'Busy approval sheet blocks back/close and unlocks after failure',
    (tester) async {
      final busy = ValueNotifier(false);
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 800),
          builder: (context, child) => MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: TextButton(
                  onPressed: () => AppBottomSheet.show(
                    context: context,
                    busyListenable: busy,
                    title: const Text('Approval'),
                    child: const Text('Request A'),
                  ),
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      busy.value = true;
      await tester.pump();
      expect(find.byIcon(Icons.close), findsNothing);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Request A'), findsOneWidget);
      busy.value = false;
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      expect(find.text('Request A'), findsNothing);
      busy.dispose();
    },
  );
}
