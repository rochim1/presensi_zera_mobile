import 'package:json_annotation/json_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'presensi_break_time_model.g.dart';

@JsonSerializable(includeIfNull: true, createToJson: false)
class PresensiBreakTimeModel extends PresensiBreakTimeEntity {
  @JsonKey(name: 'mulai_istirahat')
  final String? mulaiIstirahat;
  @JsonKey(name: 'selesai_istirahat')
  final String? selesaiIstirahat;

  const PresensiBreakTimeModel({this.mulaiIstirahat, this.selesaiIstirahat})
    : super(mulaiIstirahat: mulaiIstirahat, selesaiIstirahat: selesaiIstirahat);

  factory PresensiBreakTimeModel.fromJson(Map<String, dynamic> json) =>
      _$PresensiBreakTimeModelFromJson(json);
}
