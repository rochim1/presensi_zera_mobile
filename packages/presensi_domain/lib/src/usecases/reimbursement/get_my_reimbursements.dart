import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class GetMyReimbursements
    extends UseCase<List<Reimbursement>, GetReimbursementsParams> {
  final ReimbursementRepository repository;
  final UserRepository userRepository;

  GetMyReimbursements({required this.repository, required this.userRepository});

  @override
  Future<Either<Failure, List<Reimbursement>>> call(params) async {
    final userId = await userRepository.getCurrentUserId();
    return repository.getReimbursements(params.copyWith(userId: userId));
  }
}
