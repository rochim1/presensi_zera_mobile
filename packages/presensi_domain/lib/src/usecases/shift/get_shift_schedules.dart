import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class GetShiftSchedules
    extends UseCase<List<ShiftSchedule>, GetShiftSchedulesParams> {
  final ShiftRepository repository;

  GetShiftSchedules({required this.repository});

  @override
  Future<Either<Failure, List<ShiftSchedule>>> call(params) {
    return repository.getShiftSchedules(params);
  }
}
