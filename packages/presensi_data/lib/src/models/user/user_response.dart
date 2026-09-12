import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_data/presensi_data.dart';

part 'user_response.freezed.dart';

part 'user_response.g.dart';

@freezed
abstract class UserResponse with _$UserResponse {
  const factory UserResponse({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'name', defaultValue: '') required String name,
    @JsonKey(name: 'is_admin') bool? isAdmin,
    @JsonKey(name: 'divisi_id') DepartmentResponse? department,
    @JsonKey(name: 'foto') UserAvatarResponse? avatar,
    @JsonKey(name: 'instansi_id') OrganizationResponse? organization,
    @JsonKey(name: 'role_permissions')
    LoginRolePermissionsModel? rolePermissions,
  }) = _UserResponse;

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);
}

@freezed
abstract class UserAvatarResponse with _$UserAvatarResponse {
  const factory UserAvatarResponse({
    @JsonKey(name: 'url_path', defaultValue: '') required String url,
  }) = _UserAvatarResponse;

  factory UserAvatarResponse.fromJson(Map<String, dynamic> json) =>
      _$UserAvatarResponseFromJson(json);
}
