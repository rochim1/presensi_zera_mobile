import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

abstract class OvertimeRepository {
  Future<Either<Failure, List<OvertimeRequest>>> getOvertimeRequests(
    GetOvertimeRequestsParams params,
  );

  Future<Either<Failure, OvertimeRequest>> getOvertimeRequestById(String id);

  Future<Either<Failure, OvertimeRequest?>> getActiveOvertimeSession();

  Future<Either<Failure, void>> createOvertimeRequest(
    CreateOvertimeRequestParams params,
  );

  Future<Either<Failure, void>> updateOvertimeRequest(
    String id,
    CreateOvertimeRequestParams params,
  );

  Future<Either<Failure, void>> deleteOvertimeRequest(String id);

  Future<Either<Failure, OvertimeRequest>> startOvertimeSession(
    StartOvertimeSessionParams params,
  );

  Future<Either<Failure, OvertimeRequest>> finishOvertimeSession(
    FinishOvertimeSessionParams params,
  );

  Future<Either<Failure, void>> cancelOvertimeSession(String overtimeId);
}
