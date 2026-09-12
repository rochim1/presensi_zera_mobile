import 'package:json_annotation/json_annotation.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'tasks_model.g.dart';

@JsonSerializable(includeIfNull: true, createToJson: false)
class TasksModel extends TasksEntity {
  @JsonKey(name: '_id')
  final String? id;
  @JsonKey(name: 'jenis_task')
  final String? jenisTask;
  @JsonKey(name: 'task_date_assigned')
  final String? taskDateAssigned;
  @JsonKey(name: 'task_date_done')
  final String? taskDateDone;
  @JsonKey(name: 'aktivitas')
  final AktivitasModel? aktivitas;
  @JsonKey(name: 'keterangan')
  final String? keterangan;
  @JsonKey(name: 'total_waktu_tempuh')
  final String? totalWaktuTempuh;
  @JsonKey(name: 'is_all_done')
  final bool? isAllDone;
  @JsonKey(name: 'inventaris_id')
  final InventarisModel? inventaris;
  @JsonKey(name: 'total_waktu_istirahat')
  final String? totalWaktuIstirahat;
  @JsonKey(name: 'biaya_actually')
  final String? biayaActually;
  @JsonKey(name: 'count_jarak_from_attendance')
  final String? countJarakFromAttendance;
  @JsonKey(name: 'count_jarak_from_office')
  final String? countJarakFromOffice;
  @JsonKey(name: 'is_assigned')
  final bool? isAssigned;
  @JsonKey(name: 'total_waktu_gmaps')
  final String? totalWaktuGmaps;

  const TasksModel({
    this.id,
    this.jenisTask,
    this.taskDateAssigned,
    this.taskDateDone,
    this.aktivitas,
    this.keterangan,
    this.totalWaktuTempuh,
    this.isAllDone,
    this.inventaris,
    this.totalWaktuIstirahat,
    this.biayaActually,
    this.countJarakFromAttendance,
    this.countJarakFromOffice,
    this.isAssigned,
    this.totalWaktuGmaps,
  }) : super(
         id: id,
         jenisTask: jenisTask,
         taskDateAssigned: taskDateAssigned,
         taskDateDone: taskDateDone,
         aktivitas: aktivitas,
         keterangan: keterangan,
         totalWaktuTempuh: totalWaktuTempuh,
         isAllDone: isAllDone,
         inventaris: inventaris,
         totalWaktuIstirahat: totalWaktuIstirahat,
         biayaActually: biayaActually,
         countJarakFromAttendance: countJarakFromAttendance,
         countJarakFromOffice: countJarakFromOffice,
         isAssigned: isAssigned,
         totalWaktuGmaps: totalWaktuGmaps,
       );

  factory TasksModel.fromJson(Map<String, dynamic> json) =>
      _$TasksModelFromJson(json);
}
