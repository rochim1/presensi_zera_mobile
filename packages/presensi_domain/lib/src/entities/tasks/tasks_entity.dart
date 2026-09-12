import 'package:equatable/equatable.dart';
import 'package:presensi_domain/presensi_domain.dart';

class TasksEntity extends Equatable {
  final String? id;
  final String? jenisTask;
  final String? taskDateAssigned;
  final String? taskDateDone;
  final AktivitasEntity? aktivitas;
  final String? keterangan;
  final bool? isAllDone;
  final InventarisEntity? inventaris;
  final String? totalWaktuTempuh;
  final String? totalWaktuIstirahat;
  final String? biayaActually;
  final String? countJarakFromAttendance;
  final String? countJarakFromOffice;
  final bool? isAssigned;
  final String? totalWaktuGmaps;

  const TasksEntity({
    this.id,
    this.jenisTask,
    this.taskDateAssigned,
    this.taskDateDone,
    this.aktivitas,
    this.keterangan,
    this.isAllDone,
    this.inventaris,
    this.totalWaktuIstirahat,
    this.totalWaktuTempuh,
    this.biayaActually,
    this.countJarakFromAttendance,
    this.countJarakFromOffice,
    this.isAssigned,
    this.totalWaktuGmaps,
  });

  @override
  List<Object?> get props {
    return [
      id,
      jenisTask,
      taskDateAssigned,
      taskDateDone,
      aktivitas,
      keterangan,
      totalWaktuTempuh,
      isAllDone,
      inventaris,
      totalWaktuIstirahat,
      totalWaktuTempuh,
      biayaActually,
      countJarakFromAttendance,
      countJarakFromOffice,
      isAssigned,
      totalWaktuGmaps,
    ];
  }
}
