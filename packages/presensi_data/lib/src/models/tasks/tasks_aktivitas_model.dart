import 'package:json_annotation/json_annotation.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'tasks_aktivitas_model.g.dart';

@JsonSerializable(includeIfNull: true, createToJson: false)
class AktivitasModel extends AktivitasEntity {
  @JsonKey(name: '_id')
  final String? id;
  @JsonKey(name: 'no_faktur')
  final List<String>? noFaktur;
  @JsonKey(name: 'apotik_id')
  final ApotikModel? apotikId;
  // Outlet sales (model baru — GetAllVisitPlans)
  @JsonKey(name: 'outlet_id')
  final OutletModel? outlet;
  @JsonKey(name: 'from')
  final LocationModel? from;
  @JsonKey(name: 'destination')
  final LocationModel? destination;
  @JsonKey(name: 'completed_time')
  final String? completedTime;
  @JsonKey(name: 'note')
  final String? note;
  @JsonKey(name: 'status_task')
  final String? statusTask;
  @JsonKey(name: 'waktu_berangkat')
  final String? waktuBerangkat;
  @JsonKey(name: 'waktu_tiba')
  final String? waktuTiba;
  @JsonKey(name: 'note_kebutuhan')
  final String? noteKebutuhan;
  @JsonKey(name: 'jam_istirahat')
  final JamIstirahatModel? jamIstirahat;
  @JsonKey(name: 'foto_bukti')
  final List<GlobalFileModel>? fotoBukti;
  @JsonKey(name: 'foto_plakat')
  final List<GlobalFileModel>? fotoPlakat;
  @JsonKey(name: 'status_task_before')
  final String? statusTaskBefore;
  @JsonKey(name: 'estimasi_waktu_tempuh')
  final String? estimasiWaktuTempuh;
  @JsonKey(name: 'estimasi_biaya_per_task')
  final String? estimasiBiayaPerTask;
  @JsonKey(name: 'distance_from_attendance')
  final String? distanceFromAttendance;
  @JsonKey(name: 'start_time')
  final String? startTime;
  @JsonKey(name: 'estimasi_waktu_gmaps')
  final String? estimasiWaktuGmaps;
  // Sales Kunjungan fields
  @JsonKey(name: 'tujuan_pengantaran')
  final bool? tujuanPengantaran;
  @JsonKey(name: 'tujuan_penawaran')
  final bool? tujuanPenawaran;
  @JsonKey(name: 'tujuan_penagihan')
  final bool? tujuanPenagihan;
  @JsonKey(name: 'no_referensi')
  final List<String>? noReferensi;
  @JsonKey(name: 'referensi_mode')
  final String? referensiMode;
  @JsonKey(name: 'tipe_call')
  final String? tipeCall;
  @JsonKey(name: 'order_value')
  final double? orderValue;
  @JsonKey(name: 'note_before_done')
  final String? noteBeforeDone;
  @JsonKey(name: 'is_completed_by_other', defaultValue: false)
  final bool isCompletedByOther;
  @JsonKey(name: 'completed_by_name')
  final String? completedByName;

  const AktivitasModel({
    this.id,
    this.noFaktur,
    this.apotikId,
    this.outlet,
    this.from,
    this.destination,
    this.completedTime,
    this.note,
    this.statusTask,
    this.waktuBerangkat,
    this.waktuTiba,
    this.noteKebutuhan,
    this.fotoBukti,
    this.jamIstirahat,
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
  }) : super(
         id: id,
         noFaktur: noFaktur,
         apotikId: apotikId,
         outlet: outlet,
         from: from,
         destination: destination,
         completedTime: completedTime,
         note: note,
         statusTask: statusTask,
         waktuBerangkat: waktuBerangkat,
         waktuTiba: waktuTiba,
         noteKebutuhan: noteKebutuhan,
         fotoBukti: fotoBukti,
         jamIstirahat: jamIstirahat,
         fotoPlakat: fotoPlakat,
         statusTaskBefore: statusTaskBefore,
         estimasiWaktuTempuh: estimasiWaktuTempuh,
         estimasiBiayaPerTask: estimasiBiayaPerTask,
         distanceFromAttendance: distanceFromAttendance,
         startTime: startTime,
         estimasiWaktuGmaps: estimasiWaktuGmaps,
         tujuanPengantaran: tujuanPengantaran,
         tujuanPenawaran: tujuanPenawaran,
         tujuanPenagihan: tujuanPenagihan,
         noReferensi: noReferensi,
         referensiMode: referensiMode,
         tipeCall: tipeCall,
         orderValue: orderValue,
         noteBeforeDone: noteBeforeDone,
         isCompletedByOther: isCompletedByOther,
         completedByName: completedByName,
       );

  factory AktivitasModel.fromJson(Map<String, dynamic> json) =>
      _$AktivitasModelFromJson(json);
}
