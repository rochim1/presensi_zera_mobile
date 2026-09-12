import 'package:dartz/dartz.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class LoginCheck extends UseCase<LoginUserEntity?, NoParams> {
  final LoginRepository loginRepository;
  final UserRepository userRepository;

  LoginCheck({required this.loginRepository, required this.userRepository});

  @override
  Future<Either<Failure, LoginUserEntity?>> call(NoParams params) async {
    Either<Failure, LoginUserEntity?> data = await loginRepository.getLocal();

    return data.fold((failure) => Left(failure), (value) => Right(value));
  }
}
