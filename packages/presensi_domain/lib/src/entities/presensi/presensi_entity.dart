import 'package:equatable/equatable.dart';
import 'package:presensi_domain/presensi_domain.dart';

class PresensiEntity extends Equatable {
  final String? id;
  final String? instansiId;
  final String? tanggalPresensi;
  final String? jamMasuk;
  final String? jamPulang;
  final String? totalKerja;
  final bool? isPermitInWorkingTime;
  final String? sisaIstirahat;
  final bool? isAllTasksDone;
  final String? keterangan;
  final PresensiPhotoEntity? fotoPendukung;
  final PresensiPhotoEntity? fotoPresensi;
  final LocationEntity? locationCheckIn;
  final LocationEntity? locationCheckOut;
  final String? totalIstirahat;
  final String? statusKerja;
  final List<PresensiBreakTimeEntity>? jamIstirahat;
  final bool? isJoinWork;
  final String? statusKerjaDisp;
  final PresensiFormatWaktuEntity? formatWaktu;
  final List<PresensiAktivitasEntity>? aktivitas;
  final bool? hasTaskToday;
  final String? typePresensi;

  const PresensiEntity({
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
  });

  @override
  List<Object?> get props {
    return [
      id,
      instansiId,
      tanggalPresensi,
      jamMasuk,
      jamPulang,
      totalKerja,
      isPermitInWorkingTime,
      sisaIstirahat,
      isAllTasksDone,
      keterangan,
      fotoPendukung,
      fotoPresensi,
      locationCheckIn,
      locationCheckOut,
      totalIstirahat,
      statusKerja,
      jamIstirahat,
      isJoinWork,
      statusKerjaDisp,
      formatWaktu,
      aktivitas,
      hasTaskToday,
      typePresensi,
    ];
  }
}
