import 'package:presensi_domain/presensi_domain.dart';

class GetShiftSwapRequestsParams extends PaginationParams {
  final DateTime? startDate;
  final DateTime? endDate;
  final RequestStatus? status;

  GetShiftSwapRequestsParams({
    super.page,
    super.limit,
    this.startDate,
    this.endDate,
    this.status,
  });
}
