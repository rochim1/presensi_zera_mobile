import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/src/entities/_entities.dart';
import 'package:presensi_domain/src/params/_params.dart';
import 'package:presensi_domain/src/repositories/_repositories.dart';

class CreateEmployeeLoan extends UseCase<EmployeeLoan, CreateEmployeeLoanParams> {
  final LoanRepository repository;

  CreateEmployeeLoan(this.repository);

  @override
  Future<Either<Failure, EmployeeLoan>> call(CreateEmployeeLoanParams params) {
    return repository.createEmployeeLoan(params);
  }
}
