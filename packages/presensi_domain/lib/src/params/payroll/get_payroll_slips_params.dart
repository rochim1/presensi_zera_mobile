import 'package:presensi_domain/presensi_domain.dart';

class GetPayrollSlipsParams extends PaginationParams {
  final int? month;
  final int? year;
  final PayrollSlipStatus? status;

  const GetPayrollSlipsParams({
    this.month,
    this.year,
    this.status,
    super.page,
    super.limit,
  });
}
