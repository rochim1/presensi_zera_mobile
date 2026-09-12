import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class GetReimbursements
    extends UseCase<List<Reimbursement>, GetReimbursementsParams> {
  final ReimbursementRepository repository;

  GetReimbursements({required this.repository});

  @override
  Future<Either<Failure, List<Reimbursement>>> call(params) {
    return repository.getReimbursements(params);
  }
}
