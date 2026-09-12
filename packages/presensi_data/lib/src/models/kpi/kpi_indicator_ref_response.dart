import 'package:freezed_annotation/freezed_annotation.dart';
import 'kpi_category_ref_response.dart';

part 'kpi_indicator_ref_response.freezed.dart';
part 'kpi_indicator_ref_response.g.dart';

@freezed
abstract class KpiIndicatorRefResponse with _$KpiIndicatorRefResponse {
  const factory KpiIndicatorRefResponse({
    @JsonKey(name: '_id') String? id,
    String? nama_indikator,
    String? deskripsi,
    String? tipe_data,
    String? satuan,
    KpiCategoryRefResponse? category_id,
  }) = _KpiIndicatorRefResponse;

  factory KpiIndicatorRefResponse.fromJson(Map<String, dynamic> json) => _$KpiIndicatorRefResponseFromJson(json);
}
