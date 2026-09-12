import 'package:json_annotation/json_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'global_post_response_model.g.dart';

@JsonSerializable(includeIfNull: true, createToJson: false)
class GlobalPostResponseModel extends GlobalPostResponseEntity {
  @JsonKey(name: 'message')
  final String? message;
  @JsonKey(name: 'is_successed')
  final bool? isSuccessed;

  GlobalPostResponseModel({this.message, this.isSuccessed})
    : super(message: message, isSuccessed: isSuccessed);

  factory GlobalPostResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GlobalPostResponseModelFromJson(json);
}
