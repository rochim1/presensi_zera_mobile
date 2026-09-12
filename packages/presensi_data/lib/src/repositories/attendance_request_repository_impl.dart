import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:presensi_data/core/mapper/app_mappr.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class AttendanceRequestRepositoryImpl implements AttendanceRequestRepository {
  final AttendanceRequestRemoteDatasource remoteDatasource;
  final LoginLocalDatasource loginLocalDatasource;
  final AppMappr mapper;
  final Logger logger;

  AttendanceRequestRepositoryImpl({
    required this.remoteDatasource,
    required this.loginLocalDatasource,
    required this.mapper,
    required this.logger,
  });

  @override
  Future<Either<Failure, List<AttendanceRequest>>> getAttendanceRequests(
    GetAttendanceRequestsParams params,
  ) async {
    try {
      final user = await loginLocalDatasource.getLogin();
      final request = mapper
          .convert<GetAttendanceRequestsParams, GetAttendanceRequestsRequest>(
            params,
          )
          .copyWith(userId: user.userId);
      final pagination = PaginationRequest(
        page: params.page,
        limit: params.limit,
      );
      logger.d(
        "AttendanceRequestRepositoryImpl.getAttendanceRequests request: ${request.toJson()}\n pagination: ${pagination.toJson()}",
      );
      final response = await remoteDatasource.getAttendanceRequests(
        request,
        pagination,
      );

      final attendanceRequests = response
          .map(
            (v) =>
                mapper.convert<AttendanceRequestResponse, AttendanceRequest>(v),
          )
          .toList();
      return Right(attendanceRequests);
    } on GraphQlException catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "AttendanceRequestRepositoryImpl.getAttendanceRequests graphQL",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "AttendanceRequestRepositoryImpl.getAttendanceRequests unknown",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> createAttendanceRequest(
    CreateAttendanceRequestParams params,
  ) async {
    try {
      final request = mapper
          .convert<
            CreateAttendanceRequestParams,
            CreateAttendanceRequestRequest
          >(params);
      logger.d(
        "AttendanceRequestRepositoryImpl.createAttendanceRequest request: ${request.toJson()}\n attachments: ${params.attachments}",
      );
      await remoteDatasource.createAttendanceRequest(
        request,
        params.attachments,
      );

      return Right(null);
    } on GraphQlException catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "AttendanceRequestRepositoryImpl.createAttendanceRequest graphQL",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "AttendanceRequestRepositoryImpl.createAttendanceRequest unknown",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateAttendanceRequest(
    String id,
    CreateAttendanceRequestParams params,
  ) async {
    try {
      final request = mapper
          .convert<
            CreateAttendanceRequestParams,
            CreateAttendanceRequestRequest
          >(params);
      await remoteDatasource.updateAttendanceRequest(
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
  Future<Either<Failure, void>> deleteAttendanceRequest(String id) async {
    try {
      await remoteDatasource.deleteAttendanceRequest(id);
      return const Right(null);
    } on GraphQlException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (_) {
      return Left(UnknownFailure());
    }
  }
}
