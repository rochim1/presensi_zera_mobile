import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_active_attendance_request.freezed.dart';

part 'get_active_attendance_request.g.dart';

@freezed
abstract class GetActiveAttendanceRequest with _$GetActiveAttendanceRequest {
  const factory GetActiveAttendanceRequest({
    @JsonKey(name: 'userId') required String userId,
  }) = _GetActiveAttendanceRequest;

  factory GetActiveAttendanceRequest.fromJson(Map<String, dynamic> json) =>
      _$GetActiveAttendanceRequestFromJson(json);
}
