import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class GetLeaveRequestById extends UseCase<LeaveRequest, String> {
  final LeaveRepository repository;

  GetLeaveRequestById({required this.repository});

  @override
  Future<Either<Failure, LeaveRequest>> call(String id) {
    return repository.getLeaveRequestById(id);
  }
}
