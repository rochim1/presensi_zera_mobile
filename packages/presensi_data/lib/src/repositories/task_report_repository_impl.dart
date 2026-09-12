import 'package:presensi_data/src/datasources/remote/task_report_remote_datasource.dart';
import 'package:presensi_domain/src/entities/task_report/task_report.dart';
import 'package:presensi_domain/src/repositories/task_report_repository.dart';

class TaskReportRepositoryImpl implements TaskReportRepository {
  final TaskReportRemoteDatasource remoteDatasource;

  TaskReportRepositoryImpl(this.remoteDatasource);

  @override
  Future<TaskReportSummary?> getMyTaskReportSummary(
      {required String tipeLaporan, String? periode}) async {
    return await remoteDatasource.getMyTaskReportSummary(tipeLaporan, periode);
  }
}
