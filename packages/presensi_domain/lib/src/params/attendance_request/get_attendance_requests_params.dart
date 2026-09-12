import 'package:presensi_domain/presensi_domain.dart';

class GetAttendanceRequestsParams extends PaginationParams {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? userId;
  final AttendanceRequestStatus? status;

  GetAttendanceRequestsParams({
    super.page,
    super.limit,
    this.userId,
    this.startDate,
    this.endDate,
    this.status,
  });
}
