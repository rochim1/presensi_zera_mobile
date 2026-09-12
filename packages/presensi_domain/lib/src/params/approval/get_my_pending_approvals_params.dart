import 'package:presensi_domain/presensi_domain.dart';

class GetMyPendingApprovalsParams extends PaginationParams {
  final ApprovalRequestType? requestType;
  final DateTime? startDate;
  final DateTime? endDate;

  const GetMyPendingApprovalsParams({
    super.page,
    super.limit,
    this.requestType,
    this.startDate,
    this.endDate,
  });
}
