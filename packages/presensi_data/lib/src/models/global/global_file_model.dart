import 'package:json_annotation/json_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'global_file_model.g.dart';

@JsonSerializable(createToJson: false)
class GlobalFileModel extends GlobalFileEntity {
  @JsonKey(name: 'base64')
  final String? base64;
  @JsonKey(name: 'filename')
  final String? filename;

  const GlobalFileModel({this.base64, this.filename})
    : super(base64: base64, filename: filename);

  factory GlobalFileModel.fromJson(Map<String, dynamic> json) =>
      _$GlobalFileModelFromJson(json);
}
