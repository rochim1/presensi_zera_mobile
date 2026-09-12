import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class CreateApproval extends UseCase<void, CreateApprovalParams> {
  final ApprovalRepository repository;

  CreateApproval({required this.repository});

  @override
  Future<Either<Failure, void>> call(params) {
    return repository.createApproval(params);
  }
}
