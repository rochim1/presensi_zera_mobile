import 'package:freezed_annotation/freezed_annotation.dart';
import 'kpi_assignment_user_response.dart';
import 'kpi_assignment_template_response.dart';
import 'kpi_score_response.dart';

part 'kpi_assignment_response.freezed.dart';
part 'kpi_assignment_response.g.dart';

@freezed
abstract class KpiAssignmentResponse with _$KpiAssignmentResponse {
  const factory KpiAssignmentResponse({
    @JsonKey(name: '_id') String? id,
    KpiAssignmentUserResponse? user_id,
    KpiAssignmentTemplateResponse? template_id,
    String? periode_label,
    String? tanggal_mulai,
    String? tanggal_selesai,
    String? status,
    double? final_score,
    String? final_grade,
    String? catatan_karyawan_global,
    String? catatan_reviewer_global,
    String? self_submitted_at,
    String? manager_reviewed_at,
    String? acknowledged_at,
    List<KpiScoreResponse>? scores,
    String? createdAt,
    String? updatedAt,
  }) = _KpiAssignmentResponse;

  factory KpiAssignmentResponse.fromJson(Map<String, dynamic> json) => _$KpiAssignmentResponseFromJson(json);
}
