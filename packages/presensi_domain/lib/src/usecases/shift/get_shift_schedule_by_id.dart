import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class GetShiftScheduleById extends UseCase<ShiftSchedule, String> {
  final ShiftRepository repository;

  GetShiftScheduleById({required this.repository});

  @override
  Future<Either<Failure, ShiftSchedule>> call(String id) {
    return repository.getShiftScheduleById(id);
  }
}
