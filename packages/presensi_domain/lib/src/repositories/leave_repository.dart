import 'package:dartz/dartz.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

abstract class LeaveRepository {
  Future<Either<Failure, List<LeaveRequest>>> getLeaveRequests(
    GetLeaveRequestsParams params,
  );

  Future<Either<Failure, LeaveRequest>> getLeaveRequestById(String id);

  Future<Either<Failure, List<LeaveCategory>>> getLeaveCategories();

  Future<Either<Failure, void>> createLeaveRequest(
    CreateLeaveRequestParams params,
  );
  Future<Either<Failure, void>> updateLeaveRequest(
    String id,
    CreateLeaveRequestParams params,
  );
  Future<Either<Failure, void>> deleteLeaveRequest(String id);

  Future<Either<Failure, Map<String, dynamic>>> getMyCutiQuota();
}
