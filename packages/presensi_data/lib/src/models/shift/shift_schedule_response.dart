import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'shift_schedule_response.freezed.dart';

part 'shift_schedule_response.g.dart';

@freezed
abstract class ShiftScheduleResponse with _$ShiftScheduleResponse {
  const factory ShiftScheduleResponse({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'shift') required ShiftResponse shift,
    @JsonKey(name: 'assigned_date') @DateConverter() DateTime? assignedDate,
    @JsonKey(name: 'user') UserResponse? user,

    @JsonKey(
      name: 'status',
      defaultValue: ShiftScheduleStatus.assigned,
      unknownEnumValue: ShiftScheduleStatus.assigned,
    )
    required ShiftScheduleStatus status,

    @JsonKey(name: 'notes') String? notes,
    @JsonKey(name: 'createdAt')
    @NullableStringTimestampConverter()
    DateTime? createdAt,
    @JsonKey(name: 'updatedAt')
    @NullableStringTimestampConverter()
    DateTime? updatedAt,
  }) = _ShiftScheduleResponse;

  factory ShiftScheduleResponse.fromJson(Map<String, dynamic> json) =>
      _$ShiftScheduleResponseFromJson(json);
}
