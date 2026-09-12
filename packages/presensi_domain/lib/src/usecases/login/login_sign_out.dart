import 'package:dartz/dartz.dart';
import 'package:presensi_domain/presensi_domain.dart';

import 'package:presensi_data/presensi_data.dart';

class LoginSignOut extends UseCase<bool, NoParams> {
  final LoginRepository authRepository;
  final GlobalRepository globalRepository;

  LoginSignOut({required this.authRepository, required this.globalRepository});

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    Either<Failure, bool> data = await authRepository.signOut();
    await globalRepository.distroyQueries(KEY_QUERY_APOTEK);
    return data.fold((failure) => Left(failure), (value) => Right(value));
  }
}
