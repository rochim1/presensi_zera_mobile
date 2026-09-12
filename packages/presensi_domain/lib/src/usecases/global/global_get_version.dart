import 'package:dartz/dartz.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class GlobalGetVersion extends UseCase<String?, NoParams> {
  final GlobalRepository globalRepository;

  GlobalGetVersion(this.globalRepository);

  @override
  Future<Either<Failure, String?>> call(NoParams params) async {
    Either<Failure, String?> data = await globalRepository.getVersion();

    return data.fold((failure) => Left(failure), (value) => Right(value));
  }
}
