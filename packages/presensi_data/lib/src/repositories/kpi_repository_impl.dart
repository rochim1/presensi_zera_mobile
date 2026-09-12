import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:presensi_data/core/mapper/app_mappr.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class KpiRepositoryImpl implements KpiRepository {
  final KpiRemoteDatasource datasource;
  final AppMappr mapper;
  final Logger logger;

  KpiRepositoryImpl({
    required this.datasource,
    required this.mapper,
    required this.logger,
  });

  @override
  Future<Either<Failure, List<KpiAssignment>>> getMyAssignments(KpiFilterParams params) async {
    try {
      final response = await datasource.getMyAssignments(
        status: params.status,
        periodeLabel: params.periodeLabel,
        page: params.page,
        limit: params.limit,
      );
      final result = response.map((e) => mapper.convert<KpiAssignmentResponse, KpiAssignment>(e)).toList();
      return Right(result);
    } on GraphQlException catch (e) {
      logger.e('KpiRepositoryImpl.getMyAssignments: $e');
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      logger.e('KpiRepositoryImpl.getMyAssignments: $e');
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, KpiAssignment>> getAssignmentDetail(String id) async {
    try {
      final response = await datasource.getAssignmentDetail(id);
      final result = mapper.convert<KpiAssignmentResponse, KpiAssignment>(response);
      return Right(result);
    } on GraphQlException catch (e) {
      logger.e('KpiRepositoryImpl.getAssignmentDetail: $e');
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      logger.e('KpiRepositoryImpl.getAssignmentDetail: $e');
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<KpiAssignment>>> getTeamAssignments(KpiFilterParams params) async {
    try {
      final response = await datasource.getTeamAssignments(
        status: params.status,
        periodeLabel: params.periodeLabel,
        page: params.page,
        limit: params.limit,
      );
      final result = response.map((e) => mapper.convert<KpiAssignmentResponse, KpiAssignment>(e)).toList();
      return Right(result);
    } on GraphQlException catch (e) {
      logger.e('KpiRepositoryImpl.getTeamAssignments: $e');
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      logger.e('KpiRepositoryImpl.getTeamAssignments: $e');
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, KpiTeamSummary>> getTeamSummary(KpiFilterParams params) async {
    try {
      final response = await datasource.getTeamSummary(
        status: params.status,
        periodeLabel: params.periodeLabel,
      );
      final result = mapper.convert<KpiTeamSummaryResponse, KpiTeamSummary>(response);
      return Right(result);
    } on GraphQlException catch (e) {
      logger.e('KpiRepositoryImpl.getTeamSummary: $e');
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      logger.e('KpiRepositoryImpl.getTeamSummary: $e');
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> submitSelfAssessment(SubmitSelfAssessmentParams params) async {
    try {
      final scores = params.scores.map((e) => SelfScoreInputRequest(
        indicator_id: e.indicatorId,
        self_rating: e.selfRating,
        catatan_karyawan: e.catatanKaryawan,
      )).toList();
      final request = KpiSelfAssessmentRequest(
        assignment_id: params.assignmentId,
        scores: scores,
        catatan_karyawan_global: params.catatanKaryawanGlobal,
      );
      await datasource.submitSelfAssessment(request);
      return const Right(null);
    } on GraphQlException catch (e) {
      logger.e('KpiRepositoryImpl.submitSelfAssessment: $e');
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      logger.e('KpiRepositoryImpl.submitSelfAssessment: $e');
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> submitManagerReview(SubmitManagerReviewParams params) async {
    try {
      final scores = params.scores.map((e) => ManagerScoreInputRequest(
        indicator_id: e.indicatorId,
        manager_rating: e.managerRating,
        catatan_reviewer: e.catatanReviewer,
      )).toList();
      final request = KpiManagerReviewRequest(
        assignment_id: params.assignmentId,
        scores: scores,
        catatan_reviewer_global: params.catatanReviewerGlobal,
      );
      await datasource.submitManagerReview(request);
      return const Right(null);
    } on GraphQlException catch (e) {
      logger.e('KpiRepositoryImpl.submitManagerReview: $e');
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      logger.e('KpiRepositoryImpl.submitManagerReview: $e');
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> acknowledgeKpi(String assignmentId) async {
    try {
      await datasource.acknowledgeKpi(assignmentId);
      return const Right(null);
    } on GraphQlException catch (e) {
      logger.e('KpiRepositoryImpl.acknowledgeKpi: $e');
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      logger.e('KpiRepositoryImpl.acknowledgeKpi: $e');
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
