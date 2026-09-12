import 'package:freezed_annotation/freezed_annotation.dart';

part 'kpi_assignment_user_response.freezed.dart';
part 'kpi_assignment_user_response.g.dart';

@freezed
abstract class KpiAssignmentUserResponse with _$KpiAssignmentUserResponse {
  const factory KpiAssignmentUserResponse({
    @JsonKey(name: '_id') String? id,
    String? name,
    String? username,
    Map<String, dynamic>? foto,
    Map<String, dynamic>? divisi_id,
    Map<String, dynamic>? jabatan_id,
  }) = _KpiAssignmentUserResponse;

  factory KpiAssignmentUserResponse.fromJson(Map<String, dynamic> json) => _$KpiAssignmentUserResponseFromJson(json);
}
