import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'get_my_pending_approvals_request.freezed.dart';

part 'get_my_pending_approvals_request.g.dart';

@freezed
abstract class GetMyPendingApprovalsRequest
    with _$GetMyPendingApprovalsRequest {
  const factory GetMyPendingApprovalsRequest({
    @JsonKey(name: 'request_type', includeIfNull: false)
    ApprovalRequestType? requestType,
    @JsonKey(name: 'start_date', includeIfNull: false)
    @DateConverter()
    DateTime? startDate,
    @JsonKey(name: 'end_date', includeIfNull: false)
    @DateConverter()
    DateTime? endDate,
  }) = _GetMyPendingApprovalsRequest;

  factory GetMyPendingApprovalsRequest.fromJson(Map<String, dynamic> json) =>
      _$GetMyPendingApprovalsRequestFromJson(json);
}
