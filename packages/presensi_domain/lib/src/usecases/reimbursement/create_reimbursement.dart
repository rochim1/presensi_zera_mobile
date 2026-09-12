import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class CreateReimbursement
    extends UseCase<Reimbursement, CreateReimbursementParams> {
  final ReimbursementRepository repository;

  CreateReimbursement({required this.repository});

  @override
  Future<Either<Failure, Reimbursement>> call(params) {
    return repository.createReimbursement(params);
  }
}
