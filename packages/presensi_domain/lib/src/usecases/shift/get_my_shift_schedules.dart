import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class GetMyShiftSchedules
    extends UseCase<List<ShiftSchedule>, GetMyShiftSchedulesParams> {
  final ShiftRepository repository;

  GetMyShiftSchedules({required this.repository});

  @override
  Future<Either<Failure, List<ShiftSchedule>>> call(params) {
    return repository.getMyShiftSchedules(params);
  }
}
