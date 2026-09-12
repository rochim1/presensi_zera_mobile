import 'package:freezed_annotation/freezed_annotation.dart';

part 'kpi_category_ref_response.freezed.dart';
part 'kpi_category_ref_response.g.dart';

@freezed
abstract class KpiCategoryRefResponse with _$KpiCategoryRefResponse {
  const factory KpiCategoryRefResponse({
    @JsonKey(name: '_id') String? id,
    String? nama_kategori,
  }) = _KpiCategoryRefResponse;

  factory KpiCategoryRefResponse.fromJson(Map<String, dynamic> json) => _$KpiCategoryRefResponseFromJson(json);
}
