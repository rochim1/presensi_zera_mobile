import 'package:presensi_domain/presensi_domain.dart';

class GetMyShiftSwapRequestsParams extends PaginationParams {
  final DateTime? startDate;
  final DateTime? endDate;
  final RequestStatus? status;

  GetMyShiftSwapRequestsParams({
    super.page,
    super.limit,
    this.startDate,
    this.endDate,
    this.status,
  });
}
