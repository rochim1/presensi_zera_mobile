import 'package:equatable/equatable.dart';

class RolePermissionEntity extends Equatable {
  final String? module;
  final List<String>? actions;

  const RolePermissionEntity({
    this.module,
    this.actions,
  });

  @override
  List<Object?> get props => [module, actions];
}

class LoginRolePermissionsEntity extends Equatable {
  final bool? isFullAccess;
  final List<RolePermissionEntity>? permissions;

  const LoginRolePermissionsEntity({
    this.isFullAccess,
    this.permissions,
  });

  @override
  List<Object?> get props => [isFullAccess, permissions];
}
