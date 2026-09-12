import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

abstract class ReimbursementRepository {
  Future<Either<Failure, List<Reimbursement>>> getReimbursements(
    GetReimbursementsParams params,
  );

  Future<Either<Failure, Reimbursement>> getReimbursementById(
    String reimbursementId,
  );

  Future<Either<Failure, List<ReimbursementCategory>>>
  getReimbursementCategories();

  Future<Either<Failure, Reimbursement>> createReimbursement(
    CreateReimbursementParams params,
  );
  Future<Either<Failure, Reimbursement>> updateReimbursement(
    String id,
    CreateReimbursementParams params,
  );
  Future<Either<Failure, void>> deleteReimbursement(String id);
}
