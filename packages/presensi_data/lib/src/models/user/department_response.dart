import 'package:freezed_annotation/freezed_annotation.dart';

part 'department_response.freezed.dart';

part 'department_response.g.dart';

@freezed
abstract class DepartmentResponse with _$DepartmentResponse {
  const factory DepartmentResponse({
    @JsonKey(name: '_id', defaultValue: '') required String id,
    @JsonKey(name: 'nama_divisi', defaultValue: '') required String name,
  }) = _DepartmentResponse;

  factory DepartmentResponse.fromJson(Map<String, dynamic> json) =>
      _$DepartmentResponseFromJson(json);
}
