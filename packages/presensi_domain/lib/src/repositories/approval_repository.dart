import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

abstract class ApprovalRepository {
  Future<Either<Failure, void>> createApproval(CreateApprovalParams params);

  Future<Either<Failure, List<ApprovalHistory>>> getMyPendingApprovals(
    GetMyPendingApprovalsParams params,
  );

  Future<Either<Failure, TestWorkflowUserResult>> testWorkflowUser(
    TestWorkflowUserParams params,
  );
}

class TestWorkflowUserParams {
  final String? module;
  final String testUserId;

  TestWorkflowUserParams({
    this.module,
    required this.testUserId,
  });
}
