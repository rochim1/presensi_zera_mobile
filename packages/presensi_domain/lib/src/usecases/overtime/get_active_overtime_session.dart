import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class GetActiveOvertimeSession extends UseCase<OvertimeRequest?, NoParams> {
  final OvertimeRepository repository;

  GetActiveOvertimeSession({required this.repository});

  @override
  Future<Either<Failure, OvertimeRequest?>> call(NoParams params) {
    return repository.getActiveOvertimeSession();
  }
}
