import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_data/presensi_data.dart';

part 'available_shift_for_swap_response.freezed.dart';

part 'available_shift_for_swap_response.g.dart';

@freezed
abstract class AvailableShiftForSwapResponse
    with _$AvailableShiftForSwapResponse {
  const factory AvailableShiftForSwapResponse({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'current_shift')
    required AvailableShiftForSwapScheduleResponse currentShift,
    @JsonKey(name: 'user_id') required UserResponse user,
  }) = _AvailableShiftForSwapResponse;

  factory AvailableShiftForSwapResponse.fromJson(Map<String, dynamic> json) =>
      _$AvailableShiftForSwapResponseFromJson(json);
}
