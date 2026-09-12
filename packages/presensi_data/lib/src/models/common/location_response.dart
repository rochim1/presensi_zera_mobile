import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_data/core/utils/double_converter.dart';

part 'location_response.freezed.dart';

part 'location_response.g.dart';

@freezed
abstract class LocationResponse with _$LocationResponse {
  const factory LocationResponse({
    @JsonKey(name: 'latitude', defaultValue: 0)
    @DoubleConverter()
    required double lat,
    @JsonKey(name: 'longitude', defaultValue: 0)
    @DoubleConverter()
    required double long,
  }) = _LocationResponse;

  factory LocationResponse.fromJson(Map<String, dynamic> json) =>
      _$LocationResponseFromJson(json);
}
