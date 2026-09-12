import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:presensi_data/core/mapper/app_mappr.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class SettingRepositoryImpl implements SettingRepository {
  final SettingRemoteDatasource remoteDatasource;
  final LoginLocalDatasource loginLocalDatasource;
  final AppMappr mapper;
  final Logger logger;

  SettingRepositoryImpl({
    required this.remoteDatasource,
    required this.mapper,
    required this.logger,
    required this.loginLocalDatasource,
  });

  @override
  Future<Either<Failure, Setting>> getSettingByOrganizationId(
    GetSettingParams params,
  ) async {
    try {
      final response = await remoteDatasource.getSettingByOrganizationId(
        params.organizationId,
        params.userId,
      );

      final setting = mapper.convert<SettingResponse, Setting>(response);
      return Right(setting);
    } on GraphQlException catch (e, stackTrace) {
      if (e is! CacheException) logger.e(
        "SettingRepositoryImpl.getSetting graphQL",
        error: e,
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      if (e is! CacheException) logger.e(
        "SettingRepositoryImpl.getSetting unknown",
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure());
    }
  }
}
