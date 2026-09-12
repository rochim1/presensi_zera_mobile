import 'package:presensi_domain/src/entities/task_report/task_report.dart';

class TaskReportSummaryModel extends TaskReportSummary {
  const TaskReportSummaryModel({
    required super.totalTasks,
    required super.totalTasksDone,
    required super.totalTasksPending,
    required super.totalTasksCancel,
    required super.totalCost,
    required super.totalOrderValue,
    required super.totalDistanceFinal,
  });

  factory TaskReportSummaryModel.fromJson(Map<String, dynamic> json) {
    return TaskReportSummaryModel(
      totalTasks: json['total_tasks'] ?? 0,
      totalTasksDone: json['total_tasks_done'] ?? 0,
      totalTasksPending: json['total_tasks_pending'] ?? 0,
      totalTasksCancel: json['total_tasks_cancel'] ?? 0,
      totalCost: (json['total_cost'] ?? 0).toDouble(),
      totalOrderValue: (json['total_order_value'] ?? 0).toDouble(),
      totalDistanceFinal: (json['total_distance_final'] ?? 0).toDouble(),
    );
  }
}
