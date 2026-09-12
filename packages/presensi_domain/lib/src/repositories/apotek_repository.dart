import 'package:dartz/dartz.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

abstract class ApotekRepository {
  /// get all Apotek
  Future<Either<Failure, List<ApotekEntity>>> getAllData(
    ApotekFilterEntity params,
  );

  /// create Apotek
  Future<Either<Failure, ApotekEntity>> postData(ApotekParamsEntity params);
}
