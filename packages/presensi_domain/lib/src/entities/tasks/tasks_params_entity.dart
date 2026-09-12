import 'package:equatable/equatable.dart';
import 'package:presensi_domain/presensi_domain.dart';

class TasksParamsEntity extends Equatable {
  final String? inventarisId;
  final String? taskDateAssigned;
  final AktivitasEntity? aktivitas;

  const TasksParamsEntity({
    this.inventarisId,
    this.taskDateAssigned,
    this.aktivitas,
  });

  @override
  List<Object?> get props => [inventarisId, taskDateAssigned, aktivitas];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> input = {
      "inventaris_id": inventarisId,
      "task_date_assigned": taskDateAssigned,
      "aktivitas": aktivitas != null ? [aktivitas!.toJson()] : [],
    };
    input.removeWhere((key, value) => value == null);

    return <String, dynamic>{
      "input": input,
    };
  }
}
