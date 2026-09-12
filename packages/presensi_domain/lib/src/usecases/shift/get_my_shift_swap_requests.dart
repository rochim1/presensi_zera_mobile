import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class GetMyShiftSwapRequests
    extends UseCase<List<ShiftSwapRequest>, GetMyShiftSwapRequestsParams> {
  final ShiftRepository repository;

  GetMyShiftSwapRequests({required this.repository});

  @override
  Future<Either<Failure, List<ShiftSwapRequest>>> call(params) {
    return repository.getMyShiftSwapRequests(params);
  }
}
