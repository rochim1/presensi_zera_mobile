import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:presensi_data/core/mapper/app_mappr.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class AuthRepositoryImpl implements AuthRepository {
  final LoginLocalDatasource loginLocalDatasource;
  final AppMappr mapper;
  final Logger logger;

  AuthRepositoryImpl({
    required this.loginLocalDatasource,
    required this.mapper,
    required this.logger,
  });

  @override
  Future<Either<Failure, AuthSession>> getAuthSession() async {
    try {
      final login = await loginLocalDatasource.getLogin();

      final session = AuthSession(
        token: login.token ?? '',
        appId: login.appId ?? '',
        userId: login.userId,
      );

      return Right(session);
    } catch (e, stackTrace) {
      if (e is! CacheException) logger.e(
        "AuthRepositoryImpl.getAuthSession unknown",
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure());
    }
  }
}
