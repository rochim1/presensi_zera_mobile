import 'package:equatable/equatable.dart';
import 'package:presensi_domain/presensi_domain.dart';

class UserEntity extends Equatable {
  final String id;
  final String? noIdentitas;
  final String? name;
  final String? username;
  final String? gender;
  final String? email;
  // final UserTypeIdEntity? userTypeId;
  final String? identityType;
  final String? address;
  final String? domisili;
  final String? posCode;
  final String? urlFoto;
  final String? dateOfBirth;
  final String? telpNumber;
  // final int? instansiId;
  final int? managerId;
  final String? dateJoin;
  final String? dateResign;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final bool? isAdmin;
  final bool? isCreated;
  final bool? macAddress;
  final List<AdditionalContactEntity>? additionalContact;
  final String? deletedAt;
  final String? deleteReason;
  final bool? isPresensiToday;
  final bool? isCuti;
  final InventarisEntity? inventaris;
  final DivisiIdEntity? divisiId;
  final InstansiEntity? instansiId;
  final LoginRolePermissionsEntity? rolePermissions;

  const UserEntity({
    required this.id,
    this.noIdentitas,
    this.name,
    this.username,
    this.gender,
    this.email,
    // this.userTypeId,
    this.identityType,
    this.address,
    this.domisili,
    this.posCode,
    this.urlFoto,
    this.dateOfBirth,
    this.telpNumber,
    // this.instansiId,
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
  });

  @override
  List<Object?> get props {
    return [
      id,
      noIdentitas,
      name,
      username,
      gender,
      email,
      // userTypeId,
      identityType,
      address,
      domisili,
      posCode,
      urlFoto,
      dateOfBirth,
      telpNumber,
      // instansiId,
      managerId,
      dateJoin,
      dateResign,
      status,
      createdAt,
      updatedAt,
      isAdmin,
      isCreated,
      macAddress,
      additionalContact,
      deletedAt,
      deleteReason,
      isPresensiToday,
      isCuti,
      inventaris,
      divisiId,
      instansiId,
      rolePermissions,
    ];
  }

  bool hasPermission(String module, {String? action}) {
    if (isAdmin == true) return true;
    if (rolePermissions?.isFullAccess == true) return true;
    final perm = rolePermissions?.permissions?.firstWhere(
      (p) => p.module == module,
      orElse: () => const RolePermissionEntity(),
    );
    if (perm?.module == null) return false;
    if (action != null) {
      return perm?.actions?.contains(action) ?? false;
    }
    return true;
  }
}
