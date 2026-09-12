import 'package:presensi_data/presensi_data.dart';

abstract class KpiRemoteDatasource {
  Future<List<KpiAssignmentResponse>> getMyAssignments({
    String? status,
    String? periodeLabel,
    int page = 1,
    int limit = 10,
  });
  Future<KpiAssignmentResponse> getAssignmentDetail(String id);
  Future<List<KpiAssignmentResponse>> getTeamAssignments({
    String? status,
    String? periodeLabel,
    int page = 1,
    int limit = 10,
  });
  Future<KpiTeamSummaryResponse> getTeamSummary({
    String? status,
    String? periodeLabel,
  });
  Future<void> submitSelfAssessment(KpiSelfAssessmentRequest input);
  Future<void> submitManagerReview(KpiManagerReviewRequest input);
  Future<void> acknowledgeKpi(String assignmentId);
}

class KpiRemoteDatasourceImpl with KpiGraphQl implements KpiRemoteDatasource {
  final GraphQlService gql;

  KpiRemoteDatasourceImpl({required this.gql});

  @override
  Future<List<KpiAssignmentResponse>> getMyAssignments({
    String? status,
    String? periodeLabel,
    int page = 1,
    int limit = 10,
  }) async {
    final filter = <String, dynamic>{};
    if (status != null && status.isNotEmpty) filter['status'] = status;
    if (periodeLabel != null && periodeLabel.isNotEmpty)
      filter['periode_label'] = periodeLabel;

    final pagination = {'page': page, 'limit': limit};

    final result = await gql.query(
      query: getMyKpiAssignmentsQuery,
      variables: {'filter': filter, 'pagination': pagination},
    );

    final data = result?['GetMyKpiAssignments']?['data'] as List?;
    if (data == null) return [];

    return data.map((e) => KpiAssignmentResponse.fromJson(e)).toList();
  }

  @override
  Future<KpiAssignmentResponse> getAssignmentDetail(String id) async {
    final result = await gql.query(
      query: getMyKpiAssignmentDetailQuery,
      variables: {'_id': id},
    );

    final data = result?['GetMyKpiAssignmentDetail'];
    if (data == null) throw GraphQlException(message: 'Assignment not found');

    return KpiAssignmentResponse.fromJson(data);
  }

  @override
  Future<List<KpiAssignmentResponse>> getTeamAssignments({
    String? status,
    String? periodeLabel,
    int page = 1,
    int limit = 10,
  }) async {
    final filter = <String, dynamic>{};
    if (status != null && status.isNotEmpty) filter['status'] = status;
    if (periodeLabel != null && periodeLabel.isNotEmpty)
      filter['periode_label'] = periodeLabel;

    final pagination = {'page': page, 'limit': limit};

    final result = await gql.query(
      query: getTeamKpiAssignmentsQuery,
      variables: {'filter': filter, 'pagination': pagination},
    );

    final data = result?['GetTeamKpiAssignments']?['data'] as List?;
    if (data == null) return [];

    return data.map((e) => KpiAssignmentResponse.fromJson(e)).toList();
  }

  @override
  Future<KpiTeamSummaryResponse> getTeamSummary({
    String? status,
    String? periodeLabel,
  }) async {
    final filter = <String, dynamic>{};
    if (status != null && status.isNotEmpty) filter['status'] = status;
    if (periodeLabel != null && periodeLabel.isNotEmpty)
      filter['periode_label'] = periodeLabel;

    final result = await gql.query(
      query: getTeamKpiSummaryQuery,
      variables: {'filter': filter},
    );

    final data = result?['GetTeamKpiSummary'];
    if (data == null)
      return const KpiTeamSummaryResponse(
        total_karyawan: 0,
        completed: 0,
        in_progress: 0,
        not_started: 0,
        avg_score: 0,
      );

    return KpiTeamSummaryResponse.fromJson(data);
  }

  @override
  Future<void> submitSelfAssessment(KpiSelfAssessmentRequest input) async {
    await gql.mutation(
      mutation: submitSelfAssessmentMutation,
      variables: {'input': input.toJson()},
    );
  }

  @override
  Future<void> submitManagerReview(KpiManagerReviewRequest input) async {
    await gql.mutation(
      mutation: submitManagerReviewMutation,
      variables: {'input': input.toJson()},
    );
  }

  @override
  Future<void> acknowledgeKpi(String assignmentId) async {
    await gql.mutation(
      mutation: acknowledgeKpiMutation,
      variables: {'assignment_id': assignmentId},
    );
  }
}
