import 'package:dartz/dartz.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class UserGetData extends UseCase<LoginUserEntity, NoParams> {
  final UserRepository userRepository;

  UserGetData(this.userRepository);

  @override
  Future<Either<Failure, LoginUserEntity>> call(NoParams params) async {
    Either<Failure, LoginUserEntity> data = await userRepository.getUserData();

    return data.fold((failure) => Left(failure), (value) => Right(value));
  }
}
