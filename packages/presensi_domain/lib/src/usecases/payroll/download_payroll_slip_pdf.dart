import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class DownloadPayrollSlipPdf extends UseCase<PayrollSlipPdf, String> {
  final PayrollRepository repository;

  DownloadPayrollSlipPdf({required this.repository});

  @override
  Future<Either<Failure, PayrollSlipPdf>> call(String params) {
    return repository.downloadPayrollSlipPdf(params);
  }
}
