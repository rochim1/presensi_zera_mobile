import 'package:presensi_domain/presensi_domain.dart';

class User {
  final String id;
  final String name;
  final Department? department;
  final UserAvatar? avatar;
  final Organization? organization;
  final bool? isAdmin;
  final LoginRolePermissionsEntity? rolePermissions;

  const User({
    required this.id,
    required this.name,
    this.department,
    this.avatar,
    this.organization,
    this.isAdmin,
    this.rolePermissions,
  });

  bool hasPermission(String module, {String? action}) {
    if (isAdmin == true) return true;
    if (rolePermissions?.isFullAccess == true) return true;
    // API and Hive can provide List<RolePermissionModel>, a subtype of the
    // entity list. Avoid a firstWhere fallback returning the base entity.
    return rolePermissions?.permissions?.any(
          (permission) =>
              permission.module == module &&
              (action == null || permission.actions?.contains(action) == true),
        ) ??
        false;
  }
}

class UserAvatar {
  final String url;

  const UserAvatar({required this.url});
}
