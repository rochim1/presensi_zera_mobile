import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_data/presensi_data.dart';

part 'get_shift_schedules_request.freezed.dart';

part 'get_shift_schedules_request.g.dart';

@freezed
abstract class GetShiftSchedulesRequest with _$GetShiftSchedulesRequest {
  const factory GetShiftSchedulesRequest({
    @JsonKey(name: 'userId', includeIfNull: false) required String? userId,

    @DateConverter()
    @JsonKey(name: 'startDate', includeIfNull: false)
    required DateTime? startDate,

    @DateConverter()
    @JsonKey(name: 'endDate', includeIfNull: false)
    required DateTime? endDate,
  }) = _GetShiftSchedulesRequest;

  factory GetShiftSchedulesRequest.fromJson(Map<String, dynamic> json) =>
      _$GetShiftSchedulesRequestFromJson(json);
}
