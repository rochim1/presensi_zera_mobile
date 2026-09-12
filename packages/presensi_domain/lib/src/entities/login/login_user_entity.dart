import 'package:equatable/equatable.dart';
import 'package:presensi_domain/presensi_domain.dart';

class LoginUserEntity extends Equatable {
  final String userId;
  final String? token;
  final String? rememberMe;
  final UserEntity? user;
  final String? appId;

  const LoginUserEntity({
    required this.userId,
    this.token,
    this.rememberMe,
    this.user,
    this.appId,
  });

  @override
  List<Object?> get props => [userId, token, user, rememberMe, appId];
}
