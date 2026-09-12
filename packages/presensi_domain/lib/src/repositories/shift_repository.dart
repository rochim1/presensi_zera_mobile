import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

abstract class ShiftRepository {
  Future<Either<Failure, void>> createShiftSwapRequest(
    CreateShiftSwapRequestParams params,
  );
  Future<Either<Failure, void>> cancelShiftSwapRequest(String id);
  Future<Either<Failure, void>> updateShiftSwapRequest(
    String id,
    CreateShiftSwapRequestParams params,
  );

  Future<Either<Failure, void>> createShiftSwapRequestApproval(
    CreateShiftSwapRequestApprovalParams params,
  );

  Future<Either<Failure, List<AvailableShiftForSwap>>>
  getAvailableShiftsForSwap(GetAvailableShiftsForSwapParams params);

  Future<Either<Failure, ShiftSchedule>> getShiftScheduleById(String id);

  Future<Either<Failure, List<ShiftSchedule>>> getShiftSchedules(
    GetShiftSchedulesParams params,
  );

  Future<Either<Failure, List<ShiftSwapRequest>>> getShiftSwapRequests(
    GetShiftSwapRequestsParams params,
  );

  Future<Either<Failure, List<ShiftSchedule>>> getMyShiftSchedules(
    GetMyShiftSchedulesParams params,
  );

  Future<Either<Failure, List<ShiftSwapRequest>>> getMyShiftSwapRequests(
    GetMyShiftSwapRequestsParams params,
  );
}
