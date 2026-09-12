import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class GetOvertimeRequestById extends UseCase<OvertimeRequest, String> {
  final OvertimeRepository repository;

  GetOvertimeRequestById({required this.repository});

  @override
  Future<Either<Failure, OvertimeRequest>> call(String params) {
    return repository.getOvertimeRequestById(params);
  }
}
