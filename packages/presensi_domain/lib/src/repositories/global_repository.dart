import 'package:dartz/dartz.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

abstract class GlobalRepository {
  /// check version BE
  Future<Either<Failure, String?>> getVersion();

  /// post token FCM
  Future<Either<Failure, String?>> postTokenFcm(GlobalFcmParamsEntity params);

  /// get list of history feature search
  Future<Either<Failure, List<GlobalQueryEntity>>> getQuery(String boxKey);

  /// save query for history feature search
  Future<Either<Failure, String?>> postQuery(
    GlobalQueryEntity params,
    String boxKey,
  );

  Future<Either<Failure, String?>> distroyQueries(String boxKey);
}
