import 'package:dartz/dartz.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class ApotekPostData extends UseCase<ApotekEntity, ApotekParamsEntity> {
  final ApotekRepository apotekRepository;

  ApotekPostData(this.apotekRepository);

  @override
  Future<Either<Failure, ApotekEntity>> call(ApotekParamsEntity params) async {
    final Either<Failure, ApotekEntity> data = await apotekRepository.postData(
      params,
    );

    return data.fold((failure) => Left(failure), (value) => Right(value));
  }
}
