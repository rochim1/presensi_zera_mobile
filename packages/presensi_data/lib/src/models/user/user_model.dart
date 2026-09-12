import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:presensi_data/presensi_data.dart';

import 'package:presensi_domain/presensi_domain.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
@JsonSerializable(includeIfNull: true, createToJson: false)
class UserModel extends UserEntity {
  @HiveField(0)
  @JsonKey(name: 'no_identitas')
  final String? noIdentitas;
  @HiveField(1)
  @JsonKey(name: 'name')
  final String? name;
  @HiveField(2)
  @JsonKey(name: 'username')
  final String? username;
  @HiveField(3)
  @JsonKey(name: 'gender')
  final String? gender;
  @HiveField(4)
  @JsonKey(name: 'email')
  final String? email;
  @HiveField(5)
  @JsonKey(name: 'identity_type')
  final String? identityType;
  @HiveField(7)
  @JsonKey(name: 'address')
  final String? address;
  @HiveField(8)
  @JsonKey(name: 'domisili')
  final String? domisili;
  @HiveField(9)
  @JsonKey(name: 'pos_code')
  final String? posCode;
  @HiveField(10)
  @JsonKey(name: 'url_foto')
  final String? urlFoto;
  @HiveField(11)
  @JsonKey(name: 'date_of_birth')
  final String? dateOfBirth;
  @HiveField(12)
  @JsonKey(name: 'telp_number')
  final String? telpNumber;
  @HiveField(14)
  @JsonKey(name: 'manager_id')
  final int? managerId;
  @HiveField(16)
  @JsonKey(name: 'date_join')
  final String? dateJoin;
  @HiveField(17)
  @JsonKey(name: 'date_resign')
  final String? dateResign;
  @HiveField(18)
  @JsonKey(name: 'status')
  final String? status;
  @HiveField(19)
  @JsonKey(name: 'createdAt')
  final String? createdAt;
  @HiveField(20)
  @JsonKey(name: 'updatedAt')
  final String? updatedAt;
  @HiveField(21)
  @JsonKey(name: 'is_admin')
  final bool? isAdmin;
  @HiveField(22)
  @JsonKey(name: 'is_created')
  final bool? isCreated;
  @HiveField(23)
  @JsonKey(name: 'mac_address')
  final bool? macAddress;
  @HiveField(24)
  @JsonKey(name: 'additional_contact')
  final List<AdditionalContactModel>? additionalContact;
  @HiveField(25)
  @JsonKey(name: 'deleted_at')
  final String? deletedAt;
  @HiveField(26)
  @JsonKey(name: 'delete_reason')
  final String? deleteReason;
  @HiveField(27)
  @JsonKey(name: '_id')
  final String id;
  @HiveField(28)
  @JsonKey(name: 'id_presensi', fromJson: _isPresensiTodayFromJson)
  final bool? isPresensiToday;
  @HiveField(29)
  @JsonKey(name: 'is_cuti')
  final bool? isCuti;
  @HiveField(30)
  @JsonKey(name: 'inventaris_kendaraan_id')
  final InventarisModel? inventaris;
  @HiveField(31)
  @JsonKey(name: 'divisi_id')
  final DivisiIdModel? divisiId;
  @HiveField(32)
  @JsonKey(name: 'instansi_id')
  final InstansiModel? instansiId;
  @HiveField(33)
  @JsonKey(name: 'role_permissions')
  final LoginRolePermissionsModel? rolePermissions;

  const UserModel({
    required this.id,
    this.noIdentitas,
    this.name,
    this.username,
    this.gender,
    this.email,
    this.identityType,
    this.address,
    this.domisili,
    this.posCode,
    this.urlFoto,
    this.dateOfBirth,
    this.telpNumber,
    this.managerId,
    this.dateJoin,
    this.dateResign,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.isAdmin,
    this.isCreated,
    this.macAddress,
    this.additionalContact,
    this.deletedAt,
    this.deleteReason,
    this.isPresensiToday,
    this.isCuti,
    this.inventaris,
    this.divisiId,
    this.instansiId,
    this.rolePermissions,
  }) : super(
         id: id,
         noIdentitas: noIdentitas,
         name: name,
         username: username,
         gender: gender,
         email: email,
         identityType: identityType,
         address: address,
         domisili: domisili,
         posCode: posCode,
         urlFoto: urlFoto,
         dateOfBirth: dateOfBirth,
         telpNumber: telpNumber,
         managerId: managerId,
         dateJoin: dateJoin,
         dateResign: dateResign,
         status: status,
         createdAt: createdAt,
         updatedAt: updatedAt,
         isAdmin: isAdmin,
         isCreated: isCreated,
         macAddress: macAddress,
         additionalContact: additionalContact,
         deletedAt: deletedAt,
         deleteReason: deleteReason,
         isPresensiToday: isPresensiToday,
         isCuti: isCuti,
         inventaris: inventaris,
         divisiId: divisiId,
         instansiId: instansiId,
         rolePermissions: rolePermissions,
       );

  UserModel copyWith({
    String? noIdentitas,
    String? name,
    String? username,
    String? gender,
    String? email,
    String? identityType,
    String? address,
    String? domisili,
    String? posCode,
    String? urlFoto,
    String? dateOfBirth,
    String? telpNumber,
    int? managerId,
    String? dateJoin,
    String? dateResign,
    String? status,
    String? createdAt,
    String? updatedAt,
    bool? isAdmin,
    bool? isCreated,
    bool? macAddress,
    List<AdditionalContactModel>? additionalContact,
    String? deletedAt,
    String? deleteReason,
    String? id,
    bool? isPresensiToday,
    bool? isCuti,
    InventarisModel? inventaris,
    DivisiIdModel? divisiId,
    InstansiModel? instansiId,
    LoginRolePermissionsModel? rolePermissions,
  }) {
    return UserModel(
      noIdentitas: noIdentitas ?? this.noIdentitas,
      name: name ?? this.name,
      username: username ?? this.username,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      identityType: identityType ?? this.identityType,
      address: address ?? this.address,
      domisili: domisili ?? this.domisili,
      posCode: posCode ?? this.posCode,
      urlFoto: urlFoto ?? this.urlFoto,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      telpNumber: telpNumber ?? this.telpNumber,
      managerId: managerId ?? this.managerId,
      dateJoin: dateJoin ?? this.dateJoin,
      dateResign: dateResign ?? this.dateResign,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isAdmin: isAdmin ?? this.isAdmin,
      isCreated: isCreated ?? this.isCreated,
      macAddress: macAddress ?? this.macAddress,
      additionalContact: additionalContact ?? this.additionalContact,
      deletedAt: deletedAt ?? this.deletedAt,
      deleteReason: deleteReason ?? this.deleteReason,
      id: id ?? this.id,
      isPresensiToday: isPresensiToday ?? this.isPresensiToday,
      isCuti: isCuti ?? this.isCuti,
      inventaris: inventaris ?? this.inventaris,
      divisiId: divisiId ?? this.divisiId,
      instansiId: instansiId ?? this.instansiId,
      rolePermissions: rolePermissions ?? this.rolePermissions,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  static bool? _isPresensiTodayFromJson(dynamic idPresensi) {
    if (idPresensi == null) return false;
    if (idPresensi is Map<String, dynamic>) {
      return idPresensi['_id'] != null;
    }
    return false;
  }
}
