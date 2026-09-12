import 'package:dartz/dartz.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class GlobalPostTokenFcm extends UseCase<String?, GlobalFcmParamsEntity> {
  final GlobalRepository globalRepository;

  GlobalPostTokenFcm(this.globalRepository);

  @override
  Future<Either<Failure, String?>> call(GlobalFcmParamsEntity params) async {
    Either<Failure, String?> data = await globalRepository.postTokenFcm(params);

    return data.fold((failure) => Left(failure), (value) => Right(value));
  }
}
