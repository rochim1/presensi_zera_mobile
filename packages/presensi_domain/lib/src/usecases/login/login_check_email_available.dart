import 'package:dartz/dartz.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class LoginCheckEmailAvailable extends UseCase<bool, String> {
  final LoginRepository loginRepository;

  LoginCheckEmailAvailable(this.loginRepository);

  @override
  Future<Either<Failure, bool>> call(String params) async {
    final data = await loginRepository.checkEmailAvailable(params);
    return data.fold((failure) => Left(failure), (value) => Right(value));
  }
}
