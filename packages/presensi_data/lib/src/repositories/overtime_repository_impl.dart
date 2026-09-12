import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:presensi_data/core/mapper/app_mappr.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class OvertimeRepositoryImpl implements OvertimeRepository {
  final OvertimeRemoteDatasource remoteDatasource;
  final LoginLocalDatasource loginLocalDatasource;
  final AppMappr mapper;
  final Logger logger;

  OvertimeRepositoryImpl({
    required this.remoteDatasource,
    required this.loginLocalDatasource,
    required this.mapper,
    required this.logger,
  });

  @override
  Future<Either<Failure, List<OvertimeRequest>>> getOvertimeRequests(
    GetOvertimeRequestsParams params,
  ) async {
    try {
      // final user = await loginLocalDatasource.getLogin();
      final request = mapper
          .convert<GetOvertimeRequestsParams, GetOvertimeRequestsRequest>(
            params,
          );
      // .copyWith(userId: user.userId);
      final pagination = PaginationRequest(
        page: params.page,
        limit: params.limit,
      );

      final response = await remoteDatasource.getOvertimeRequests(
        request,
        pagination,
      );
      final attendanceRequests = response
          .map(
            (v) => mapper.convert<OvertimeRequestResponse, OvertimeRequest>(v),
          )
          .toList();

      return Right(attendanceRequests);
    } on GraphQlException catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "OvertimeRepositoryImpl.getAttendanceRequests graphQL",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "OvertimeRepositoryImpl.getAttendanceRequests unknown",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, OvertimeRequest>> getOvertimeRequestById(
    String id,
  ) async {
    try {
      final response = await remoteDatasource.getOvertimeRequestById(id);
      final overtimeRequest = mapper
          .convert<OvertimeRequestResponse, OvertimeRequest>(response);

      return Right(overtimeRequest);
    } on GraphQlException catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "OvertimeRepositoryImpl.getOvertimeRequestById graphQL",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "OvertimeRepositoryImpl.getOvertimeRequestById unknown",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, OvertimeRequest?>> getActiveOvertimeSession() async {
    try {
      final response = await remoteDatasource.getActiveOvertimeSession();
      if (response == null) return const Right(null);
      return Right(
        mapper.convert<OvertimeRequestResponse, OvertimeRequest>(response),
      );
    } on GraphQlException catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "OvertimeRepositoryImpl.getActiveOvertimeSession graphQL",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "OvertimeRepositoryImpl.getActiveOvertimeSession unknown",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> createOvertimeRequest(
    CreateOvertimeRequestParams params,
  ) async {
    try {
      final request = mapper
          .convert<CreateOvertimeRequestParams, CreateOvertimeRequestRequest>(
            params,
          );

      await remoteDatasource.createOvertimeRequest(request, params.attachments);

      return Right(null);
    } on GraphQlException catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "OvertimeRepositoryImpl.createOvertimeRequest graphQL",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "OvertimeRepositoryImpl.createOvertimeRequest unknown",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateOvertimeRequest(
    String id,
    CreateOvertimeRequestParams params,
  ) async {
    try {
      final request = mapper
          .convert<CreateOvertimeRequestParams, CreateOvertimeRequestRequest>(
            params,
          );
      await remoteDatasource.updateOvertimeRequest(
        id,
        request,
        params.attachments,
      );
      return const Right(null);
    } on GraphQlException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (_) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteOvertimeRequest(String id) async {
    try {
      await remoteDatasource.deleteOvertimeRequest(id);
      return const Right(null);
    } on GraphQlException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (_) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, OvertimeRequest>> startOvertimeSession(
    StartOvertimeSessionParams params,
  ) async {
    try {
      final response = await remoteDatasource.startOvertimeSession(params);
      return Right(
        mapper.convert<OvertimeRequestResponse, OvertimeRequest>(response),
      );
    } on GraphQlException catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "OvertimeRepositoryImpl.startOvertimeSession graphQL",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "OvertimeRepositoryImpl.startOvertimeSession unknown",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, OvertimeRequest>> finishOvertimeSession(
    FinishOvertimeSessionParams params,
  ) async {
    try {
      final response = await remoteDatasource.finishOvertimeSession(params);
      return Right(
        mapper.convert<OvertimeRequestResponse, OvertimeRequest>(response),
      );
    } on GraphQlException catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "OvertimeRepositoryImpl.finishOvertimeSession graphQL",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "OvertimeRepositoryImpl.finishOvertimeSession unknown",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> cancelOvertimeSession(String overtimeId) async {
    try {
      await remoteDatasource.cancelOvertimeSession(overtimeId);
      return const Right(null);
    } on GraphQlException catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "OvertimeRepositoryImpl.cancelOvertimeSession graphQL",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "OvertimeRepositoryImpl.cancelOvertimeSession unknown",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(UnknownFailure());
    }
  }
}
