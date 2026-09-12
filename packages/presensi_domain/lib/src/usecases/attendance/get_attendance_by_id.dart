import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class GetAttendanceById extends UseCase<Attendance, String> {
  final AttendanceRepository repository;

  GetAttendanceById({required this.repository});

  @override
  Future<Either<Failure, Attendance>> call(String id) async {
    return repository.getAttendanceById(id);
  }
}
