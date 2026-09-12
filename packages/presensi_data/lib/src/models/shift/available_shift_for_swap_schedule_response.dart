import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_data/core/utils/datetime_converter.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'shift_response.dart';

part 'available_shift_for_swap_schedule_response.freezed.dart';

part 'available_shift_for_swap_schedule_response.g.dart';

@freezed
abstract class AvailableShiftForSwapScheduleResponse
    with _$AvailableShiftForSwapScheduleResponse {
  const factory AvailableShiftForSwapScheduleResponse({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'assigned_date') @DateConverter() DateTime? assignedDate,
    @JsonKey(
      name: 'status',
      defaultValue: ShiftScheduleStatus.assigned,
      unknownEnumValue: ShiftScheduleStatus.assigned,
    )
    required ShiftScheduleStatus status,
    @JsonKey(name: 'shift_id') required ShiftResponse shift,
  }) = _AvailableShiftForSwapScheduleResponse;

  factory AvailableShiftForSwapScheduleResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$AvailableShiftForSwapScheduleResponseFromJson(json);
}
