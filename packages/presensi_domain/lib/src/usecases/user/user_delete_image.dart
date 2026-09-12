import 'package:dartz/dartz.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class UserDeleteImage extends UseCase<String?, NoParams> {
  final UserRepository userRepository;

  UserDeleteImage(this.userRepository);

  @override
  Future<Either<Failure, String?>> call(NoParams _) async {
    Either<Failure, LoginUserEntity> user = await userRepository.getUserLocal();

    return user.fold((failure) => Left(failure), (xUser) async {
      final params = UserParamsEntity(
        userId: xUser.userId,
        isFotoDeleted: true,
      );
      Either<Failure, String?> data = await userRepository.deleteImage(params);

      return data.fold((failure) => Left(failure), (value) => Right(value));
    });
  }
}
