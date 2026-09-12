import 'package:presensi_domain/presensi_domain.dart';
import 'package:equatable/equatable.dart';

class AktivitasEntity extends Equatable {
  final String? id;
  final List<String>? noFaktur;
  final ApotekEntity? apotikId;
  // Outlet sales (model baru — GetAllVisitPlans)
  final OutletEntity? outlet;
  final LocationEntity? from;
  final LocationEntity? destination;
  final String? note;
  final String? statusTask;
  final String? waktuBerangkat;
  final String? waktuTiba;
  final String? noteKebutuhan;
  final JamIstirahatEntity? jamIstirahat;
  final String? completedTime;
  final List<GlobalFileEntity>? fotoBukti;
  final List<GlobalFileEntity>? fotoPlakat;
  final String? statusTaskBefore;
  final String? estimasiWaktuTempuh;
  final String? estimasiBiayaPerTask;
  final String? distanceFromAttendance;
  final String? startTime;
  final String? estimasiWaktuGmaps;
  // Sales Kunjungan fields
  final bool? tujuanPengantaran;
  final bool? tujuanPenawaran;
  final bool? tujuanPenagihan;
  final List<String>? noReferensi;
  final String? referensiMode;
  final String? tipeCall;
  final double? orderValue;
  final String? noteBeforeDone;
  final bool isCompletedByOther;
  final String? completedByName;

  const AktivitasEntity({
    this.id,
    this.noFaktur,
    this.apotikId,
    this.outlet,
    this.from,
    this.destination,
    this.note,
    this.statusTask,
    this.waktuBerangkat,
    this.waktuTiba,
    this.noteKebutuhan,
    this.fotoBukti,
    this.jamIstirahat,
    this.completedTime,
    this.fotoPlakat,
    this.statusTaskBefore,
    this.estimasiWaktuTempuh,
    this.estimasiBiayaPerTask,
    this.distanceFromAttendance,
    this.startTime,
    this.estimasiWaktuGmaps,
    this.tujuanPengantaran,
    this.tujuanPenawaran,
    this.tujuanPenagihan,
    this.noReferensi,
    this.referensiMode,
    this.tipeCall,
    this.orderValue,
    this.noteBeforeDone,
    this.isCompletedByOther = false,
    this.completedByName,
  });

  @override
  List<Object?> get props => [
    id,
    noFaktur,
    apotikId,
    outlet,
    from,
    destination,
    note,
    statusTask,
    waktuBerangkat,
    waktuTiba,
    noteKebutuhan,
    fotoBukti,
    jamIstirahat,
    completedTime,
    fotoPlakat,
    statusTaskBefore,
    estimasiWaktuTempuh,
    estimasiBiayaPerTask,
    distanceFromAttendance,
    startTime,
    estimasiWaktuGmaps,
    tujuanPengantaran,
    tujuanPenawaran,
    tujuanPenagihan,
    noReferensi,
    referensiMode,
    tipeCall,
    orderValue,
    noteBeforeDone,
    isCompletedByOther,
    completedByName,
  ];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "outlet_id": apotikId?.id ?? outlet?.id,
      "no_referensi": noFaktur,
      "note": note,
      "tujuan_penawaran": tujuanPenawaran,
      "tujuan_pengantaran": tujuanPengantaran,
      "tujuan_penagihan": tujuanPenagihan,
      "status_task": statusTask ?? "pending",
    };
    data.removeWhere(
      (key, value) => value == null || (value is List && value.isEmpty),
    );
    return data;
  }
}
