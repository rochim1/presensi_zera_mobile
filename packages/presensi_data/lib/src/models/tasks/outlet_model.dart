import 'package:json_annotation/json_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'outlet_model.g.dart';

@JsonSerializable(includeIfNull: true, createToJson: false)
class OutletModel extends OutletEntity {
  @JsonKey(name: '_id')
  final String? id;
  @JsonKey(name: 'nama_outlet')
  final String? namaOutlet;
  @JsonKey(name: 'kode_outlet')
  final String? kodeOutlet;
  @JsonKey(name: 'alamat')
  final String? alamat;
  @JsonKey(name: 'telpon_number')
  final String? telponNumber;
  @JsonKey(name: 'price_level')
  final String? priceLevel;
  @JsonKey(name: 'latitude')
  final String? latitude;
  @JsonKey(name: 'longitude')
  final String? longitude;

  const OutletModel({
    this.id,
    this.namaOutlet,
    this.kodeOutlet,
    this.alamat,
    this.telponNumber,
    this.priceLevel,
    this.latitude,
    this.longitude,
  }) : super(
         id: id,
         namaOutlet: namaOutlet,
         kodeOutlet: kodeOutlet,
         alamat: alamat,
         telponNumber: telponNumber,
         priceLevel: priceLevel,
         latitude: latitude,
         longitude: longitude,
       );

  factory OutletModel.fromJson(Map<String, dynamic> json) =>
      _$OutletModelFromJson(json);
}
