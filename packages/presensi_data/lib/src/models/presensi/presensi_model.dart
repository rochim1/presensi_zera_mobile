import 'package:json_annotation/json_annotation.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'presensi_model.g.dart';

@JsonSerializable(createToJson: false)
class PresensiModel extends PresensiEntity {
  @JsonKey(name: '_id')
  final String? id;
  @JsonKey(name: 'instansi_id')
  final String? instansiId;
  @JsonKey(name: 'tanggal_presensi')
  final String? tanggalPresensi;
  @JsonKey(name: 'jam_masuk')
  final String? jamMasuk;
  @JsonKey(name: 'jam_pulang')
  final String? jamPulang;
  @JsonKey(name: 'total_kerja')
  final String? totalKerja;
  @JsonKey(name: 'is_permit_in_working_time')
  final bool? isPermitInWorkingTime;
  @JsonKey(name: 'sisa_istirahat')
  final String? sisaIstirahat;
  @JsonKey(name: 'is_all_tasks_done')
  final bool? isAllTasksDone;
  @JsonKey(name: 'keterangan')
  final String? keterangan;
  @JsonKey(name: 'foto_pendukung')
  final PresensiPhotoModel? fotoPendukung;
  @JsonKey(name: 'foto_presensi')
  final PresensiPhotoModel? fotoPresensi;
  @JsonKey(name: 'location_check_in')
  final LocationModel? locationCheckIn;
  @JsonKey(name: 'location_check_out')
  final LocationModel? locationCheckOut;
  @JsonKey(name: 'total_istirahat')
  final String? totalIstirahat;
  @JsonKey(name: 'status_kerja')
  final String? statusKerja;
  @JsonKey(name: 'jam_istirahat')
  final List<PresensiBreakTimeModel>? jamIstirahat;
  @JsonKey(name: 'isJoin_work')
  final bool? isJoinWork;
  @JsonKey(name: 'status_kerja_disp')
  final String? statusKerjaDisp;
  @JsonKey(name: 'format_waktu')
  final PresensiFormatWaktuModel? formatWaktu;
  @JsonKey(name: 'aktivitas')
  final List<PresensiAktivitasModel>? aktivitas;
  @JsonKey(name: 'has_task_today')
  final bool? hasTaskToday;
  @JsonKey(name: 'type_presensi')
  final String? typePresensi;

  const PresensiModel({
    this.id,
    this.instansiId,
    this.tanggalPresensi,
    this.jamMasuk,
    this.jamPulang,
    this.totalKerja,
    this.isPermitInWorkingTime,
    this.sisaIstirahat,
    this.isAllTasksDone,
    this.keterangan,
    this.fotoPendukung,
    this.fotoPresensi,
    this.locationCheckIn,
    this.locationCheckOut,
    this.totalIstirahat,
    this.statusKerja,
    this.jamIstirahat,
    this.isJoinWork,
    this.statusKerjaDisp,
    this.formatWaktu,
    this.aktivitas,
    this.hasTaskToday,
    this.typePresensi,
  }) : super(
         id: id,
         instansiId: instansiId,
         tanggalPresensi: tanggalPresensi,
         jamMasuk: jamMasuk,
         jamPulang: jamPulang,
         totalKerja: totalKerja,
         isPermitInWorkingTime: isPermitInWorkingTime,
         sisaIstirahat: sisaIstirahat,
         isAllTasksDone: isAllTasksDone,
         keterangan: keterangan,
         fotoPendukung: fotoPendukung,
         fotoPresensi: fotoPresensi,
         locationCheckIn: locationCheckIn,
         locationCheckOut: locationCheckOut,
         totalIstirahat: totalIstirahat,
         statusKerja: statusKerja,
         jamIstirahat: jamIstirahat,
         isJoinWork: isJoinWork,
         statusKerjaDisp: statusKerjaDisp,
         formatWaktu: formatWaktu,
         aktivitas: aktivitas,
         hasTaskToday: hasTaskToday,
         typePresensi: typePresensi,
       );

  factory PresensiModel.fromJson(Map<String, dynamic> json) =>
      _$PresensiModelFromJson(json);
}
