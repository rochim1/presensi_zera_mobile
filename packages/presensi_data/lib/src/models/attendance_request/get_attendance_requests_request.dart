import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'get_attendance_requests_request.freezed.dart';

part 'get_attendance_requests_request.g.dart';

@freezed
abstract class GetAttendanceRequestsRequest
    with _$GetAttendanceRequestsRequest {
  const factory GetAttendanceRequestsRequest({
    @JsonKey(name: 'user_id', includeIfNull: false) String? userId,
    @JsonKey(name: 'start_date', includeIfNull: false)
    @DateConverter()
    DateTime? startDate,
    @JsonKey(name: 'end_date', includeIfNull: false)
    @DateConverter()
    DateTime? endDate,
    @JsonKey(name: 'status', includeIfNull: false)
    AttendanceRequestStatus? status,
  }) = _GetAttendanceRequestsRequest;

  factory GetAttendanceRequestsRequest.fromJson(Map<String, dynamic> json) =>
      _$GetAttendanceRequestsRequestFromJson(json);
}
