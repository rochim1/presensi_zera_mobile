import 'package:dartz/dartz.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class LoginCheckUsernameAvailable extends UseCase<bool, String> {
  final LoginRepository loginRepository;

  LoginCheckUsernameAvailable(this.loginRepository);

  @override
  Future<Either<Failure, bool>> call(String params) async {
    final data = await loginRepository.checkUsernameAvailable(params);
    return data.fold((failure) => Left(failure), (value) => Right(value));
  }
}
