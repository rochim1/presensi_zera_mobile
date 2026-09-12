import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class GetLeaveCategories extends UseCase<List<LeaveCategory>, NoParams> {
  final LeaveRepository repository;

  GetLeaveCategories({required this.repository});

  @override
  Future<Either<Failure, List<LeaveCategory>>> call(params) {
    return repository.getLeaveCategories();
  }
}
