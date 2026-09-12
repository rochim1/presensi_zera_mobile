import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class UserPostImage extends UseCase<String?, MultipartFile?> {
  final UserRepository userRepository;

  UserPostImage(this.userRepository);

  @override
  Future<Either<Failure, String?>> call(MultipartFile? params) async {
    Either<Failure, String?> data = await userRepository.updateImage(params);

    return data.fold((failure) => Left(failure), (value) => Right(value));
  }
}
