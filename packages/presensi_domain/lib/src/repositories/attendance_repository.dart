import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

abstract class AttendanceRepository {
  Future<Either<Failure, Attendance>> getActiveAttendance();

  Future<Either<Failure, List<Attendance>>> getAttendances(
    GetAttendancesParams params,
  );

  Future<Either<Failure, Attendance>> getAttendanceById(String id);

  Future<Either<Failure, List<AttendanceStatistic>>> getAttendanceStatistics(
    GetAttendancesParams params,
  );

  Future<Either<Failure, HomeAlert>> getHomeAlert();

  Future<Either<Failure, EffectiveSchedule>> getEffectiveScheduleToday();
}
