import 'package:dartz/dartz.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class UserPost extends UseCase<String?, UserParamsEntity> {
  final UserRepository userRepository;

  UserPost(this.userRepository);

  @override
  Future<Either<Failure, String?>> call(UserParamsEntity params) async {
    Either<Failure, String?> data = await userRepository.updateUser(params);

    return data.fold((failure) => Left(failure), (value) => Right(value));
  }
}
