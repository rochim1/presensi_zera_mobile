import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class TestWorkflowUserUseCase
    implements UseCase<TestWorkflowUserResult, TestWorkflowUserParams> {
  final ApprovalRepository repository;

  TestWorkflowUserUseCase(this.repository);

  @override
  Future<Either<Failure, TestWorkflowUserResult>> call(
    TestWorkflowUserParams params,
  ) async {
    return await repository.testWorkflowUser(params);
  }
}
