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

class UserAvatar {
  final String url;

  const UserAvatar({required this.url});
}
