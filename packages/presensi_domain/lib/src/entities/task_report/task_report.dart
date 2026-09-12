import 'package:equatable/equatable.dart';

class TaskReportSummary extends Equatable {
  final int totalTasks;
  final int totalTasksDone;
  final int totalTasksPending;
  final int totalTasksCancel;
  final double totalCost; // biaya transportasi (BBM/listrik)
  final double totalOrderValue; // total nilai order
  final double totalDistanceFinal; // total jarak (km)

  const TaskReportSummary({
    required this.totalTasks,
    required this.totalTasksDone,
    required this.totalTasksPending,
    required this.totalTasksCancel,
    required this.totalCost,
    required this.totalOrderValue,
    required this.totalDistanceFinal,
  });

  @override
  List<Object?> get props => [
        totalTasks,
        totalTasksDone,
        totalTasksPending,
        totalTasksCancel,
        totalCost,
        totalOrderValue,
        totalDistanceFinal,
      ];
}
