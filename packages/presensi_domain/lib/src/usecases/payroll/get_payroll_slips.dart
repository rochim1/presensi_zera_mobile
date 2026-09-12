import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class GetPayrollSlips
    extends UseCase<List<PayrollSlip>, GetPayrollSlipsParams> {
  final PayrollRepository repository;

  GetPayrollSlips({required this.repository});

  @override
  Future<Either<Failure, List<PayrollSlip>>> call(
    GetPayrollSlipsParams params,
  ) {
    return repository.getPayrollSlips(params);
  }
}
