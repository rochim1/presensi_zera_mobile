import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class UpdateOvertimeRequest {
  final OvertimeRepository repository;

  UpdateOvertimeRequest({required this.repository});

  Future<Either<Failure, void>> call(
    String id,
    CreateOvertimeRequestParams params,
  ) {
    return repository.updateOvertimeRequest(id, params);
  }
}
