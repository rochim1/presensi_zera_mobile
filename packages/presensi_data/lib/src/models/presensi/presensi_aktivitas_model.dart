import 'package:json_annotation/json_annotation.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'presensi_aktivitas_model.g.dart';

@JsonSerializable(createToJson: false)
class PresensiAktivitasModel extends PresensiAktivitasEntity {
  @JsonKey(name: 'aktivitas')
  final String? aktivitas;
  @JsonKey(name: 'jam_mulai')
  final String? jamMulai;
  @JsonKey(name: 'lokasi')
  final LocationModel? lokasi;
  @JsonKey(name: 'is_late')
  final bool? isLate;

  const PresensiAktivitasModel({
    this.aktivitas,
    this.jamMulai,
    this.lokasi,
    this.isLate,
  }) : super(
         aktivitas: aktivitas,
         jamMulai: jamMulai,
         lokasi: lokasi,
         isLate: isLate,
       );

  factory PresensiAktivitasModel.fromJson(Map<String, dynamic> json) =>
      _$PresensiAktivitasModelFromJson(json);
}
