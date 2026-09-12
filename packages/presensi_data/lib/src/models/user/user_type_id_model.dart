import 'package:json_annotation/json_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'user_type_id_model.g.dart';

@HiveType(typeId: 2)
@JsonSerializable(includeIfNull: true, createToJson: false)
@Deprecated(
  'Please dont use this model, the relation has been moved to user model',
)
class UserTypeIdModel extends UserTypeIdEntity {
  @HiveField(0)
  @JsonKey(name: 'divisi_id')
  final DivisiIdModel? divisiId;
  @HiveField(1)
  @JsonKey(name: 'jabatan')
  final String? jabatan;
  @HiveField(2)
  @JsonKey(name: 'keterangan')
  final String? keterangan;
  @HiveField(3)
  @JsonKey(name: 'instansi_id')
  final InstansiModel? instansiId;
  @HiveField(4)
  @JsonKey(name: 'level')
  final String? level;
  @HiveField(5)
  @JsonKey(name: 'status')
  final String? status;
  @HiveField(6)
  @JsonKey(name: 'createdAt')
  final String? createdAt;
  @HiveField(7)
  @JsonKey(name: 'updatedAt')
  final String? updatedAt;

  const UserTypeIdModel({
    this.divisiId,
    this.jabatan,
    this.keterangan,
    this.instansiId,
    this.level,
    this.status,
    this.createdAt,
    this.updatedAt,
  }) : super(
         divisiId: divisiId,
         jabatan: jabatan,
         keterangan: keterangan,
         instansiId: instansiId,
         level: level,
         status: status,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  factory UserTypeIdModel.fromJson(Map<String, dynamic> json) =>
      _$UserTypeIdModelFromJson(json);
}
