import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

abstract class PayrollRepository {
  Future<Either<Failure, List<PayrollSlip>>> getPayrollSlips(
    GetPayrollSlipsParams params,
  );

  Future<Either<Failure, PayrollSlip>> getPayrollSlipById(String id);

  Future<Either<Failure, PayrollSlipPdf>> downloadPayrollSlipPdf(String id);
}
