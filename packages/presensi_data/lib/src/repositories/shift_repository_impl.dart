import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:presensi_data/core/mapper/app_mappr.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class ShiftRepositoryImpl implements ShiftRepository {
  final ShiftRemoteDatasource remoteDatasource;
  final LoginLocalDatasource loginLocalDatasource;
  final AppMappr mapper;
  final Logger logger;

  ShiftRepositoryImpl({
    required this.remoteDatasource,
    required this.loginLocalDatasource,
    required this.mapper,
    required this.logger,
  });

  @override
  Future<Either<Failure, void>> createShiftSwapRequest(
    CreateShiftSwapRequestParams params,
  ) async {
    try {
      await remoteDatasource.createShiftSwapRequest(
        CreateShiftSwapRequestRequest(params),
      );
      return const Right(null);
    } on GraphQlException catch (e, stackTrace) {
      logger.e(
        'ShiftRepositoryImpl.createShiftSwapRequest graphQL',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      logger.e(
        'ShiftRepositoryImpl.createShiftSwapRequest unknown',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> cancelShiftSwapRequest(String id) async {
    try {
      await remoteDatasource.cancelShiftSwapRequest(id);
      return const Right(null);
    } on GraphQlException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (_) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateShiftSwapRequest(
    String id,
    CreateShiftSwapRequestParams params,
  ) async {
    try {
      await remoteDatasource.updateShiftSwapRequest(
        id,
        CreateShiftSwapRequestRequest(params),
      );
      return const Right(null);
    } on GraphQlException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (_) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> createShiftSwapRequestApproval(
    CreateShiftSwapRequestApprovalParams params,
  ) async {
    try {
      final request = mapper
          .convert<
            CreateShiftSwapRequestApprovalParams,
            CreateShiftSwapRequestApprovalRequest
          >(params);
      logger.d(
        "ShiftRepositoryImpl.createShiftSwapRequestApproval request: ${request.toJson()}",
      );
      await remoteDatasource.createShiftSwapRequestApproval(request);

      return Right(null);
    } on GraphQlException catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "ShiftRepositoryImpl.createShiftSwapRequestApproval graphQL",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "ShiftRepositoryImpl.createShiftSwapRequestApproval unknown",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<AvailableShiftForSwap>>>
  getAvailableShiftsForSwap(GetAvailableShiftsForSwapParams params) async {
    try {
      final request = mapper
          .convert<
            GetAvailableShiftsForSwapParams,
            GetAvailableShiftsForSwapRequest
          >(params);
      logger.d(
        "ShiftRepositoryImpl.getAvailableShiftsForSwap params: ${params as Object}",
      );

      final response = await remoteDatasource.getAvailableShiftsForSwap(
        request,
      );
      final result = response
          .map(
            (v) => mapper
                .convert<AvailableShiftForSwapResponse, AvailableShiftForSwap>(
                  v,
                ),
          )
          .toList();

      return Right(result);
    } on GraphQlException catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "ShiftRepositoryImpl.getAvailableShiftsForSwap graphQL",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "ShiftRepositoryImpl.getAvailableShiftsForSwap unknown",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, ShiftSchedule>> getShiftScheduleById(String id) async {
    try {
      final response = await remoteDatasource.getShiftScheduleById(id);

      return Right(
        mapper.convert<ShiftScheduleResponse, ShiftSchedule>(response),
      );
    } on GraphQlException catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "ShiftRepositoryImpl.getShiftScheduleById graphQL",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NotFoundException {
      return Left(NotFoundFailure());
    } catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "ShiftRepositoryImpl.getShiftScheduleById unknown",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<ShiftSchedule>>> getShiftSchedules(
    GetShiftSchedulesParams params,
  ) async {
    try {
      final user = await loginLocalDatasource.getLogin();
      final request = mapper
          .convert<GetShiftSchedulesParams, GetShiftSchedulesRequest>(params)
          .copyWith(userId: user.userId);
      logger.d(
        "ShiftRepositoryImpl.getShiftSchedules params: ${params as Object}",
      );

      final response = await remoteDatasource.getShiftSchedules(request);
      final shiftSchedules = response
          .map((v) => mapper.convert<ShiftScheduleResponse, ShiftSchedule>(v))
          .toList();

      return Right(shiftSchedules);
    } on GraphQlException catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "ShiftRepositoryImpl.getShiftSchedules graphQL",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "ShiftRepositoryImpl.getShiftSchedules unknown",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<ShiftSwapRequest>>> getShiftSwapRequests(
    GetShiftSwapRequestsParams params,
  ) async {
    try {
      final request = mapper
          .convert<GetShiftSwapRequestsParams, GetShiftSwapRequestsRequest>(
            params,
          );
      logger.d(
        "ShiftRepositoryImpl.getShiftSwapRequests params: ${params as Object}",
      );

      final response = await remoteDatasource.getShiftSwapRequests(request);
      final result = response
          .map(
            (v) =>
                mapper.convert<ShiftSwapRequestResponse, ShiftSwapRequest>(v),
          )
          .toList();

      return Right(result);
    } on GraphQlException catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "ShiftRepositoryImpl.getShiftSwapRequests graphQL",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "ShiftRepositoryImpl.getShiftSwapRequests unknown",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<ShiftSchedule>>> getMyShiftSchedules(
    GetMyShiftSchedulesParams params,
  ) async {
    try {
      final request = mapper
          .convert<GetMyShiftSchedulesParams, GetMyShiftSchedulesRequest>(
            params,
          );
      logger.d(
        "ShiftRepositoryImpl.getMyShiftSchedules params: ${params as Object}",
      );

      final response = await remoteDatasource.getMyShiftSchedules(request);
      final shiftSchedules = response
          .map((v) => mapper.convert<ShiftScheduleResponse, ShiftSchedule>(v))
          .toList();

      return Right(shiftSchedules);
    } on GraphQlException catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "ShiftRepositoryImpl.getMyShiftSchedules graphQL",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "ShiftRepositoryImpl.getMyShiftSchedules unknown",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<ShiftSwapRequest>>> getMyShiftSwapRequests(
    GetMyShiftSwapRequestsParams params,
  ) async {
    try {
      final request = mapper
          .convert<GetMyShiftSwapRequestsParams, GetMyShiftSwapRequestsRequest>(
            params,
          );
      logger.d(
        "ShiftRepositoryImpl.getMyShiftSwapRequests params: ${params as Object}",
      );

      final response = await remoteDatasource.getMyShiftSwapRequests(request);
      final result = response
          .map(
            (v) =>
                mapper.convert<ShiftSwapRequestResponse, ShiftSwapRequest>(v),
          )
          .toList();

      return Right(result);
    } on GraphQlException catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "ShiftRepositoryImpl.getMyShiftSwapRequests graphQL",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "ShiftRepositoryImpl.getMyShiftSwapRequests unknown",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(UnknownFailure());
    }
  }
}
