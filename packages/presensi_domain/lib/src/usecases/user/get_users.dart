import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class GetUsers extends UseCase<List<User>, GetUsersParams> {
  final UserRepository repository;

  GetUsers({required this.repository});

  @override
  Future<Either<Failure, List<User>>> call(GetUsersParams params) {
    return repository.getUsers(params);
  }
}
