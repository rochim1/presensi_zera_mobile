import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:presensi_data/core/mapper/app_mappr.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class LeaveRepositoryImpl implements LeaveRepository {
  final LeaveRemoteDatasource datasource;
  final AppMappr mapper;
  final Logger logger;

  LeaveRepositoryImpl({
    required this.mapper,
    required this.logger,
    required this.datasource,
  });

  @override
  Future<Either<Failure, List<LeaveRequest>>> getLeaveRequests(
    GetLeaveRequestsParams params,
  ) async {
    try {
      final request = mapper
          .convert<GetLeaveRequestsParams, GetLeaveRequestsRequest>(params);
      final pagination = PaginationRequest(
        page: params.page,
        limit: params.limit,
      );
      logger.d(
        "LeaveRepositoryImpl.getLeaveRequests request: ${request.toJson()}\n pagination: ${pagination.toJson()}",
      );

      final response = await datasource.getLeaveRequests(request, pagination);

      final leaveRequests = response
          .map((v) => mapper.convert<LeaveRequestResponse, LeaveRequest>(v))
          .toList();

      return Right(leaveRequests);
    } on GraphQlException catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "LeaveRepositoryImpl.getLeaveRequests graphQL",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "LeaveRepositoryImpl.getLeaveRequests unknown",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<LeaveCategory>>> getLeaveCategories() async {
    try {
      final response = await datasource.getLeaveCategories();

      final categories = response
          .map((v) => mapper.convert<LeaveCategoryResponse, LeaveCategory>(v))
          .toList();

      return Right(categories);
    } on GraphQlException catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "LeaveRepositoryImpl.getLeaveCategories graphQL",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "LeaveRepositoryImpl.getLeaveCategories unknown",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, LeaveRequest>> getLeaveRequestById(String id) async {
    try {
      logger.d("LeaveRepositoryImpl.getLeaveRequestById id: $id");

      final response = await datasource.getLeaveRequestById(id);
      final result = mapper.convert<LeaveRequestResponse, LeaveRequest>(
        response,
      );

      return Right(result);
    } on GraphQlException catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "LeaveRepositoryImpl.getLeaveRequestById graphQL",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "LeaveRepositoryImpl.getLeaveRequestById unknown",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> createLeaveRequest(
    CreateLeaveRequestParams params,
  ) async {
    try {
      logger.d("LeaveRepositoryImpl.createLeaveRequest params: $params");

      // CreateCuti only persists employee submissions when status_izin is
      // "diajukan". Without it the backend returns a nullable result and no
      // leave document is created.
      final request = mapper
          .convert<CreateLeaveRequestParams, CreateLeaveRequestRequest>(params)
          .copyWith(statusIzin: 'diajukan');
      await datasource.createLeaveRequest(
        request,
        attachment: params.attachment,
      );

      return const Right(null);
    } on GraphQlException catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "LeaveRepositoryImpl.createLeaveRequest graphQL",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "LeaveRepositoryImpl.createLeaveRequest unknown",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateLeaveRequest(
    String id,
    CreateLeaveRequestParams params,
  ) async {
    try {
      final request = mapper
          .convert<CreateLeaveRequestParams, CreateLeaveRequestRequest>(params)
          // UpdateCuti explicitly rejects workflow/status fields.
          .copyWith(statusIzin: null);
      await datasource.updateLeaveRequest(
        id,
        request,
        attachment: params.attachment,
      );
      return const Right(null);
    } on GraphQlException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (_) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteLeaveRequest(String id) async {
    try {
      await datasource.deleteLeaveRequest(id);
      return const Right(null);
    } on GraphQlException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (_) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getMyCutiQuota() async {
    try {
      final response = await datasource.getMyCutiQuota();
      return Right(response);
    } on GraphQlException catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "LeaveRepositoryImpl.getMyCutiQuota graphQL",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "LeaveRepositoryImpl.getMyCutiQuota unknown",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(UnknownFailure());
    }
  }
}
