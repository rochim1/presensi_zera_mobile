import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class GetReimbursementById extends UseCase<Reimbursement, String> {
  final ReimbursementRepository repository;

  GetReimbursementById({required this.repository});

  @override
  Future<Either<Failure, Reimbursement>> call(String reimbursementId) {
    return repository.getReimbursementById(reimbursementId);
  }
}
