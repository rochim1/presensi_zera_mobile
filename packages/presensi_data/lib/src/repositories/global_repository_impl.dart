import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class GlobalRepositoryImpl extends GlobalRepository {
  final GlobalRemoteDatasource globalRemoteDatasource;
  final LoginLocalDatasource loginLocalDatasource;
  final GlobalLocalDatasource globalLocalDatasource;
  final Logger log;

  GlobalRepositoryImpl({
    required this.globalRemoteDatasource,
    required this.globalLocalDatasource,
    required this.loginLocalDatasource,
    required this.log,
  });

  @override
  Future<Either<Failure, String?>> getVersion() async {
    try {
      final data = await globalRemoteDatasource.getVersion();

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
  Future<Either<Failure, String?>> postTokenFcm(
    GlobalFcmParamsEntity params,
  ) async {
    try {
      final data = await globalRemoteDatasource.postTokenFcm(params);
      final user = await loginLocalDatasource.getLogin() as LoginUserModel;

      final cpUser = user.copyWith(appId: params.appsId);

      await loginLocalDatasource.cacheLogin(cpUser);

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
  Future<Either<Failure, List<GlobalQueryEntity>>> getQuery(
    String boxKey,
  ) async {
    try {
      final data = await globalLocalDatasource.getQuery(boxKey);
      List<GlobalQueryEntity> lsQuery = data.length >= LAST_DATA
          ? data.sublist(data.length - LAST_DATA)
          : data;
      return Right(lsQuery);
    } catch (e, s) {
      if (e is! CacheException) log.e(e.toString(), stackTrace: s);
      if (e is CacheException) {
        return Left(CacheFailure(message: e.message));
      } else {
        return Left(UnknownFailure());
      }
    }
  }

  @override
  Future<Either<Failure, String?>> postQuery(
    GlobalQueryEntity params,
    String boxKey,
  ) async {
    try {
      final query = GlobalQueryModel(
        query: params.query,
        createAt: params.createAt,
        boxKey: params.boxKey,
      );

      final data = await globalLocalDatasource.getQuery(boxKey);

      //! check data duplicate
      bool hasData = data.any((element) => element.query == query.query);
      if (hasData) return Right(FAILED_ADD_DATA);

      await globalLocalDatasource.cacheQuery(query, boxKey);

      return Right(SUCCESS_CREATE_DATA);
    } catch (e, s) {
      if (e is! CacheException) log.e(e.toString(), stackTrace: s);
      if (e is CacheException) {
        return Left(CacheFailure(message: e.message));
      } else {
        return Left(UnknownFailure());
      }
    }
  }

  @override
  Future<Either<Failure, String?>> distroyQueries(String boxKey) async {
    try {
      await globalLocalDatasource.deleteQueries(boxKey);
      return Right(SUCCESS_DELETE_DATA);
    } catch (e, s) {
      if (e is! CacheException) log.e(e.toString(), stackTrace: s);
      if (e is CacheException) {
        return Left(CacheFailure(message: e.message));
      } else {
        return Left(UnknownFailure());
      }
    }
  }
}
