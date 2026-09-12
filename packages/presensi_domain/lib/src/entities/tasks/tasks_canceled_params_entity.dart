import 'package:equatable/equatable.dart';
import 'package:presensi_domain/presensi_domain.dart';

class TasksCanceledParamsEntity extends Equatable {
  /// please use `StatusTask`
  final String? statusTask;
  final String? canceledTime;
  final String? alasan;
  final String? taskId;
  final String? aktivitasId;
  final String? jenisPembatalan;

  /// clear nullable in array
  final GlobalImageParamsEntity? fotoPendukung;
  final LocationEntity? lokasi;
  final bool? isLembur;

  const TasksCanceledParamsEntity({
    this.statusTask,
    this.canceledTime,
    this.alasan,
    this.taskId,
    this.aktivitasId,
    this.fotoPendukung,
    this.jenisPembatalan,
    this.lokasi,
    this.isLembur,
  });

  @override
  List<Object?> get props {
    return [
      statusTask,
      canceledTime,
      alasan,
      taskId,
      aktivitasId,
      fotoPendukung,
      jenisPembatalan,
      lokasi,
      isLembur,
    ];
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "input": {
        "status_task": statusTask,
        "completed_time": canceledTime,
        'lokasi': lokasi?.toJson(),
        "note": alasan,
        "jenis_pembatalan": jenisPembatalan,
        if (isLembur != null) "is_lembur": isLembur,
      },
      "fotoBukti": fotoPendukung != null ? [fotoPendukung!.file] : null,
      "id": taskId,
      "aktivitasId": aktivitasId,
    };
  }
}
