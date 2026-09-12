import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class CreateShiftSwapRequestApproval
    extends UseCase<void, CreateShiftSwapRequestApprovalParams> {
  final ShiftRepository repository;

  CreateShiftSwapRequestApproval({required this.repository});

  @override
  Future<Either<Failure, void>> call(params) {
    return repository.createShiftSwapRequestApproval(params);
  }
}
