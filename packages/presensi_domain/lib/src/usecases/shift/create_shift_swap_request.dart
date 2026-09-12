import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class CreateShiftSwapRequest
    extends UseCase<void, CreateShiftSwapRequestParams> {
  final ShiftRepository repository;

  CreateShiftSwapRequest({required this.repository});

  @override
  Future<Either<Failure, void>> call(CreateShiftSwapRequestParams params) {
    return repository.createShiftSwapRequest(params);
  }
}
