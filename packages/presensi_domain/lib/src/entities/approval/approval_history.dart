import 'package:presensi_domain/presensi_domain.dart';

class ApprovalHistory {
  final String id;
  final String? requestId;
  final ApprovalRequestType? requestType;
  final ApprovalType approvalType;
  final ApprovalHistoryStatus status;
  final int currentLevel;
  final int totalLevel;
  final User? requester;
  final AttendanceRequest? attendanceRequest;
  final PayrollApprovalBatch? payrollBatch;
  final List<Approver> approvers;
  final DateTime? createdAt;

  const ApprovalHistory({
    required this.id,
    this.requestId,
    this.requestType,
    required this.approvalType,
    required this.currentLevel,
    required this.totalLevel,
    required this.status,
    this.requester,
    this.attendanceRequest,
    this.payrollBatch,
    this.approvers = const [],
    this.createdAt,
  });
}

class PayrollApprovalBatch {
  final String id;
  final String period;
  final int totalSlips;
  final double totalAmount;
  final String status;

  const PayrollApprovalBatch({
    required this.id,
    required this.period,
    required this.totalSlips,
    required this.totalAmount,
    required this.status,
  });
}
