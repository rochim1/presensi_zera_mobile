import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:presensi_data/core/mapper/app_mappr.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class PresensiRepositoryImpl extends PresensiRepository {
  final PresensiRemoteDatasource remoteDatasource;
  final AppMappr mapper;
  final Logger log;

  PresensiRepositoryImpl({
    required this.remoteDatasource,
    required this.mapper,
    required this.log,
  });

  @override
  Future<Either<Failure, List<PresensiEntity>>> getAllData(
    PresensiFilterEntity params,
  ) async {
    try {
      final data = await remoteDatasource.getAllData(params);

      return Right(data);
    } catch (e, s) {
      if (e is! NotFoundException) {
        log.e(e.toString(), stackTrace: s);
      }
      if (e is GraphQlException) {
        return Left(ServerFailure(message: e.message, code: e.code));
      } else if (e is NotFoundException) {
        return Left(NotFoundFailure());
      } else {
        return Left(UnknownFailure());
      }
    }
  }

  @override
  Future<Either<Failure, PresensiEntity>> breakIn(BreakInParams params) async {
    try {
      final request = mapper.convert<BreakInParams, BreakInRequest>(params);
      log.d("PresensiRepositoryImpl.breakIn: $request");
      final data = await remoteDatasource.breakIn(request);

      return Right(data);
    } catch (e, s) {
      if (e is! CacheException) log.e("PresensiRepositoryImpl.breakIn", error: e, stackTrace: s);
      if (e is GraphQlException) {
        if (e.code != BAD_REQUEST) log.e(e.toString(), stackTrace: s);
        return Left(ServerFailure(message: e.message, code: e.code));
      } else {
        return Left(UnknownFailure());
      }
    }
  }

  @override
  Future<Either<Failure, PresensiEntity>> breakOut(
    BreakOutParams params,
  ) async {
    try {
      final request = mapper.convert<BreakOutParams, BreakOutRequest>(params);
      log.d("PresensiRepositoryImpl.breakOut: $request");
      final data = await remoteDatasource.breakOut(request);

      return Right(data);
    } catch (e, s) {
      if (e is GraphQlException) {
        if (e.code != BAD_REQUEST) log.e(e.toString(), stackTrace: s);
        return Left(ServerFailure(message: e.message, code: e.code));
      } else {
        return Left(UnknownFailure());
      }
    }
  }

  @override
  Future<Either<Failure, PresensiEntity>> checkIn(CheckInParams params) async {
    try {
      final request = mapper.convert<CheckInInputParams, CheckInRequest>(
        params.input,
      );
      log.d("PresensiRepositoryImpl.checkIn: $request");
      final data = await remoteDatasource.checkIn(
        request,
        params.fotoPresensi,
        params.fotoPendukung,
      );

      return Right(data);
    } catch (e, s) {
      if (e is! CacheException) log.e(e.toString(), stackTrace: s);
      if (e is GraphQlException) {
        return Left(ServerFailure(message: e.message, code: e.code));
      } else {
        return Left(UnknownFailure());
      }
    }
  }

  @override
  Future<Either<Failure, PresensiEntity>> checkOut(
    CheckOutParams params,
  ) async {
    try {
      final request = mapper.convert<CheckOutInputParams, CheckOutRequest>(
        params.input,
      );
      log.d("PresensiRepositoryImpl.checkOut: $request");
      final data = await remoteDatasource.checkOut(
        request,
        params.fotoPresensi,
        params.fotoPendukung,
      );

      return Right(data);
    } catch (e, s) {
      if (e is! CacheException) log.e(e.toString(), stackTrace: s);
      if (e is GraphQlException) {
        return Left(ServerFailure(message: e.message, code: e.code));
      } else {
        return Left(UnknownFailure());
      }
    }
  }

  @override
  Future<Either<Failure, PresensiEntity>> getOne(
    PresensiGetOneParams params,
  ) async {
    try {
      final data = await remoteDatasource.getOne(params);

      return Right(data);
    } catch (e, s) {
      if (e is! NotFoundException) {
        log.e(e.toString(), stackTrace: s);
      }
      if (e is GraphQlException) {
        return Left(ServerFailure(message: e.message, code: e.code));
      } else if (e is NotFoundException) {
        return Left(NotFoundFailure());
      } else {
        return Left(UnknownFailure());
      }
    }
  }
}
