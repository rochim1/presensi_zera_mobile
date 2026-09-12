import 'package:dartz/dartz.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class PresensiGetAllData
    extends UseCase<List<PresensiEntity>, PresensiFilterEntity> {
  final PresensiRepository presensiRepository;

  PresensiGetAllData(this.presensiRepository);

  @override
  Future<Either<Failure, List<PresensiEntity>>> call(
    PresensiFilterEntity params,
  ) async {
    final Either<Failure, List<PresensiEntity>> data = await presensiRepository
        .getAllData(params);

    return data.fold((failure) => Left(failure), (value) => Right(value));
  }
}
