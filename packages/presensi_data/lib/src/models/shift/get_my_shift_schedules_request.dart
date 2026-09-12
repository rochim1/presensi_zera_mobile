import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_data/presensi_data.dart';

part 'get_my_shift_schedules_request.freezed.dart';

part 'get_my_shift_schedules_request.g.dart';

@freezed
abstract class GetMyShiftSchedulesRequest with _$GetMyShiftSchedulesRequest {
  const factory GetMyShiftSchedulesRequest({
    @MonthConverter()
    @JsonKey(name: 'month', includeIfNull: false)
    required DateTime? date,
    @JsonKey(name: 'page', includeIfNull: false) required int? page,
    @JsonKey(name: 'limit', includeIfNull: false) required int? limit,
  }) = _GetMyShiftSchedulesRequest;

  factory GetMyShiftSchedulesRequest.fromJson(Map<String, dynamic> json) =>
      _$GetMyShiftSchedulesRequestFromJson(json);
}
