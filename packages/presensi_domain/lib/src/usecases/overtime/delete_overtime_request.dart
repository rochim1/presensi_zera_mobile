import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class DeleteOvertimeRequest extends UseCase<void, String> {
  final OvertimeRepository repository;

  DeleteOvertimeRequest({required this.repository});

  @override
  Future<Either<Failure, void>> call(String params) {
    return repository.deleteOvertimeRequest(params);
  }
}
