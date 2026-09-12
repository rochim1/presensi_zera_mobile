import 'package:presensi_data/graphql/task_report_graphql.dart';
import 'package:presensi_data/service/graphql/graphql_service.dart';
import 'package:presensi_data/src/models/task_report/task_report_model.dart';

abstract class TaskReportRemoteDatasource {
  Future<TaskReportSummaryModel?> getMyTaskReportSummary(
      String tipeLaporan, String? periode);
}

class TaskReportRemoteDatasourceImpl
    with TaskReportGraphQl
    implements TaskReportRemoteDatasource {
  final GraphQlService graphQlService;

  TaskReportRemoteDatasourceImpl(this.graphQlService);

  @override
  Future<TaskReportSummaryModel?> getMyTaskReportSummary(
      String tipeLaporan, String? periode) async {
    final variables = {
      "filter": {
        "tipe_laporan": tipeLaporan,
        if (periode != null) "pilih_tanggal": periode,
        "is_my_report": true,
      },
      "pagination": {
        "page": 1,
        "limit": 1,
      }
    };

    final result = await graphQlService.query(
      query: getMyTaskReport,
      variables: variables,
    );

    if (result['GetAllTaskReport'] != null &&
        result['GetAllTaskReport']['additional_info'] != null) {
      return TaskReportSummaryModel.fromJson(
          result['GetAllTaskReport']['additional_info'] as Map<String, dynamic>);
    }

    return null;
  }
}
