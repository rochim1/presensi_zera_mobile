import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'instansi_model.g.dart';

@HiveType(typeId: 5)
@JsonSerializable(includeIfNull: true, createToJson: false)
class InstansiModel extends InstansiEntity {
  @HiveField(0)
  @JsonKey(name: 'nama_resmi')
  final String? namaResmi;
  @HiveField(1)
  @JsonKey(name: 'logo')
  final String? logo;
  @HiveField(2)
  @JsonKey(name: 'nama_instansi')
  final String? namaInstansi;
  @JsonKey(name: 'website')
  @HiveField(3)
  final String? website;
  @JsonKey(name: 'telpon_number')
  @HiveField(4)
  final String? telponNumber;
  @JsonKey(name: 'tahun_berdiri')
  @HiveField(5)
  final String? tahunBerdiri;
  @JsonKey(name: 'alamat')
  @HiveField(6)
  final String? alamat;
  @JsonKey(name: 'kegiatan_usaha')
  @HiveField(7)
  final String? kegiatanUsaha;
  @JsonKey(name: 'dasar_hukum_pendirian')
  @HiveField(8)
  final String? dasarHukumPendirian;
  @JsonKey(name: 'subscription_status')
  @HiveField(9)
  final String? subscriptionStatus;

  const InstansiModel({
    this.namaResmi,
    this.logo,
    this.namaInstansi,
    this.website,
    this.telponNumber,
    this.tahunBerdiri,
    this.alamat,
    this.kegiatanUsaha,
    this.dasarHukumPendirian,
    this.subscriptionStatus,
  }) : super(
         namaResmi: namaResmi,
         logo: logo,
         namaInstansi: namaInstansi,
         website: website,
         telponNumber: telponNumber,
         tahunBerdiri: tahunBerdiri,
         alamat: alamat,
         kegiatanUsaha: kegiatanUsaha,
         dasarHukumPendirian: dasarHukumPendirian,
         subscriptionStatus: subscriptionStatus,
       );

  factory InstansiModel.fromJson(Map<String, dynamic> json) =>
      _$InstansiModelFromJson(json);
}
