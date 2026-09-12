import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class GetPayrollSlipById extends UseCase<PayrollSlip, String> {
  final PayrollRepository repository;

  GetPayrollSlipById({required this.repository});

  @override
  Future<Either<Failure, PayrollSlip>> call(String params) {
    return repository.getPayrollSlipById(params);
  }
}
