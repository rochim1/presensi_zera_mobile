import 'package:presensi_domain/presensi_domain.dart';

class ShiftSwapRequest {
  final String id;
  final ShiftSchedule requesterSchedule;
  final ShiftSchedule targetSchedule;
  final User requesterUser;
  final RequestStatus status;
  final User targetUser;
  final String alasan;
  final ApprovalHistory? approvalHistory;
  final String? rejectReason;
  final String? rejectedReason;
  final String? cancelledReason;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ShiftSwapRequest({
    required this.id,
    required this.requesterUser,
    required this.targetUser,
    required this.requesterSchedule,
    required this.targetSchedule,
    required this.alasan,
    required this.status,
    this.approvalHistory,
    this.createdAt,
    this.updatedAt,
    this.rejectReason,
    this.rejectedReason,
    this.cancelledReason,
  });
}
