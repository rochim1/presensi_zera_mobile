import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class GetMyAttendances extends UseCase<List<Attendance>, GetAttendancesParams> {
  final AttendanceRepository repository;
  final UserRepository userRepository;

  GetMyAttendances({required this.repository, required this.userRepository});

  @override
  Future<Either<Failure, List<Attendance>>> call(
    GetAttendancesParams params,
  ) async {
    final userId = await userRepository.getCurrentUserId();
    return repository.getAttendances(params.copyWith(userId: userId));
  }
}
