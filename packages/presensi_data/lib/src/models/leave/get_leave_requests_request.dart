import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_data/presensi_data.dart';

part 'get_leave_requests_request.freezed.dart';

part 'get_leave_requests_request.g.dart';

@freezed
abstract class GetLeaveRequestsRequest with _$GetLeaveRequestsRequest {
  const factory GetLeaveRequestsRequest({
    @JsonKey(name: 'user_id') String? userId,
    // Backend FilterAllCuti.kalender is a month key (YYYY-MM), not a date.
    @JsonKey(name: 'kalender') @MonthConverter() DateTime? startDate,
    @JsonKey(name: 'status_izin') String? statusIzin,
    @JsonKey(name: 'detail_cuti') bool? detailCuti,
  }) = _GetLeaveRequestsRequest;

  factory GetLeaveRequestsRequest.fromJson(Map<String, dynamic> json) =>
      _$GetLeaveRequestsRequestFromJson(json);
}
