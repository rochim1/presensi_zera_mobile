import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class GetOvertimeRequests
    extends UseCase<List<OvertimeRequest>, GetOvertimeRequestsParams> {
  final OvertimeRepository repository;

  GetOvertimeRequests({required this.repository});

  @override
  Future<Either<Failure, List<OvertimeRequest>>> call(params) {
    return repository.getOvertimeRequests(params);
  }
}
