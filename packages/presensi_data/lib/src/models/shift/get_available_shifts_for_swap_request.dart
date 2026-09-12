import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_data/presensi_data.dart';

part 'get_available_shifts_for_swap_request.freezed.dart';

part 'get_available_shifts_for_swap_request.g.dart';

@freezed
abstract class GetAvailableShiftsForSwapRequest
    with _$GetAvailableShiftsForSwapRequest {
  const factory GetAvailableShiftsForSwapRequest({
    @JsonKey(name: 'shiftDate', includeIfNull: false)
    @DateConverter()
    DateTime? shiftDate,
  }) = _GetAvailableShiftsForSwapRequest;

  factory GetAvailableShiftsForSwapRequest.fromJson(
    Map<String, dynamic> json,
  ) => _$GetAvailableShiftsForSwapRequestFromJson(json);
}
