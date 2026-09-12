import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'create_attendance_request_request.freezed.dart';

part 'create_attendance_request_request.g.dart';

@freezed
abstract class CreateAttendanceRequestRequest
    with _$CreateAttendanceRequestRequest {
  const factory CreateAttendanceRequestRequest({
    @JsonKey(
      name: 'jenis_presensi',
      includeIfNull: false,
      toJson: CreateAttendanceRequestRequest._attendanceTypeToJson,
    )
    AttendanceType? attendanceType,
    @JsonKey(name: 'jenis_request', includeIfNull: false)
    AttendanceRequestType? attendanceRequestType,
    @JsonKey(name: 'shift_id', includeIfNull: false) String? shiftId,
    @JsonKey(name: 'tanggal_presensi', includeIfNull: false)
    @DateConverter()
    DateTime? attendanceDate,
    @JsonKey(name: 'waktu_yang_diminta', includeIfNull: false)
    String? attendanceTime,
    @JsonKey(name: 'alasan', includeIfNull: false) String? reason,
  }) = _CreateAttendanceRequestRequest;

  factory CreateAttendanceRequestRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateAttendanceRequestRequestFromJson(json);

  static String? _attendanceTypeToJson(AttendanceType? val) =>
      val == AttendanceType.daily ? 'reguler' : val?.name;
}
