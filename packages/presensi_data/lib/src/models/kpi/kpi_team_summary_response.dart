import 'package:freezed_annotation/freezed_annotation.dart';

part 'kpi_team_summary_response.freezed.dart';
part 'kpi_team_summary_response.g.dart';

@freezed
abstract class KpiGradeDistributionResponse with _$KpiGradeDistributionResponse {
  const factory KpiGradeDistributionResponse({
    String? grade,
    String? label,
    int? count,
    String? warna,
  }) = _KpiGradeDistributionResponse;

  factory KpiGradeDistributionResponse.fromJson(Map<String, dynamic> json) => _$KpiGradeDistributionResponseFromJson(json);
}

@freezed
abstract class KpiTeamSummaryResponse with _$KpiTeamSummaryResponse {
  const factory KpiTeamSummaryResponse({
    int? total_karyawan,
    int? completed,
    int? in_progress,
    int? not_started,
    double? avg_score,
    List<KpiGradeDistributionResponse>? grade_distribution,
  }) = _KpiTeamSummaryResponse;

  factory KpiTeamSummaryResponse.fromJson(Map<String, dynamic> json) => _$KpiTeamSummaryResponseFromJson(json);
}
