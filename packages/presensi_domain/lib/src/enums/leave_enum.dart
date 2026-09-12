import 'package:presensi_domain/src/enums/attendance_request_enum.dart';

enum LeaveApprovalAction {
  approve,
  reject,
  none;

  bool get isApprove => this == LeaveApprovalAction.approve;

  bool get isReject => this == LeaveApprovalAction.reject;

  bool get isNone => this == LeaveApprovalAction.none;

  AttendanceRequestApprovalAction toAttendanceRequestApprovalAction() {
    switch (this) {
      case LeaveApprovalAction.approve:
        return AttendanceRequestApprovalAction.approve;
      case LeaveApprovalAction.reject:
        return AttendanceRequestApprovalAction.reject;
      case LeaveApprovalAction.none:
        return AttendanceRequestApprovalAction.none;
    }
  }
}
