import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class GetUserById extends UseCase<User, String> {
  final UserRepository repository;

  GetUserById({required this.repository});

  @override
  Future<Either<Failure, User>> call(params) {
    return repository.getUserById(params);
  }
}
