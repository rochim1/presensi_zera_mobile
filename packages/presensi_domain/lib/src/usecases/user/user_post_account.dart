import 'package:dartz/dartz.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class UserPostAccount extends UseCase<String, UserParamsEntity> {
  final UserRepository userRepository;

  UserPostAccount(this.userRepository);

  @override
  Future<Either<Failure, String>> call(UserParamsEntity params) async {
    Either<Failure, String> data = await userRepository.updateAccount(params);

    return data.fold((failure) => Left(failure), (value) => Right(value));
  }
}
