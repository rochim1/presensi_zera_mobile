import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:presensi_data/core/mapper/app_mappr.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class ApprovalRepositoryImpl implements ApprovalRepository {
  final ApprovalRemoteDatasource remoteDatasource;
  final AppMappr mapper;
  final Logger logger;

  ApprovalRepositoryImpl({
    required this.remoteDatasource,
    required this.mapper,
    required this.logger,
  });

  @override
  Future<Either<Failure, void>> createApproval(
    CreateApprovalParams params,
  ) async {
    try {
      final request = mapper
          .convert<CreateApprovalParams, CreateApprovalRequest>(params);
      await remoteDatasource.createApproval(request);

      return Right(null);
    } on GraphQlException catch (e, stackTrace) {
      if (e is! CacheException) logger.e(
        "ApprovalRepositoryImpl.createApproval graphQL",
        error: e,
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      if (e is! CacheException) logger.e(
        "ApprovalRepositoryImpl.createApproval unknown",
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<ApprovalHistory>>> getMyPendingApprovals(
    GetMyPendingApprovalsParams params,
  ) async {
    try {
      final request = mapper
          .convert<GetMyPendingApprovalsParams, GetMyPendingApprovalsRequest>(
            params,
          );
      final pagination = PaginationRequest(
        page: params.page,
        limit: params.limit,
      );

      final response = await remoteDatasource.getMyPendingApprovals(
        request,
        pagination,
      );
      final approvals = response
          .map(
            (v) => mapper.convert<ApprovalHistoryResponse, ApprovalHistory>(v),
          )
          .toList();

      return Right(approvals);
    } on GraphQlException catch (e, stackTrace) {
      if (e is! CacheException) logger.e(
        "ApprovalRepositoryImpl.getMyPendingApprovals graphQL",
        error: e,
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      if (e is! CacheException) logger.e(
        "ApprovalRepositoryImpl.getMyPendingApprovals unknown",
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, TestWorkflowUserResult>> testWorkflowUser(
    TestWorkflowUserParams params,
  ) async {
    try {
      final request = TestWorkflowUserRequest(
        module: params.module,
        testUserId: params.testUserId,
      );

      final response = await remoteDatasource.testWorkflowUser(request);
      final result = TestWorkflowUserResult(
        isAutoApproved: response.isAutoApproved,
        levels: response.levels?.map((l) => TestWorkflowLevelResult(
          userIsApprover: l.userIsApprover,
        )).toList(),
      );

      return Right(result);
    } on GraphQlException catch (e, stackTrace) {
      if (e is! CacheException) logger.e(
        "ApprovalRepositoryImpl.testWorkflowUser graphQL",
        error: e,
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      if (e is! CacheException) logger.e(
        "ApprovalRepositoryImpl.testWorkflowUser unknown",
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure());
    }
  }
}
