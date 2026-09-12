import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'inventaris_model.g.dart';

@HiveType(typeId: 6)
@JsonSerializable(includeIfNull: true, createToJson: false)
class InventarisModel extends InventarisEntity {
  @HiveField(0)
  @JsonKey(name: '_id')
  final String? id;
  @HiveField(1)
  @JsonKey(name: 'jenis_kendaraan')
  final String? jenisKendaraan;
  @HiveField(2)
  @JsonKey(name: 'merk')
  final String? merk;
  @HiveField(3)
  @JsonKey(name: 'plat_nomer')
  final String? platNomer;
  @HiveField(4)
  @JsonKey(name: 'jadwal_servis_terakhir')
  final String? jadwalServisTerakhir;
  @HiveField(5)
  @JsonKey(name: 'kilometer_terakhir')
  final String? kilometerTerakhir;
  @HiveField(6)
  @JsonKey(name: 'kilometer_kembali_servis')
  final String? kilometerKembaliServis;
  @HiveField(7)
  @JsonKey(name: 'tanggal_pembayaran_pajak')
  final String? tanggalPembayaranPajak;
  @HiveField(8)
  @JsonKey(name: 'total_biaya_pajak')
  final String? totalBiayaPajak;
  @HiveField(9)
  @JsonKey(name: 'is_cycle_office')
  final bool? isCycleOffice;

  const InventarisModel({
    this.id,
    this.jenisKendaraan,
    this.merk,
    this.platNomer,
    this.jadwalServisTerakhir,
    this.kilometerTerakhir,
    this.kilometerKembaliServis,
    this.tanggalPembayaranPajak,
    this.totalBiayaPajak,
    this.isCycleOffice,
  }) : super(
         id: id,
         jenisKendaraan: jenisKendaraan,
         merk: merk,
         platNomer: platNomer,
         jadwalServisTerakhir: jadwalServisTerakhir,
         kilometerTerakhir: kilometerTerakhir,
         kilometerKembaliServis: kilometerKembaliServis,
         tanggalPembayaranPajak: tanggalPembayaranPajak,
         totalBiayaPajak: totalBiayaPajak,
         isCycleOffice: isCycleOffice,
       );

  factory InventarisModel.fromJson(Map<String, dynamic> json) =>
      _$InventarisModelFromJson(json);
}
