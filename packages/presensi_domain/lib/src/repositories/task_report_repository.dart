import 'package:presensi_domain/src/entities/task_report/task_report.dart';

abstract class TaskReportRepository {
  Future<TaskReportSummary?> getMyTaskReportSummary({required String tipeLaporan, String? periode});
}
