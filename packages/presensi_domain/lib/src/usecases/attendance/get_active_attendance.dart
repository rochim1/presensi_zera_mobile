import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class GetActiveAttendance extends UseCase<Attendance, NoParams> {
  final AttendanceRepository repository;

  GetActiveAttendance({required this.repository});

  @override
  Future<Either<Failure, Attendance>> call(params) async {
    final data = await repository.getActiveAttendance();

    return data.fold((failure) => Left(failure), (value) => Right(value));
  }
}
