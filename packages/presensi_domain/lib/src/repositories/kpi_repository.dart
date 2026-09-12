import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import '../entities/kpi/_kpi.dart';
import '../params/kpi/_kpi.dart';

abstract class KpiRepository {
  Future<Either<Failure, List<KpiAssignment>>> getMyAssignments(KpiFilterParams params);
  Future<Either<Failure, KpiAssignment>> getAssignmentDetail(String id);
  Future<Either<Failure, List<KpiAssignment>>> getTeamAssignments(KpiFilterParams params);
  Future<Either<Failure, KpiTeamSummary>> getTeamSummary(KpiFilterParams params);
  Future<Either<Failure, void>> submitSelfAssessment(SubmitSelfAssessmentParams params);
  Future<Either<Failure, void>> submitManagerReview(SubmitManagerReviewParams params);
  Future<Either<Failure, void>> acknowledgeKpi(String assignmentId);
}
