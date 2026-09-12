import 'package:presensi_domain/presensi_domain.dart';

class OvertimeRequest {
  final String id;
  final DateTime? date;
  final DateTime? startTime;
  final DateTime? endTime;
  final int durationInHours;
  final String? reason;
  final DateTime? createdAt;
  final OvertimeRequestStatus status;
  final User user;
  final ApprovalHistory? approvalHistory;

  const OvertimeRequest({
    required this.id,
    this.date,
    this.startTime,
    this.endTime,
    required this.durationInHours,
    this.reason,
    this.createdAt,
    required this.status,
    required this.user,
    this.approvalHistory,
  });
}
