import 'package:freezed_annotation/freezed_annotation.dart';

part 'kpi_assignment_template_response.freezed.dart';
part 'kpi_assignment_template_response.g.dart';

@freezed
abstract class KpiAssignmentTemplateResponse
    with _$KpiAssignmentTemplateResponse {
  const factory KpiAssignmentTemplateResponse({
    @JsonKey(name: '_id') String? id,
    String? nama_template,
    bool? allow_self_assessment,
    bool? anonymous_peer_review,
  }) = _KpiAssignmentTemplateResponse;

  factory KpiAssignmentTemplateResponse.fromJson(Map<String, dynamic> json) =>
      _$KpiAssignmentTemplateResponseFromJson(json);
}
