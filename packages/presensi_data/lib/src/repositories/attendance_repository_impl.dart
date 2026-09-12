import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:presensi_data/core/mapper/app_mappr.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRemoteDatasource remoteDatasource;
  final LoginLocalDatasource loginLocalDatasource;
  final AppMappr mapper;
  final Logger logger;

  AttendanceRepositoryImpl({
    required this.remoteDatasource,
    required this.loginLocalDatasource,
    required this.mapper,
    required this.logger,
  });

  @override
  Future<Either<Failure, Attendance>> getActiveAttendance() async {
    try {
      final user = await loginLocalDatasource.getLogin();
      final request = GetActiveAttendanceRequest(userId: user.userId);
      final response = await remoteDatasource.getActiveAttendance(request);

      final attendance = mapper.convert<AttendanceResponse, Attendance>(
        response,
      );
      return Right(attendance);
    } on GraphQlException catch (e, stackTrace) {
      if (e is! CacheException) logger.e(
        "AttendanceRepositoryImpl.getActiveAttendance graphQL",
        error: e,
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NotFoundException {
      return Left(NotFoundFailure(message: 'Tidak ada presensi aktif'));
    } catch (e, stackTrace) {
      if (e is! CacheException) logger.e(
        "AttendanceRepositoryImpl.getActiveAttendance unknown",
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<Attendance>>> getAttendances(
    GetAttendancesParams params,
  ) async {
    try {
      final request = mapper
          .convert<GetAttendancesParams, GetAttendancesRequest>(params);
      final pagination = mapper.convert<PaginationParams, PaginationRequest>(
        params,
      );

      final data = await remoteDatasource.getAttendances(request, pagination);
      final entities = data
          .map((e) => mapper.convert<AttendanceResponse, Attendance>(e))
          .toList();

      return Right(entities);
    } on GraphQlException catch (e, stackTrace) {
      if (e is! CacheException) logger.e(
        "AttendanceRepositoryImpl.getAttendances graphQL",
        error: e,
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NotFoundException {
      return Left(NotFoundFailure());
    } catch (e, stackTrace) {
      if (e is! CacheException) logger.e(
        "AttendanceRepositoryImpl.getAttendances unknown",
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, Attendance>> getAttendanceById(String id) async {
    try {
      final data = await remoteDatasource.getAttendanceById(id);

      return Right(mapper.convert<AttendanceResponse, Attendance>(data));
    } on GraphQlException catch (e, stackTrace) {
      if (e is! CacheException) logger.e(
        "AttendanceRepositoryImpl.getAttendanceById graphQL",
        error: e,
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NotFoundException {
      return Left(NotFoundFailure());
    } catch (e, stackTrace) {
      if (e is! CacheException) logger.e(
        "AttendanceRepositoryImpl.getAttendanceById unknown",
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<AttendanceStatistic>>> getAttendanceStatistics(
    GetAttendancesParams params,
  ) async {
    try {
      final request = mapper
          .convert<GetAttendancesParams, GetAttendancesRequest>(params);
      final data = await remoteDatasource.getAttendanceStatistics(request);
      final entities = data
          .map(
            (e) => mapper
                .convert<AttendanceStatisticResponse, AttendanceStatistic>(e),
          )
          .toList();

      return Right(entities);
    } on GraphQlException catch (e, stackTrace) {
      if (e is! CacheException) logger.e(
        "AttendanceRepositoryImpl.getAttendanceStatistics graphQL",
        error: e,
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      if (e is! CacheException) logger.e(
        "AttendanceRepositoryImpl.getAttendanceStatistics unknown",
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, HomeAlert>> getHomeAlert() async {
    try {
      final user = await loginLocalDatasource.getLogin();
      final response = await remoteDatasource.getHomeAlert(user.userId);
      return Right(response.toEntity());
    } on GraphQlException catch (e, stackTrace) {
      if (e is! CacheException) logger.e(
        "AttendanceRepositoryImpl.getHomeAlert graphQL",
        error: e,
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      if (e is! CacheException) logger.e(
        "AttendanceRepositoryImpl.getHomeAlert unknown",
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, EffectiveSchedule>> getEffectiveScheduleToday() async {
    try {
      final user = await loginLocalDatasource.getLogin();
      final response = await remoteDatasource.getEffectiveScheduleToday(user.userId);
      return Right(response.toEntity());
    } on GraphQlException catch (e, stackTrace) {
      if (e is! CacheException) logger.e(
        "AttendanceRepositoryImpl.getEffectiveScheduleToday graphQL",
        error: e,
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NotFoundException {
      return Left(NotFoundFailure(message: 'Tidak ada jadwal efektif hari ini'));
    } catch (e, stackTrace) {
      if (e is! CacheException) logger.e(
        "AttendanceRepositoryImpl.getEffectiveScheduleToday unknown",
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure());
    }
  }
}
