import 'package:dartz/dartz.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class PresensiGetOne extends UseCase<PresensiEntity, PresensiGetOneParams> {
  final PresensiRepository presensiRepository;

  PresensiGetOne(this.presensiRepository);

  @override
  Future<Either<Failure, PresensiEntity>> call(params) async {
    final Either<Failure, PresensiEntity> data = await presensiRepository
        .getOne(params);

    return data.fold((failure) => Left(failure), (value) => Right(value));
  }
}
