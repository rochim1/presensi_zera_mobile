import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_data/presensi_data.dart';

class LoginRepositoryImpl extends LoginRepository {
  final LoginRemoteDatasource remoteDatasource;
  final LoginLocalDatasource localDatasource;
  final Logger log;

  LoginRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
    required this.log,
  });

  @override
  Future<Either<Failure, LoginUserEntity>> signIn(
    LoginParamsEntity params,
  ) async {
    try {
      LoginUserEntity user = await remoteDatasource.signIn(params);

      await localDatasource.cacheLogin(user as LoginUserModel);

      return Right(user);
    } catch (e, s) {
      if (e is! CacheException) log.e(e.toString(), stackTrace: s);
      if (e is GraphQlException) {
        return Left(ServerFailure(message: e.message, code: e.code));
      } else if (e is CacheException) {
        return Left(CacheFailure());
      } else {
        return Left(UnknownFailure());
      }
    }
  }

  @override
  Future<Either<Failure, bool>> register(RegisterParamsEntity params) async {
    try {
      final result = await remoteDatasource.register(params);
      return Right(result);
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
  Future<Either<Failure, bool>> checkEmailAvailable(String email) async {
    try {
      final result = await remoteDatasource.checkEmailAvailable(email);
      return Right(result);
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
  Future<Either<Failure, bool>> checkUsernameAvailable(String username) async {
    try {
      final result = await remoteDatasource.checkUsernameAvailable(username);
      return Right(result);
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
  Future<Either<Failure, bool>> signOut() async {
    try {
      // Logout tidak boleh tertahan oleh queryRequestTimeout global yang pada
      // production dapat sangat panjang. Sesi lokal tetap harus dibersihkan
      // walaupun server sedang tidak dapat dijangkau.
      final result = await remoteDatasource.signOut().timeout(
        const Duration(seconds: 10),
      );
      await localDatasource.signOut();

      return Right(result);
    } catch (e, s) {
      await localDatasource.signOut();
      log.e(e.toString(), stackTrace: s);
      if (e is TimeoutException) {
        return Left(
          ServerFailure(
            message: 'Server tidak merespons. Sesi lokal telah dihapus.',
            code: 'LOGOUT_TIMEOUT',
          ),
        );
      } else if (e is GraphQlException) {
        return Left(ServerFailure(message: e.message, code: e.code));
      } else if (e is CacheException) {
        return Left(CacheFailure());
      } else {
        return Left(UnknownFailure());
      }
    }
  }

  @override
  Future<Either<Failure, String?>> checkLogin() async {
    try {
      LoginUserEntity data = await localDatasource.checkLogin();

      return Right(data.token);
    } catch (e, s) {
      if (e is! CacheException) log.e(e.toString(), stackTrace: s);
      if (e is CacheException) {
        return Left(CacheFailure());
      } else {
        return Left(UnknownFailure());
      }
    }
  }

  @override
  Future<Either<Failure, LoginUserEntity?>> getLocal() async {
    try {
      LoginUserEntity data = await localDatasource.getLogin();

      return Right(data);
    } catch (e, s) {
      if (e is! CacheException) log.e(e.toString(), stackTrace: s);
      if (e is CacheException) {
        return Left(CacheFailure());
      } else {
        return Left(UnknownFailure());
      }
    }
  }
}
