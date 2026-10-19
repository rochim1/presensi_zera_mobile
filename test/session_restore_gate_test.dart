import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/bloc/base_state.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_state.dart';
import 'package:presensi_mobile/presentation/session_restore_gate.dart';

void main() {
  const user = BaseState<User>.success(User(id: 'qa', name: 'QA'));
  const active = BaseState<Attendance>.success(
    Attendance(
      id: 'existing',
      type: AttendanceType.daily,
      status: StatusKerja.kerja,
      totalKerja: Duration.zero,
      totalIstirahat: Duration.zero,
    ),
  );
  Widget view(AppState state, {VoidCallback? retry}) => MaterialApp(
    home: SessionRestoreGate(
      state: state,
      onRetry: retry ?? () {},
      child: const Scaffold(body: Text('Attendance actions')),
    ),
  );

  testWidgets('hides actions until account and attendance have both restored', (
    tester,
  ) async {
    await tester.pumpWidget(view(const AppState()));
    expect(find.text('Memulihkan akun dan presensi…'), findsOneWidget);
    expect(find.text('Attendance actions'), findsNothing);
    await tester.pumpWidget(
      view(const AppState(user: user, activeAttendance: BaseState.loading())),
    );
    expect(find.text('Attendance actions'), findsNothing);
    await tester.pumpWidget(
      view(
        const AppState(
          user: user,
          activeAttendance: active,
          sessionRestore: BaseState.success(true),
        ),
      ),
    );
    expect(find.text('Attendance actions'), findsOneWidget);
  });

  testWidgets('confirmed absence of active attendance permits normal home', (
    tester,
  ) async {
    await tester.pumpWidget(
      view(
        AppState(
          user: user,
          sessionRestore: const BaseState.success(true),
          activeAttendance: BaseState.failure(
            NotFoundFailure(message: 'Tidak ada presensi aktif'),
          ),
        ),
      ),
    );
    expect(find.text('Attendance actions'), findsOneWidget);
  });

  testWidgets(
    'network failure offers retry without guessing attendance status',
    (tester) async {
      var retries = 0;
      await tester.pumpWidget(
        view(
          AppState(
            user: user,
            activeAttendance: BaseState.failure(
              ServerFailure(message: 'offline'),
            ),
          ),
          retry: () => retries++,
        ),
      );
      expect(find.text('Attendance actions'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      await tester.tap(find.text('Coba lagi'));
      expect(retries, 1);
    },
  );
  testWidgets(
    'daily history must be restored even if no active session exists',
    (tester) async {
      await tester.pumpWidget(
        view(
          AppState(
            user: user,
            activeAttendance: BaseState.failure(
              NotFoundFailure(message: 'none'),
            ),
            sessionRestore: const BaseState.loading(),
          ),
        ),
      );
      expect(find.text('Attendance actions'), findsNothing);
      expect(find.text('Memulihkan akun dan presensi…'), findsOneWidget);
    },
  );

  testWidgets('refresh preserves mounted Home but a new account resets it', (
    tester,
  ) async {
    var mounts = 0;
    var disposals = 0;
    final child = _LifecycleProbe(
      onInit: () => mounts++,
      onDispose: () => disposals++,
    );
    Widget gate(AppState state) => MaterialApp(
      home: SessionRestoreGate(state: state, onRetry: () {}, child: child),
    );
    const ready = AppState(
      user: user,
      activeAttendance: active,
      sessionRestore: BaseState.success(true),
    );
    await tester.pumpWidget(gate(ready));
    expect(mounts, 1);
    await tester.pumpWidget(
      gate(
        ready.copyWith(
          user: const BaseState.loading(),
          sessionRestore: const BaseState.loading(),
        ),
      ),
    );
    expect(disposals, 0);
    expect(find.byType(_LifecycleProbe), findsNothing);
    await tester.pumpWidget(gate(ready));
    expect(mounts, 1);
    await tester.pumpWidget(
      gate(
        ready.copyWith(
          user: const BaseState.success(User(id: 'other', name: 'Other')),
        ),
      ),
    );
    expect(mounts, 2);
    expect(disposals, 1);
    await tester.pumpWidget(const SizedBox());
  });
}

class _LifecycleProbe extends StatefulWidget {
  const _LifecycleProbe({required this.onInit, required this.onDispose});
  final VoidCallback onInit;
  final VoidCallback onDispose;
  @override
  State<_LifecycleProbe> createState() => _LifecycleProbeState();
}

class _LifecycleProbeState extends State<_LifecycleProbe> {
  @override
  void initState() {
    super.initState();
    widget.onInit();
  }

  @override
  void dispose() {
    widget.onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const SizedBox();
}
