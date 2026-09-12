import 'package:presensi_data/core/_core.dart';
import 'package:dartz/dartz.dart';
import 'package:presensi_domain/presensi_domain.dart';

abstract class LoginRepository {
  /// get data local of login
  Future<Either<Failure, LoginUserEntity?>> getLocal();

  /// check local auth end return 'token'
  Future<Either<Failure, String?>> checkLogin();

  /// login with username and password
  Future<Either<Failure, LoginUserEntity>> signIn(LoginParamsEntity params);

  /// register new user
  Future<Either<Failure, bool>> register(RegisterParamsEntity params);

  /// check email availability
  Future<Either<Failure, bool>> checkEmailAvailable(String email);

  /// check username availability
  Future<Either<Failure, bool>> checkUsernameAvailable(String username);

  /// logout auth
  Future<Either<Failure, bool>> signOut();
}
