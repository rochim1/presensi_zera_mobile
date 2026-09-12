import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'approval_history_response.g.dart';

part 'approval_history_response.freezed.dart';

@freezed
abstract class ApprovalHistoryResponse with _$ApprovalHistoryResponse {
  const factory ApprovalHistoryResponse({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'request_id') String? requestId,
    @JsonKey(
      name: 'request_type',
      unknownEnumValue: ApprovalRequestType.request_presensi,
    )
    ApprovalRequestType? requestType,
    @JsonKey(
      name: 'approval_type',
      defaultValue: ApprovalType.single,
      unknownEnumValue: ApprovalType.single,
    )
    required ApprovalType approvalType,
    @JsonKey(
      name: 'status',
      defaultValue: ApprovalHistoryStatus.in_progress,
      unknownEnumValue: ApprovalHistoryStatus.in_progress,
    )
    required ApprovalHistoryStatus status,
    @JsonKey(name: 'current_level', defaultValue: 0) required int currentLevel,
    @JsonKey(name: 'total_levels', defaultValue: 0) required int totalLevel,
    @JsonKey(name: 'requester_id') UserResponse? requester,
    @JsonKey(name: 'request_presensi')
    AttendanceRequestResponse? attendanceRequest,
    @JsonKey(name: 'payroll_batch') PayrollApprovalBatchResponse? payrollBatch,
    @JsonKey(name: 'approvers', defaultValue: [])
    required List<ApproverResponse> approvers,
    @JsonKey(name: 'createdAt')
    @NullableStringTimestampConverter()
    DateTime? createdAt,
  }) = _ApprovalHistoryResponse;

  factory ApprovalHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$ApprovalHistoryResponseFromJson(json);
}

class PayrollApprovalBatchResponse {
  final String id;
  final String period;
  final int totalSlips;
  final double totalAmount;
  final String status;

  const PayrollApprovalBatchResponse({required this.id, required this.period, required this.totalSlips, required this.totalAmount, required this.status});

  factory PayrollApprovalBatchResponse.fromJson(Map<String, dynamic> json) => PayrollApprovalBatchResponse(
    id: json['_id']?.toString() ?? '',
    period: json['periode']?.toString() ?? '',
    totalSlips: (json['total_slips'] as num?)?.toInt() ?? 0,
    totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0,
    status: json['status']?.toString() ?? '',
  );

  Map<String, dynamic> toJson() => {'_id': id, 'periode': period, 'total_slips': totalSlips, 'total_amount': totalAmount, 'status': status};
}
