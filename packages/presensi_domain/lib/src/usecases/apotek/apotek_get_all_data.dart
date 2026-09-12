import 'package:dartz/dartz.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class ApotekGetAllData extends UseCase<List<ApotekEntity>, ApotekFilterEntity> {
  final ApotekRepository apotekRepository;

  ApotekGetAllData(this.apotekRepository);

  @override
  Future<Either<Failure, List<ApotekEntity>>> call(
    ApotekFilterEntity params,
  ) async {
    final Either<Failure, List<ApotekEntity>> data = await apotekRepository
        .getAllData(params);

    return data.fold((failure) => Left(failure), (value) => Right(value));
  }
}
