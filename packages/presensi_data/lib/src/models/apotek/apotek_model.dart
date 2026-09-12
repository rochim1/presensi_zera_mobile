import 'package:json_annotation/json_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'apotek_model.g.dart';

@JsonSerializable(includeIfNull: true, createToJson: false)
class ApotikModel extends ApotekEntity {
  @JsonKey(name: '_id')
  final String? id;
  @JsonKey(name: 'kode_outlet')
  final String? kodeApotik;
  @JsonKey(name: 'nama_outlet')
  final String? namaApotik;
  @JsonKey(name: 'nama_resmi')
  final String? namaResmi;
  @JsonKey(name: 'nama_PIC')
  final String? namaAPJ;
  @JsonKey(name: 'no_ijin')
  final String? noIzinApotik;
  @JsonKey(name: 'kode_petugas')
  final String? kodePetugas;
  @JsonKey(name: 'nama_owner')
  final String? namaOwner;
  @JsonKey(name: 'logo')
  final String? logo;
  @JsonKey(name: 'email')
  final String? email;
  @JsonKey(name: 'alamat')
  final String? alamat;
  @JsonKey(name: 'kode_pos')
  final String? kodePos;
  @JsonKey(name: 'maps')
  final String? maps;
  @JsonKey(name: 'longitude')
  final String? longitude;
  @JsonKey(name: 'latitude')
  final String? latitude;
  @JsonKey(name: 'kota')
  final String? kota;
  @JsonKey(name: 'provinsi')
  final String? provinsi;
  @JsonKey(name: 'kabupaten')
  final String? kabupaten;
  @JsonKey(name: 'kecamatan')
  final String? kecamatan;
  @JsonKey(name: 'kelurahan')
  final String? kelurahan;
  @JsonKey(name: 'telpon_number')
  final String? telponNumber;
  @JsonKey(name: 'status')
  final String? status;
  @JsonKey(name: 'note')
  final String? catatan;
  @JsonKey(name: 'tipe_outlet')
  final String? tipeOutlet;
  @JsonKey(name: 'area')
  final String? area;
  @JsonKey(name: 'kategori_produk')
  final String? kategoriProduk;
  @JsonKey(name: 'total_value')
  final double? totalValue;
  @JsonKey(name: 'last_order_date')
  final String? lastOrderDate;
  @JsonKey(name: 'user_created', fromJson: _extractUserName)
  final String? userCreatedName;

  static String? _extractUserName(dynamic json) {
    if (json is Map<String, dynamic>) {
      return json['name'] as String?;
    }
    return null;
  }

  ApotikModel({
    this.id,
    this.kodeApotik,
    this.namaApotik,
    this.namaResmi,
    this.namaAPJ,
    this.noIzinApotik,
    this.kodePetugas,
    this.namaOwner,
    this.logo,
    this.email,
    this.alamat,
    this.kodePos,
    this.maps,
    this.longitude,
    this.latitude,
    this.kota,
    this.provinsi,
    this.kabupaten,
    this.kecamatan,
    this.kelurahan,
    this.telponNumber,
    this.status,
    this.catatan,
    this.tipeOutlet,
    this.area,
    this.kategoriProduk,
    this.totalValue,
    this.lastOrderDate,
    this.userCreatedName,
  }) : super(
         id: id,
         kodeApotik: kodeApotik,
         namaApotik: namaApotik,
         namaResmi: namaResmi,
         namaAPJ: namaAPJ,
         noIzinApotik: noIzinApotik,
         kodePetugas: kodePetugas,
         namaOwner: namaOwner,
         logo: logo,
         email: email,
         alamat: alamat,
         kodePos: kodePos,
         maps: maps,
         longitude: longitude,
         latitude: latitude,
         kota: kota,
         provinsi: provinsi,
         kabupaten: kabupaten,
         kecamatan: kecamatan,
         kelurahan: kelurahan,
         telponNumber: telponNumber,
         status: status,
         catatan: catatan,
         tipeOutlet: tipeOutlet,
         area: area,
         kategoriProduk: kategoriProduk,
         totalValue: totalValue,
         lastOrderDate: lastOrderDate,
         userCreatedName: userCreatedName,
       );

  factory ApotikModel.fromJson(Map<String, dynamic> json) =>
      _$ApotikModelFromJson(json);
}
