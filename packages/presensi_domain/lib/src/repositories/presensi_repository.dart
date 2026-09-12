import 'package:dartz/dartz.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

abstract class PresensiRepository {
  /// get all log presensi
  Future<Either<Failure, List<PresensiEntity>>> getAllData(
    PresensiFilterEntity params,
  );

  /// get one presensi
  Future<Either<Failure, PresensiEntity>> getOne(PresensiGetOneParams params);

  /// create Masuk kerja
  Future<Either<Failure, PresensiEntity>> checkIn(CheckInParams params);

  /// create Pulang Kerja
  Future<Either<Failure, PresensiEntity>> checkOut(CheckOutParams params);

  /// create Start Istirahat
  Future<Either<Failure, PresensiEntity>> breakIn(BreakInParams params);

  /// create End Istirahat
  Future<Either<Failure, PresensiEntity>> breakOut(BreakOutParams params);

}
