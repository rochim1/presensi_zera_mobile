import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class CreateLeaveRequest extends UseCase<void, CreateLeaveRequestParams> {
  final LeaveRepository repository;

  CreateLeaveRequest({required this.repository});

  @override
  Future<Either<Failure, void>> call(params) {
    return repository.createLeaveRequest(params);
  }
}
