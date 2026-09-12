import 'package:hive/hive.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'login_user_model.g.dart';

@HiveType(typeId: 0)
class LoginUserModel extends LoginUserEntity {
  @HiveField(0)
  final String userId;
  @HiveField(1)
  final String? token;
  @HiveField(2)
  final String? rememberMe;
  @HiveField(3)
  final UserModel? user;
  @HiveField(4)
  final String? appId;

  LoginUserModel({
    required this.userId,
    this.token,
    this.rememberMe,
    this.user,
    this.appId,
  }) : super(
         userId: userId,
         token: token,
         rememberMe: rememberMe,
         user: user,
         appId: appId,
       );

  LoginUserModel copyWith({
    String? userId,
    String? token,
    String? rememberMe,
    UserModel? user,
    String? appId,
  }) {
    return LoginUserModel(
      userId: userId ?? this.userId,
      token: token ?? this.token,
      rememberMe: rememberMe ?? this.rememberMe,
      user: user ?? this.user,
      appId: appId ?? this.appId,
    );
  }

  factory LoginUserModel.fromJson(
    Map<String, dynamic> map,
    Map<String, dynamic> decode,
  ) {
    return LoginUserModel(
      userId: decode['_id'],
      token: map['token'],
      rememberMe: map['remember_me'],
      user: map['user'] != null ? UserModel.fromJson(map['user']) : null,
      appId: map['app_id'],
    );
  }
}
