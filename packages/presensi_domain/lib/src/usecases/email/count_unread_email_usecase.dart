import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/src/repositories/email_repository.dart';

class CountUnreadEmailUsecase implements UseCase<int, NoParams> {
  final EmailRepository repository;

  CountUnreadEmailUsecase({required this.repository});

  @override
  Future<Either<Failure, int>> call(NoParams params) async {
    return await repository.countUnreadEmail();
  }
}
