import 'package:json_annotation/json_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'location_model.g.dart';

@JsonSerializable(includeIfNull: true, createToJson: false)
class LocationModel extends LocationEntity {
  @JsonKey(name: 'longitude')
  final String? longitude;
  @JsonKey(name: 'latitude')
  final String? latitude;
  @JsonKey(name: 'name')
  final String? name;

  const LocationModel({this.longitude, this.latitude, this.name})
    : super(longitude: longitude, latitude: latitude, name: name);

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);
}
