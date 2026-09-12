import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class GetAttendanceStatistics
    extends UseCase<List<AttendanceStatistic>, GetAttendancesParams> {
  final AttendanceRepository repository;

  GetAttendanceStatistics({required this.repository});

  @override
  Future<Either<Failure, List<AttendanceStatistic>>> call(
    GetAttendancesParams params,
  ) async {
    return repository.getAttendanceStatistics(params);
  }
}
