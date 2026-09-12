import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class CancelOvertimeSession extends UseCase<void, String> {
  final OvertimeRepository repository;

  CancelOvertimeSession({required this.repository});

  @override
  Future<Either<Failure, void>> call(String params) {
    return repository.cancelOvertimeSession(params);
  }
}
