import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class GetMyPendingApprovals
    extends UseCase<List<ApprovalHistory>, GetMyPendingApprovalsParams> {
  final ApprovalRepository repository;

  GetMyPendingApprovals({required this.repository});

  @override
  Future<Either<Failure, List<ApprovalHistory>>> call(params) async {
    final data = await repository.getMyPendingApprovals(params);

    return data.fold((failure) => Left(failure), (value) => Right(value));
  }
}
