import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

abstract class AttendanceRequestRepository {
  Future<Either<Failure, List<AttendanceRequest>>> getAttendanceRequests(
    GetAttendanceRequestsParams params,
  );

  Future<Either<Failure, void>> createAttendanceRequest(
    CreateAttendanceRequestParams params,
  );
  Future<Either<Failure, void>> updateAttendanceRequest(
    String id,
    CreateAttendanceRequestParams params,
  );
  Future<Either<Failure, void>> deleteAttendanceRequest(String id);
}
