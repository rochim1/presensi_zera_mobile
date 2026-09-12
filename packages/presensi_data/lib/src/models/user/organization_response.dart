import 'package:freezed_annotation/freezed_annotation.dart';

part 'organization_response.freezed.dart';

part 'organization_response.g.dart';

@freezed
abstract class OrganizationResponse with _$OrganizationResponse {
  const factory OrganizationResponse({
    @JsonKey(name: '_id', defaultValue: '') required String id,
    @JsonKey(name: 'nama_instansi', defaultValue: '')
    required String namaInstansi,
    @JsonKey(name: 'nama_resmi', defaultValue: '') required String namaResmi,
  }) = _OrganizationResponse;

  factory OrganizationResponse.fromJson(Map<String, dynamic> json) =>
      _$OrganizationResponseFromJson(json);
}
