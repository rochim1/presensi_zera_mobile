import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:presensi_mobile/presentation/pages/kpi/self_assessment/self_assessment_page.dart';
import 'package:presensi_mobile/presentation/pages/kpi/kpi_review/kpi_review_page.dart';
import 'dart:io';
import 'dart:convert';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_data/core/mapper/app_mappr.dart';
import 'package:presensi_data/core/_core.dart';
import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/presentation/pages/kpi/self_assessment/bloc/self_assessment_cubit.dart';
import 'package:presensi_mobile/presentation/pages/kpi/kpi_review/bloc/kpi_review_cubit.dart';

class DelayedDetail implements GetKpiAssignmentDetail {
  final pending = Completer<Either<Failure, KpiAssignment>>();
  @override
  Future<Either<Failure, KpiAssignment>> call(String id) => pending.future;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class SelfSubmit implements SubmitSelfAssessment {
  int calls = 0;
  @override
  Future<Either<Failure, void>> call(SubmitSelfAssessmentParams params) async {
    calls++;
    return const Right(null);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class ManagerSubmit implements SubmitManagerReview {
  int calls = 0;
  @override
  Future<Either<Failure, void>> call(SubmitManagerReviewParams params) async {
    calls++;
    return const Right(null);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

KpiAssignment editableFixture(String status) {
  final fixture = jsonDecode(File('test/fixtures/kpi-mobile-api.json').readAsStringSync()) as Map<String, dynamic>;
  final value = const AppMappr().convert<KpiAssignmentResponse, KpiAssignment>(KpiAssignmentResponse.fromJson(fixture['detail']));
  return KpiAssignment(id: value.id, user: value.user, template: value.template,
    periodeLabel: value.periodeLabel, status: status, scores: value.scores);
}
void main() {
  KpiAssignment attendanceFixture() {
    final raw = jsonDecode(File('test/fixtures/kpi-attendance-api.json').readAsStringSync());
    return const AppMappr().convert<KpiAssignmentResponse, KpiAssignment>(KpiAssignmentResponse.fromJson(raw['detail']));
  }
  test('Corrected attendance API retains automatic metrics, weights, grade and review notice', () {
    final detail = attendanceFixture();
    expect(detail.sourceUpdateMessage, contains('Review terbaru'));
    expect(detail.status, 'acknowledged');
    expect(detail.finalScore, 3.8); expect(detail.finalGrade, 'B');
    expect(detail.scores!.map((s) => s.nilaiAktual), [100, 50, 4.1]);
    expect(detail.scores!.map((s) => s.bobot), [40, 20, 40]);
    expect(detail.scores!.map((s) => s.nilaiRating), [5, 3, 3]);
    expect(detail.scores!.map((s) => s.nilaiTerbobot), [2, .6, 1.2]);
  });
  testWidgets('Employee sees corrected-source notice and automatic rating in read-only result', (tester) async {
    final detail = DelayedDetail(), submit = SelfSubmit();
    final cubit = SelfAssessmentCubit(logger: Logger(), getDetail: detail, submitSelfAssessment: submit);
    final loading = cubit.init('qa'); detail.pending.complete(Right(attendanceFixture())); await loading;
    await tester.pumpWidget(ScreenUtilInit(designSize: const Size(360,800),
      builder: (_, _) => MaterialApp(home: BlocProvider.value(value: cubit, child: const SelfAssessmentView()))));
    await tester.pumpAndSettle();
    expect(find.textContaining('Review terbaru'), findsOneWidget);
    expect(find.text('Hasil review: 3.8 / 5 • Grade B'), findsOneWidget);
    expect(find.textContaining('Nilai pemeriksa: 3.0 / 5'), findsWidgets);
    expect(find.textContaining('Rating otomatis:'), findsWidgets);
    expect(find.text('Kirim Penilaian'), findsNothing);
    await tester.pumpWidget(const SizedBox()); await cubit.close();
  });

  testWidgets('self assessment opens confirmation with the complete typed indicator list', (tester) async {
    final detail = DelayedDetail(), submit = SelfSubmit();
    final cubit = SelfAssessmentCubit(logger: Logger(), getDetail: detail, submitSelfAssessment: submit);
    final loading = cubit.init('qa'); detail.pending.complete(Right(editableFixture('draft'))); await loading;
    await tester.pumpWidget(ScreenUtilInit(designSize: const Size(360,800),
      builder: (_, _) => MaterialApp(home: BlocProvider.value(value: cubit, child: const SelfAssessmentView()))));
    await tester.pumpAndSettle(); await tester.tap(find.text('Kirim Penilaian')); await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget); expect(submit.calls, 0);
    await tester.pumpWidget(const SizedBox()); await cubit.close();
  });
  testWidgets('manager review opens confirmation with the complete typed indicator list', (tester) async {
    final detail = DelayedDetail(), submit = ManagerSubmit();
    final cubit = KpiReviewCubit(logger: Logger(), getDetail: detail, submitManagerReview: submit);
    final loading = cubit.init('qa'); detail.pending.complete(Right(editableFixture('manager_review'))); await loading;
    await tester.pumpWidget(ScreenUtilInit(designSize: const Size(360,800),
      builder: (_, _) => MaterialApp(home: BlocProvider.value(value: cubit, child: const KpiReviewView()))));
    await tester.pumpAndSettle(); await tester.tap(find.text('Selesaikan Review')); await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget); expect(submit.calls, 0);
    await tester.pumpWidget(const SizedBox()); await cubit.close();
  });
  test(
    'real mobile API detail maps employee, template, indicators, ratings and final score',
    () {
      final fixture =
          jsonDecode(
                File('test/fixtures/kpi-mobile-api.json').readAsStringSync(),
              )
              as Map<String, dynamic>;
      final raw = fixture['detail'] as Map<String, dynamic>;
      final value = const AppMappr()
          .convert<KpiAssignmentResponse, KpiAssignment>(
            KpiAssignmentResponse.fromJson(raw),
          );
      expect(value.periodeLabel, 'QA Oktober 2026 17A');
      expect(value.template?.namaTemplate, 'QA Mobile KPI 17A');
      expect(value.template?.allowSelfAssessment, true);
      expect(value.user?.name, 'QA Mobile peer');
      expect(value.user?.divisiName, 'QA Mobile KPI 17A');
      expect(value.status, 'acknowledged');
      expect(value.finalScore, 4.2);
      expect(value.finalGrade, 'A');
      expect(value.scores?.first.indicator?.namaIndikator, 'Kualitas kerja QA');
      expect(
        value.scores?.first.indicator?.category?.namaKategori,
        'QA Mobile 17A',
      );
      expect(value.scores?.first.indicator?.tipeData, 'manual');
      expect(value.scores?.first.selfRating, 4);
      expect(value.scores?.first.managerRating, 5);
      expect(value.scores?.first.nilaiTerbobot, 3);
      expect(value.scores?.last.managerRating, 3);
      expect(value.managerReviewedAt, raw['manager_reviewed_at']);
    },
  );
  test(
    'real mobile API team summary preserves totals, average and grade distribution',
    () {
      final fixture =
          jsonDecode(
                File('test/fixtures/kpi-mobile-api.json').readAsStringSync(),
              )
              as Map<String, dynamic>;
      final raw = fixture['summary'] as Map<String, dynamic>;
      final value = const AppMappr()
          .convert<KpiTeamSummaryResponse, KpiTeamSummary>(
            KpiTeamSummaryResponse.fromJson(raw),
          );
      expect(value.totalKaryawan, 2);
      expect(value.avgScore, 4.2);
      expect(value.notStarted, raw['not_started']);
      expect(value.inProgress, raw['in_progress']);
      expect(value.gradeDistribution?.first.grade, 'A');
      expect(value.gradeDistribution?.first.count, 1);
    },
  );
  test(
    'leaving self assessment while loading ignores the late response',
    () async {
      final detail = DelayedDetail();
      final cubit = SelfAssessmentCubit(
        logger: Logger(),
        getDetail: detail,
        submitSelfAssessment: SelfSubmit(),
      );
      final loading = cubit.init('qa');
      await cubit.close();
      detail.pending.complete(const Right(KpiAssignment(id: 'qa', scores: [])));
      await expectLater(loading, completes);
    },
  );
  test(
    'leaving manager review while loading ignores the late response',
    () async {
      final detail = DelayedDetail();
      final cubit = KpiReviewCubit(
        logger: Logger(),
        getDetail: detail,
        submitManagerReview: ManagerSubmit(),
      );
      final loading = cubit.init('qa');
      await cubit.close();
      detail.pending.complete(const Right(KpiAssignment(id: 'qa', scores: [])));
      await expectLater(loading, completes);
    },
  );
  test(
    'successful self assessment does not send another request before navigation finishes',
    () async {
      final detail = DelayedDetail(), submit = SelfSubmit();
      final cubit = SelfAssessmentCubit(
        logger: Logger(),
        getDetail: detail,
        submitSelfAssessment: submit,
      );
      final loading = cubit.init('qa');
      detail.pending.complete(const Right(KpiAssignment(id: 'qa', scores: [])));
      await loading;
      await cubit.submit();
      await cubit.submit();
      expect(submit.calls, 1);
      await cubit.close();
    },
  );
  test(
    'successful manager review does not send another request before navigation finishes',
    () async {
      final detail = DelayedDetail(), submit = ManagerSubmit();
      final cubit = KpiReviewCubit(
        logger: Logger(),
        getDetail: detail,
        submitManagerReview: submit,
      );
      final loading = cubit.init('qa');
      detail.pending.complete(const Right(KpiAssignment(id: 'qa', scores: [])));
      await loading;
      await cubit.submit();
      await cubit.submit();
      expect(submit.calls, 1);
      await cubit.close();
    },
  );
}
