import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class GetEffectiveScheduleToday extends UseCase<EffectiveSchedule, NoParams> {
  final AttendanceRepository repository;

  GetEffectiveScheduleToday({required this.repository});

  @override
  Future<Either<Failure, EffectiveSchedule>> call(NoParams params) async {
    return repository.getEffectiveScheduleToday();
  }
}
