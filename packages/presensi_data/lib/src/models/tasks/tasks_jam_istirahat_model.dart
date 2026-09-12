import 'package:json_annotation/json_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'tasks_jam_istirahat_model.g.dart';

@JsonSerializable(includeIfNull: true, createToJson: false)
class JamIstirahatModel extends JamIstirahatEntity {
  @JsonKey(name: 'mulai_istirahat')
  final String? mulaiIstirahat;
  @JsonKey(name: 'selesai_istirahat')
  final String? selesaiIstirahat;

  JamIstirahatModel({this.mulaiIstirahat, this.selesaiIstirahat})
    : super(mulaiIstirahat: mulaiIstirahat, selesaiIstirahat: selesaiIstirahat);

  factory JamIstirahatModel.fromJson(Map<String, dynamic> json) =>
      _$JamIstirahatModelFromJson(json);
}
