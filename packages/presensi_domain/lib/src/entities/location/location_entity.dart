import 'package:equatable/equatable.dart';

class LocationEntity extends Equatable {
  final String? longitude;
  final String? latitude;
  final String? name;
  final String? alamat;

  const LocationEntity({
    required this.longitude,
    required this.latitude,
    this.name,
    this.alamat,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{"longitude": longitude, "latitude": latitude};
  }

  @override
  List<Object?> get props => [longitude, latitude, name];
}
