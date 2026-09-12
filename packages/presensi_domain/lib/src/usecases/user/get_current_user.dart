import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class GetCurrentUser extends UseCase<User, NoParams> {
  final UserRepository repository;

  GetCurrentUser({required this.repository});

  @override
  Future<Either<Failure, User>> call(params) async {
    final userId = await repository.getCurrentUserId();
    return repository.getUserById(userId ?? '');
  }
}
