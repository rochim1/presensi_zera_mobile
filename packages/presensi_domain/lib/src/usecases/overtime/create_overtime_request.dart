import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class CreateOvertimeRequest extends UseCase<void, CreateOvertimeRequestParams> {
  final OvertimeRepository repository;

  CreateOvertimeRequest({required this.repository});

  @override
  Future<Either<Failure, void>> call(params) {
    return repository.createOvertimeRequest(params);
  }
}
