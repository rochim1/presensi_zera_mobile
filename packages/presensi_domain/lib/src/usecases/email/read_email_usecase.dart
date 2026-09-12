import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/src/repositories/email_repository.dart';

class ReadEmailUsecase implements UseCase<void, String> {
  final EmailRepository repository;

  ReadEmailUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) async {
    return await repository.readEmail(params);
  }
}
