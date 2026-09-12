import 'package:presensi_domain/presensi_domain.dart';

class CreateApprovalParams {
  final String requestId;
  final ApprovalRequestType requestType;
  final AttendanceRequestApprovalAction action;
  final String? reason;

  const CreateApprovalParams({
    required this.requestId,
    this.requestType = ApprovalRequestType.request_presensi,
    required this.action,
    this.reason,
  });
}
