import 'package:intl/date_symbol_data_local.dart';
import 'package:presensi_mobile/presentation/pages/home/widgets/attendance_card.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:dartz/dartz.dart';
import 'package:presensi_mobile/core/bloc/base_state.dart';
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
  List<Attendance> rows = [];
  @override
  Future<Either<Failure, List<Attendance>>> call(
    GetAttendancesParams params,
  ) async => Right(rows);
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

class _DelayedCurrentUser implements GetCurrentUser {
  final responses = <Completer<Either<Failure, User>>>[];
  @override
  Future<Either<Failure, User>> call(params) {
    final response = Completer<Either<Failure, User>>();
    responses.add(response);
    return response.future;
  }

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

class _RestoreProbe extends AppCubit {
  _RestoreProbe()
    : super(
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
  final calls = <String>[];
  final settings = Completer<void>();
  final active = Completer<void>();
  final today = Completer<bool>();
  @override
  Future<void> getAuthSession() async {
    calls.add('auth');
    emit(
      state.copyWith(
        session: const BaseState.success(
          AuthSession(token: 'qa', appId: 'qa', userId: 'qa'),
        ),
      ),
    );
  }

  @override
  Future<void> getCurrentUser() async {
    calls.add('user');
    emit(
      state.copyWith(
        user: const BaseState.success(User(id: 'qa', name: 'QA')),
      ),
    );
  }

  @override
  Future<void> loadSettingCache() async {}
  @override
  Future<bool> getSetting() async {
    calls.add('settings');
    await settings.future;
    return true;
  }

  @override
  Future<void> loadOvertimeState() async {
    calls.add('overtime');
  }

  @override
  Future<void> getActiveAttendance() async {
    calls.add('active');
    await active.future;
    emit(
      state.copyWith(
        activeAttendance: BaseState.failure(NotFoundFailure(message: 'none')),
      ),
    );
  }

  @override
  Future<void> loadCheckedOutDate() async {}
  @override
  Future<bool> syncTodayAttendanceFromServer() async {
    calls.add('today');
    return today.future;
  }

  @override
  Future<void> getEffectiveScheduleToday() async {
    calls.add('schedule');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'Session restoration coalesces calls and restores attendance without waiting for settings',
    () async {
      final cubit = _RestoreProbe();
      final initial = cubit.init();
      final duplicate = cubit.onRefresh();
      expect(identical(initial, duplicate), isTrue);
      await Future<void>.delayed(Duration.zero);
      expect(
        cubit.calls,
        containsAll(['settings', 'active', 'today', 'schedule']),
      );
      expect(cubit.calls.where((c) => c == 'user').length, 1);
      cubit.active.complete();
      cubit.today.complete(true);
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state.sessionRestore.isSuccess, isTrue);
      expect(cubit.calls, isNot(contains('overtime')));
      cubit.settings.complete();
      await initial;
      expect(cubit.calls, contains('overtime'));
      await cubit.onRefresh();
      expect(cubit.calls.where((c) => c == 'user').length, 2);
      await cubit.close();
    },
  );

  test(
    'Daily history failure is not reported as restored or absent attendance',
    () async {
      final cubit = _RestoreProbe();
      final restoring = cubit.init();
      await Future<void>.delayed(Duration.zero);
      cubit.active.complete();
      cubit.today.complete(false);
      cubit.settings.complete();
      await restoring;
      expect(cubit.state.sessionRestore.isError, isTrue);
      await cubit.close();
    },
  );

  test(
    'Old account response cannot replace a new session after logout',
    () async {
      final users = _DelayedCurrentUser();
      final cubit = AppCubit(
        getActiveAttendanceUseCase: _GetActiveAttendance(),
        getAttendancesUseCase: _GetAttendances(),
        getEffectiveScheduleTodayUseCase: _GetEffectiveScheduleToday(),
        getAuthSessionUseCase: _GetAuthSession(),
        getSettingByOrganizationIdUseCase: _GetSettingByOrganizationId(),
        getCurrentUserUseCase: users,
        createOvertimeRequestUseCase: _CreateOvertimeRequest(),
        getActiveOvertimeSessionUseCase: _GetActiveOvertimeSession(),
        startOvertimeSessionUseCase: _StartOvertimeSession(),
        finishOvertimeSessionUseCase: _FinishOvertimeSession(),
        cancelOvertimeSessionUseCase: _CancelOvertimeSession(),
      );
      final oldRequest = cubit.getCurrentUser();
      await cubit.clearStateOnLogout();
      expect(cubit.state.user.data, isNull);
      final newRequest = cubit.getCurrentUser();
      users.responses[1].complete(const Right(User(id: 'new', name: 'New')));
      await newRequest;
      users.responses[0].complete(const Right(User(id: 'old', name: 'Old')));
      await oldRequest;
      expect(cubit.state.user.data?.id, 'new');
      await cubit.close();
    },
  );

  test(
    'Completed attendance remains available for home without creating an active session',
    () async {
      SharedPreferences.setMockInitialValues({});
      final records = _GetAttendances();
      final cubit = AppCubit(
        getActiveAttendanceUseCase: _GetActiveAttendance(),
        getAttendancesUseCase: records,
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
      // Seed the same authenticated state produced by getCurrentUser.
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      cubit.emit(
        cubit.state.copyWith(
          user: BaseState.success(const User(id: 'employee', name: 'QA')),
        ),
      );
      final completed = Attendance(
        id: 'completed',
        type: AttendanceType.daily,
        status: StatusKerja.pulang,
        jamMasuk: DateTime(2026, 10, 18, 8),
        jamPulang: DateTime(2026, 10, 18, 17),
        totalKerja: const Duration(hours: 9),
        totalIstirahat: Duration.zero,
      );
      records.rows = [completed];
      expect(await cubit.syncTodayAttendanceFromServer(), isTrue);
      expect(cubit.state.lastTodayAttendance, same(completed));
      expect(cubit.state.activeAttendance.data, isNull);
      expect(cubit.state.hasCheckedOutToday, isTrue);
      records.rows = [];
      await cubit.syncTodayAttendanceFromServer();
      expect(cubit.state.lastTodayAttendance, isNull);
      expect(cubit.state.hasCheckedOutToday, isFalse);
      await cubit.close();
    },
  );

  testWidgets('Completed home card shows both clocks without a break action', (
    tester,
  ) async {
    await initializeDateFormatting('id_ID');
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, _) => MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: HomeAttendanceCard(
                hasCheckedOutToday: true,
                sliderText: 'Geser untuk Istirahat',
                attendance: Attendance(
                  id: 'done',
                  type: AttendanceType.daily,
                  status: StatusKerja.pulang,
                  jamMasuk: DateTime(2026, 10, 18, 8),
                  jamPulang: DateTime(2026, 10, 18, 17),
                  totalKerja: const Duration(hours: 9),
                  totalIstirahat: Duration.zero,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    expect(find.text('08:00'), findsOneWidget);
    expect(find.text('17:00'), findsOneWidget);
    expect(find.text('Geser untuk Istirahat'), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
  });

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
