import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class FinishOvertimeSession
    extends UseCase<OvertimeRequest, FinishOvertimeSessionParams> {
  final OvertimeRepository repository;

  FinishOvertimeSession({required this.repository});

  @override
  Future<Either<Failure, OvertimeRequest>> call(
    FinishOvertimeSessionParams params,
  ) {
    return repository.finishOvertimeSession(params);
  }
}
