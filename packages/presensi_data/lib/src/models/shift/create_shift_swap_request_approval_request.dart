import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'create_shift_swap_request_approval_request.freezed.dart';

part 'create_shift_swap_request_approval_request.g.dart';

@freezed
abstract class CreateShiftSwapRequestApprovalRequest
    with _$CreateShiftSwapRequestApprovalRequest {
  const factory CreateShiftSwapRequestApprovalRequest({
    @JsonKey(name: 'swap_request_id', includeIfNull: false)
    required String swapRequestId,
    @JsonKey(name: 'status', includeIfNull: true) RequestStatus? status,
    @JsonKey(name: 'rejected_reason', includeIfNull: true)
    String? rejectedReason,
  }) = _CreateShiftSwapRequestApprovalRequest;

  factory CreateShiftSwapRequestApprovalRequest.fromJson(
    Map<String, dynamic> json,
  ) => _$CreateShiftSwapRequestApprovalRequestFromJson(json);
}
