import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_data/presensi_data.dart';

part 'create_overtime_request_request.freezed.dart';

part 'create_overtime_request_request.g.dart';

@freezed
abstract class CreateOvertimeRequestRequest
    with _$CreateOvertimeRequestRequest {
  const factory CreateOvertimeRequestRequest({
    @JsonKey(name: 'tanggal', includeIfNull: false)
    @DateConverter()
    DateTime? date,
    @JsonKey(name: 'jam_mulai', includeIfNull: false)
    @TimeConverter()
    DateTime? startTime,
    @JsonKey(name: 'jam_selesai', includeIfNull: false)
    @TimeConverter()
    DateTime? endTime,
    @JsonKey(name: 'alasan', includeIfNull: false) required String reason,
  }) = _CreateOvertimeRequestRequest;

  factory CreateOvertimeRequestRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateOvertimeRequestRequestFromJson(json);
}
