import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'shift_swap_request_response.freezed.dart';

part 'shift_swap_request_response.g.dart';

@freezed
abstract class ShiftSwapRequestResponse with _$ShiftSwapRequestResponse {
  const factory ShiftSwapRequestResponse({
    @JsonKey(name: '_id') required String id,

    @JsonKey(name: 'alasan', defaultValue: '') required String alasan,

    @JsonKey(
      name: 'status',
      defaultValue: RequestStatus.pending,
      unknownEnumValue: RequestStatus.pending,
    )
    required RequestStatus status,

    @JsonKey(name: 'requester_id') required UserResponse requesterUser,

    @JsonKey(name: 'target_user_id') required UserResponse targetUser,

    @JsonKey(name: 'requester_schedule_id')
    required ShiftScheduleResponse requesterSchedule,

    @JsonKey(name: 'target_schedule_id')
    required ShiftScheduleResponse targetSchedule,

    @JsonKey(name: 'approval_history')
    required ApprovalHistoryResponse? approvalHistory,

    @JsonKey(name: 'rejected_reason') String? rejectedReason,
    @JsonKey(name: 'reject_reason') String? rejectReason,
    @JsonKey(name: 'cancelled_reason') String? cancelledReason,

    @JsonKey(name: 'cancelled_at')
    @NullableStringTimestampConverter()
    DateTime? cancelledAt,

    @JsonKey(name: 'createdAt')
    @NullableStringTimestampConverter()
    DateTime? createdAt,

    @JsonKey(name: 'updatedAt')
    @NullableStringTimestampConverter()
    DateTime? updatedAt,
  }) = _ShiftSwapRequestResponse;

  factory ShiftSwapRequestResponse.fromJson(Map<String, dynamic> json) =>
      _$ShiftSwapRequestResponseFromJson(json);
}
