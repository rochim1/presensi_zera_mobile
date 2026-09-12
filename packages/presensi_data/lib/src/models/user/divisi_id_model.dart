import 'package:json_annotation/json_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'divisi_id_model.g.dart';

@HiveType(typeId: 3)
@JsonSerializable(includeIfNull: true, createToJson: false)
class DivisiIdModel extends DivisiIdEntity {
  @HiveField(0)
  @JsonKey(name: 'nama_divisi')
  final String? namaDivisi;
  @HiveField(1)
  @JsonKey(name: 'induk_divisi')
  final String? anakDevisi;
  @HiveField(2)
  @JsonKey(name: 'job_desk')
  final String? jobDesk;

  DivisiIdModel({this.namaDivisi, this.anakDevisi, this.jobDesk})
    : super(namaDivisi: namaDivisi, anakDevisi: anakDevisi, jobDesk: jobDesk);

  factory DivisiIdModel.fromJson(Map<String, dynamic> json) =>
      _$DivisiIdModelFromJson(json);
}
