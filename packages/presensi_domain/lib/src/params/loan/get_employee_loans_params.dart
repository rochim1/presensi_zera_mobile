import 'package:presensi_domain/presensi_domain.dart';

class GetEmployeeLoansParams extends PaginationParams {
  final String? employeeId;
  final String? approvalStatus;
  final String? loanType;
  final String? search;
  final DateTime? dateFrom;
  final DateTime? dateTo;

  GetEmployeeLoansParams({
    super.page,
    super.limit,
    this.employeeId,
    this.approvalStatus,
    this.loanType,
    this.search,
    this.dateFrom,
    this.dateTo,
  });
}
