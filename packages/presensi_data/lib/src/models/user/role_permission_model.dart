import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'role_permission_model.g.dart';

@HiveType(typeId: 8)
@JsonSerializable()
class RolePermissionModel extends RolePermissionEntity {
  @override
  @HiveField(0)
  @JsonKey(name: 'module')
  final String? module;
  
  @override
  @HiveField(1)
  @JsonKey(name: 'actions')
  final List<String>? actions;

  const RolePermissionModel({
    this.module,
    this.actions,
  }) : super(module: module, actions: actions);

  factory RolePermissionModel.fromJson(Map<String, dynamic> json) =>
      _$RolePermissionModelFromJson(json);

  Map<String, dynamic> toJson() => _$RolePermissionModelToJson(this);
}

@HiveType(typeId: 9)
@JsonSerializable()
class LoginRolePermissionsModel extends LoginRolePermissionsEntity {
  @override
  @HiveField(0)
  @JsonKey(name: 'is_full_access')
  final bool? isFullAccess;

  @override
  @HiveField(1)
  @JsonKey(name: 'permissions')
  final List<RolePermissionModel>? permissions;

  const LoginRolePermissionsModel({
    this.isFullAccess,
    this.permissions,
  }) : super(isFullAccess: isFullAccess, permissions: permissions);

  factory LoginRolePermissionsModel.fromJson(Map<String, dynamic> json) =>
      _$LoginRolePermissionsModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRolePermissionsModelToJson(this);
}
