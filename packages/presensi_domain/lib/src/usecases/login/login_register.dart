import 'package:dartz/dartz.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class LoginRegister extends UseCase<bool, RegisterParamsEntity> {
  final LoginRepository loginRepository;

  LoginRegister(this.loginRepository);

  @override
  Future<Either<Failure, bool>> call(RegisterParamsEntity params) async {
    final data = await loginRepository.register(params);
    return data.fold((failure) => Left(failure), (value) => Right(value));
  }
}
