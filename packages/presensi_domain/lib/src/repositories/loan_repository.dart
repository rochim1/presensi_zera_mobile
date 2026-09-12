import 'package:dartz/dartz.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

abstract class LoanRepository {
  Future<Either<Failure, List<EmployeeLoan>>> getEmployeeLoans(
    GetEmployeeLoansParams params,
  );

  Future<Either<Failure, EmployeeLoan>> createEmployeeLoan(
    CreateEmployeeLoanParams params,
  );
}
