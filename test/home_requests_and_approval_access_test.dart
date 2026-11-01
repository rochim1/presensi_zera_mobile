import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/pages/attendance/bloc/attendance_cubit.dart';
import 'package:presensi_mobile/presentation/pages/attendance/bloc/attendance_state.dart';
import 'package:presensi_mobile/presentation/pages/attendance/widgets/attendance_stats_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:presensi_mobile/presentation/pages/home/widgets/attendance_card.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/presentation/pages/approval_center/approval_center_page.dart';
import 'package:presensi_mobile/presentation/pages/home/widgets/home_requests_section.dart';

class LeaveSource implements GetLeaveRequests {
  List<LeaveRequest> values = [];
  String? requestedUser;
  @override
  Future<Either<Failure, List<LeaveRequest>>> call(dynamic params) async {
    requestedUser = params.userId as String?;
    return Right(values);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class OvertimeSource implements GetOvertimeRequests {
  List<OvertimeRequest> values = [];
  bool fail = false;
  String? requestedUser;
  @override
  Future<Either<Failure, List<OvertimeRequest>>> call(dynamic params) async {
    requestedUser = params.userId as String?;
    return fail ? const Left(ServerFailure()) : Right(values);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class AttendanceSource implements GetAttendanceRequests {
  @override
  Future<Either<Failure, List<AttendanceRequest>>> call(dynamic params) async =>
      const Right([]);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class ReimbursementSource implements GetMyReimbursements {
  @override
  Future<Either<Failure, List<Reimbursement>>> call(dynamic params) async =>
      const Right([]);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class WorkflowSource implements TestWorkflowUserUseCase {
  final bool fail;
  final Set<String> modules;
  WorkflowSource({this.fail = false, this.modules = const {}});
  @override
  Future<Either<Failure, TestWorkflowUserResult>> call(
    TestWorkflowUserParams params,
  ) async {
    if (fail) throw StateError('Network unavailable');
    return Right(
      TestWorkflowUserResult(
        levels: [
          TestWorkflowLevelResult(
            userIsApprover: modules.contains(params.module),
          ),
        ],
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class SummaryCubit extends Cubit<AttendanceState> implements AttendanceCubit {
  SummaryCubit()
    : super(
        const AttendanceState(
          statistics: BaseState.success([
            AttendanceStatistic(typePresensi: 'reguler', totalHadir: 20),
            AttendanceStatistic(typePresensi: 'shift', totalHadir: 12),
            AttendanceStatistic(typePresensi: 'oncall', totalHadir: 3),
          ]),
        ),
      );
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('mobile summary keeps all attendance types reachable', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final cubit = SummaryCubit();
    await tester.pumpWidget(
      BlocProvider<AttendanceCubit>.value(
        value: cubit,
        child: const MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: EdgeInsets.all(16),
              child: AttendanceStatsCard(),
            ),
          ),
        ),
      ),
    );
    expect(find.text('20'), findsOneWidget);
    await tester.drag(find.byType(PageView), const Offset(-320, 0));
    await tester.pumpAndSettle();
    expect(find.text('12'), findsOneWidget);
    await tester.drag(find.byType(PageView), const Offset(-320, 0));
    await tester.pumpAndSettle();
    expect(find.text('3'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await cubit.close();
  });

  testWidgets('attendance clocks fit a narrow mobile viewport', (tester) async {
    final semantics = tester.ensureSemantics();
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await initializeDateFormatting('id_ID');
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, _) => const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: HomeAttendanceCard(),
              ),
            ),
          ),
        ),
      ),
    );
    expect(find.text('Masuk'), findsWidgets);
    expect(find.text('Pulang'), findsOneWidget);
    await tester.drag(
      find.byType(PageView),
      const Offset(-320, 0),
      kind: PointerDeviceKind.mouse,
    );
    await tester.pumpAndSettle();
    expect(find.text('Jadwal Masuk'), findsOneWidget);
    expect(find.text('Target Kerja'), findsOneWidget);
    expect(tester.widget<PageView>(find.byType(PageView)).controller!.page, 1);
    await tester.drag(find.byType(PageView), const Offset(320, 0));
    await tester.pumpAndSettle();
    expect(tester.widget<PageView>(find.byType(PageView)).controller!.page, 0);
    await tester.tap(find.bySemanticsLabel('Tampilkan jadwal kerja'));
    await tester.pumpAndSettle();
    expect(tester.widget<PageView>(find.byType(PageView)).controller!.page, 1);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    semantics.dispose();
  });

  const employee = User(id: 'me', name: 'Employee');
  const other = User(id: 'other', name: 'Other employee');

  test(
    'home keeps only the account own requests, sorted and limited across sources',
    () async {
      final leave = LeaveSource()
        ..values = [
          LeaveRequest(
            id: 'foreign',
            status: LeaveStatus.diajukan,
            user: other,
            alasan: '',
            tanggalPengajuan: DateTime(2026, 10, 29),
          ),
          LeaveRequest(
            id: 'older',
            status: LeaveStatus.diajukan,
            user: employee,
            alasan: '',
            tanggalPengajuan: DateTime(2026, 10, 20),
          ),
          LeaveRequest(
            id: 'newer',
            status: LeaveStatus.diterima,
            user: employee,
            alasan: '',
            tanggalPengajuan: DateTime(2026, 10, 23),
          ),
        ];
      final overtime = OvertimeSource()
        ..values = [
          OvertimeRequest(
            id: 'latest',
            durationInHours: 2,
            status: OvertimeRequestStatus.pending,
            user: employee,
            createdAt: DateTime(2026, 10, 24),
          ),
          OvertimeRequest(
            id: 'oldest',
            durationInHours: 1,
            status: OvertimeRequestStatus.pending,
            user: employee,
            createdAt: DateTime(2026, 10, 19),
          ),
        ];
      final result = await HomeRequestsLoader(
        leave: leave,
        overtime: overtime,
        attendance: AttendanceSource(),
        reimbursement: ReimbursementSource(),
      ).load('me', DateTime(2026, 10));
      expect(result.requests.map((request) => request.id), [
        'latest',
        'newer',
        'older',
      ]);
      expect(result.failedSources, 0);
      expect(leave.requestedUser, 'me');
      expect(overtime.requestedUser, 'me');
    },
  );

  test(
    'a failed source does not hide successful requests or imply an empty month',
    () async {
      final leave = LeaveSource()
        ..values = [
          const LeaveRequest(
            id: 'mine',
            status: LeaveStatus.diajukan,
            user: employee,
            alasan: '',
          ),
        ];
      final result = await HomeRequestsLoader(
        leave: leave,
        overtime: OvertimeSource()..fail = true,
        attendance: AttendanceSource(),
        reimbursement: ReimbursementSource(),
      ).load('me', DateTime(2026, 10));
      expect(result.requests.single.id, 'mine');
      expect(result.failedSources, 1);
    },
  );

  test(
    'approval access fails closed when workflow verification is unavailable',
    () async {
      final access = await ApprovalAccess.load(
        'me',
        WorkflowSource(fail: true),
      );
      expect(access.modules, isEmpty);
      expect(access.hasFailure, isTrue);
    },
  );

  test(
    'payroll eligibility does not grant operational approval access',
    () async {
      final access = await ApprovalAccess.load(
        'me',
        WorkflowSource(modules: {'payroll_batch'}),
      );
      expect(access.modules, {ApprovalRequestType.payroll_batch});
      expect(access.hasFailure, isFalse);
    },
  );
}
