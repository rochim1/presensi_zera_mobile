import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'create_approval_request.freezed.dart';

part 'create_approval_request.g.dart';

@freezed
abstract class CreateApprovalRequest with _$CreateApprovalRequest {
  const factory CreateApprovalRequest({
    @JsonKey(name: 'request_id', includeIfNull: false)
    required String requestId,
    @JsonKey(name: 'request_type', includeIfNull: false)
    required ApprovalRequestType requestType,
    @JsonKey(name: 'action', includeIfNull: false)
    required AttendanceRequestApprovalAction action,
    @JsonKey(name: 'catatan', includeIfNull: false) String? reason,
  }) = _CreateApprovalRequest;

  factory CreateApprovalRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateApprovalRequestFromJson(json);
}
