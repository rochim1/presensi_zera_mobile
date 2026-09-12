import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class TasksRepositoryImpl extends TasksRepository {
  final TasksRemoteDatasource remoteDatasource;
  final Logger log;

  TasksRepositoryImpl({required this.remoteDatasource, required this.log});

  @override
  Future<Either<Failure, List<TasksEntity>>> getAllData(
    TasksFilterEntity params,
  ) async {
    try {
      final data = await remoteDatasource.getAllData(params);

      return Right(data);
    } catch (e, s) {
      if (e is! CacheException) log.e(e.toString(), stackTrace: s);
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
  Future<Either<Failure, TasksEntity>> postData(
    TasksParamsEntity params,
  ) async {
    try {
      log.d(params.toJson());
      final data = await remoteDatasource.postData(params);

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
  Future<Either<Failure, List<ApotekEntity>>> getAllApotek() async {
    try {
      final data = await remoteDatasource.getAllApotek();

      return Right(data);
    } catch (e, s) {
      if (e is! CacheException) log.e(e.toString(), stackTrace: s);
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
  Future<Either<Failure, TasksEntity>> postCompleted(
    TasksCompletedParamsEntity params,
  ) async {
    try {
      log.d(params.toJson());
      final data = await remoteDatasource.postCompleted(params);

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
  Future<Either<Failure, TasksEntity>> postCanceled(
    TasksCanceledParamsEntity params,
  ) async {
    try {
      log.d(params.toJson());
      final data = await remoteDatasource.postCanceled(params);

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
  Future<Either<Failure, List<TasksEntity>>> getAllPerjalaan(
    TasksFilterEntity params,
  ) async {
    try {
      final data = await remoteDatasource.getAllPerjalanan(params);

      return Right(data);
    } catch (e, s) {
      if (e is! CacheException) log.e(e.toString(), stackTrace: s);
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
