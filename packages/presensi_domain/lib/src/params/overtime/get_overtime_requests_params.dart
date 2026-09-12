import 'package:presensi_domain/presensi_domain.dart';

class GetOvertimeRequestsParams extends PaginationParams {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? userId;
  final OvertimeRequestStatus? status;

  GetOvertimeRequestsParams({
    super.page,
    super.limit,
    this.userId,
    this.startDate,
    this.endDate,
    this.status,
  });
}
