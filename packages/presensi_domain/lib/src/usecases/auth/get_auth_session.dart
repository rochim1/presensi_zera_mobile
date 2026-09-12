import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class GetAuthSession extends UseCase<AuthSession, NoParams> {
  final AuthRepository repository;

  GetAuthSession({required this.repository});

  @override
  Future<Either<Failure, AuthSession>> call(params) {
    return repository.getAuthSession();
  }
}
