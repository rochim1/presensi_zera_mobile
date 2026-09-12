import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class GetLeaveRequests
    extends UseCase<List<LeaveRequest>, GetLeaveRequestsParams> {
  final LeaveRepository repository;

  GetLeaveRequests({required this.repository});

  @override
  Future<Either<Failure, List<LeaveRequest>>> call(params) async {
    return await repository.getLeaveRequests(params);
  }
}
