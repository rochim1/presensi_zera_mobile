import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'additional_contact_model.g.dart';

@HiveType(typeId: 4)
@JsonSerializable(includeIfNull: true, createToJson: false)
class AdditionalContactModel extends AdditionalContactEntity {
  @HiveField(0)
  @JsonKey(name: 'name')
  final String? name;
  @HiveField(1)
  @JsonKey(name: 'relation')
  final String? relation;
  @HiveField(2)
  @JsonKey(name: 'telpon_number')
  final String? telponNumber;
  @HiveField(3)
  @JsonKey(name: 'address')
  final String? address;
  @HiveField(4)
  @JsonKey(name: 'email')
  final String? email;

  AdditionalContactModel({
    this.name,
    this.relation,
    this.telponNumber,
    this.address,
    this.email,
  }) : super(
         name: name,
         relation: relation,
         telponNumber: telponNumber,
         address: address,
         email: email,
       );

  factory AdditionalContactModel.fromJson(Map<String, dynamic> json) =>
      _$AdditionalContactModelFromJson(json);
}
