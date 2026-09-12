import 'package:freezed_annotation/freezed_annotation.dart';
import 'kpi_indicator_ref_response.dart';

part 'kpi_score_response.freezed.dart';
part 'kpi_score_response.g.dart';

@freezed
abstract class KpiScoreResponse with _$KpiScoreResponse {
  const factory KpiScoreResponse({
    KpiIndicatorRefResponse? indicator_id,
    double? bobot,
    double? target,
    double? target_minimum,
    double? target_max,
    double? nilai_aktual,
    String? sumber,
    double? self_rating,
    String? catatan_karyawan,
    double? manager_rating,
    String? catatan_reviewer,
    double? nilai_rating,
    double? nilai_terbobot,
    String? auto_data,
  }) = _KpiScoreResponse;

  factory KpiScoreResponse.fromJson(Map<String, dynamic> json) => _$KpiScoreResponseFromJson(json);
}
