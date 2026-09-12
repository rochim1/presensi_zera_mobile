import 'package:equatable/equatable.dart';
import 'package:presensi_domain/presensi_domain.dart';

class TasksFilterEntity extends Equatable {
  final GlobalPaginationEntity? pagination;
  final bool? isDetail;
  final String? taskDateAssigned;

  /// USE ENUM `StatusTask`
  final String? statusTask;

  /// USE List ENUM `StatusTask`
  final List<String>? statusTasks;

  const TasksFilterEntity({
    this.pagination,
    this.taskDateAssigned,
    this.isDetail = true,
    this.statusTasks,
    this.statusTask,
  });

  @override
  List<Object?> get props => [
    pagination,
    isDetail,
    statusTask,
    taskDateAssigned,
    statusTasks,
  ];

  TasksFilterEntity copyWith({
    GlobalPaginationEntity? pagination,
    bool? isDetail,
    String? taskDateAssigned,
    String? statusTask,
    List<String>? statusTasks,
  }) {
    return TasksFilterEntity(
      pagination: pagination ?? this.pagination,
      isDetail: isDetail ?? this.isDetail,
      statusTask: statusTask ?? this.statusTask,
      taskDateAssigned: taskDateAssigned ?? this.taskDateAssigned,
      statusTasks: statusTasks ?? this.statusTasks,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'pagination': pagination?.toJson() ?? GlobalPaginationEntity().toJson(),
      'filter': {
        'is_detail': isDetail,
        'status_task': statusTask,
        'task_date_assigned': taskDateAssigned,
      },
    };
  }

  Map<String, dynamic> toPerjalanan() {
    return <String, dynamic>{
      'pagination': pagination?.toJson() ?? GlobalPaginationEntity().toJson(),
      'filter': {
        'is_detail': isDetail,
        'status_tasks': statusTasks,
        'task_date_assigned': taskDateAssigned,
      },
    };
  }
}
