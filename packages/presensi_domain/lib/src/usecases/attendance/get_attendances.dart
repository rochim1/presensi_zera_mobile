import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class GetAttendances extends UseCase<List<Attendance>, GetAttendancesParams> {
  final AttendanceRepository repository;

  GetAttendances({required this.repository});

  @override
  Future<Either<Failure, List<Attendance>>> call(
    GetAttendancesParams params,
  ) async {
    return repository.getAttendances(params);
  }
}
