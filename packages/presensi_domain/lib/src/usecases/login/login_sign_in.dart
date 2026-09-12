import 'package:presensi_data/presensi_data.dart';
import 'package:dartz/dartz.dart';
import 'package:presensi_domain/presensi_domain.dart';

class LoginSignIn extends UseCase<LoginUserEntity, LoginParamsEntity> {
  final LoginRepository loginRepository;

  LoginSignIn(this.loginRepository);

  @override
  Future<Either<Failure, LoginUserEntity>> call(
    LoginParamsEntity params,
  ) async {
    Either<Failure, LoginUserEntity> data = await loginRepository.signIn(
      params,
    );

    return data.fold((failure) => Left(failure), (value) => Right(value));
  }
}
