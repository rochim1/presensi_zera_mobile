import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class GetAvailableShiftsForSwap
    extends
        UseCase<List<AvailableShiftForSwap>, GetAvailableShiftsForSwapParams> {
  final ShiftRepository repository;

  GetAvailableShiftsForSwap({required this.repository});

  @override
  Future<Either<Failure, List<AvailableShiftForSwap>>> call(params) {
    return repository.getAvailableShiftsForSwap(params);
  }
}
