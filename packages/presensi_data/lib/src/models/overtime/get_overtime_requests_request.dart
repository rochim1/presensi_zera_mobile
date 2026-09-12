import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'get_overtime_requests_request.freezed.dart';

part 'get_overtime_requests_request.g.dart';

@freezed
abstract class GetOvertimeRequestsRequest with _$GetOvertimeRequestsRequest {
  const factory GetOvertimeRequestsRequest({
    @JsonKey(name: 'user_id', includeIfNull: false) String? userId,
    @JsonKey(name: 'tanggal_start', includeIfNull: false)
    @DateConverter()
    DateTime? startDate,
    @JsonKey(name: 'tanggal_end', includeIfNull: false)
    @DateConverter()
    DateTime? endDate,
    @JsonKey(name: 'status', includeIfNull: false)
    OvertimeRequestStatus? status,
  }) = _GetOvertimeRequestsRequest;

  factory GetOvertimeRequestsRequest.fromJson(Map<String, dynamic> json) =>
      _$GetOvertimeRequestsRequestFromJson(json);
}
