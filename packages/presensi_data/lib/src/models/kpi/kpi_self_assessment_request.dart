import 'package:freezed_annotation/freezed_annotation.dart';

part 'kpi_self_assessment_request.freezed.dart';
part 'kpi_self_assessment_request.g.dart';

@freezed
abstract class SelfScoreInputRequest with _$SelfScoreInputRequest {
  const factory SelfScoreInputRequest({
    required String indicator_id,
    required double self_rating,
    String? catatan_karyawan,
  }) = _SelfScoreInputRequest;

  factory SelfScoreInputRequest.fromJson(Map<String, dynamic> json) => _$SelfScoreInputRequestFromJson(json);
}

@freezed
abstract class KpiSelfAssessmentRequest with _$KpiSelfAssessmentRequest {
  const factory KpiSelfAssessmentRequest({
    required String assignment_id,
    required List<SelfScoreInputRequest> scores,
    String? catatan_karyawan_global,
  }) = _KpiSelfAssessmentRequest;

  factory KpiSelfAssessmentRequest.fromJson(Map<String, dynamic> json) => _$KpiSelfAssessmentRequestFromJson(json);
}
