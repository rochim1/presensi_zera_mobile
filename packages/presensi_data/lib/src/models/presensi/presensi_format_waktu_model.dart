import 'package:json_annotation/json_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'presensi_format_waktu_model.g.dart';

@JsonSerializable(createToJson: false)
class PresensiFormatWaktuModel extends PresensiFormatWaktuEntity {
  @JsonKey(name: 'jam_masuk_kerja')
  final String? jamMasukKerja;
  @JsonKey(name: 'jam_istirahat_kerja')
  final String? jamIstirahatKerja;
  @JsonKey(name: 'jam_kembali_kerja')
  final String? jamKembaliKerja;
  @JsonKey(name: 'jam_pulang_kerja')
  final String? jamPulangKerja;

  const PresensiFormatWaktuModel({
    this.jamMasukKerja,
    this.jamIstirahatKerja,
    this.jamKembaliKerja,
    this.jamPulangKerja,
  }) : super(
         jamMasukKerja: jamMasukKerja,
         jamIstirahatKerja: jamIstirahatKerja,
         jamKembaliKerja: jamKembaliKerja,
         jamPulangKerja: jamPulangKerja,
       );

  factory PresensiFormatWaktuModel.fromJson(Map<String, dynamic> json) =>
      _$PresensiFormatWaktuModelFromJson(json);
}
