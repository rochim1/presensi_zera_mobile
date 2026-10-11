import 'package:equatable/equatable.dart';

class LoginParamsEntity extends Equatable {
  final String username;
  final String password;
  final bool? rememberMe;
  final String? macAddress;
  final String? captchaId;
  final String? captchaAnswer;

  const LoginParamsEntity({
    required this.username,
    required this.password,
    this.rememberMe,
    this.macAddress,
    this.captchaId,
    this.captchaAnswer,
  });

  @override
  List<Object?> get props => [
    username,
    password,
    rememberMe,
    macAddress,
    captchaId,
    captchaAnswer,
  ];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'input': {
        'email_or_username': username,
        'password': password,
        'remember_me': rememberMe,
        'mac_address': macAddress,
        if (captchaId != null) 'captcha_id': captchaId,
        if (captchaAnswer != null) 'captcha_answer': captchaAnswer,
      },
    };
  }

  LoginParamsEntity copyWith({
    String? username,
    String? password,
    bool? rememberMe,
    String? macAddress,
    String? captchaId,
    String? captchaAnswer,
  }) {
    return LoginParamsEntity(
      username: username ?? this.username,
      password: password ?? this.password,
      rememberMe: rememberMe ?? this.rememberMe,
      macAddress: macAddress ?? this.macAddress,
      captchaId: captchaId ?? this.captchaId,
      captchaAnswer: captchaAnswer ?? this.captchaAnswer,
    );
  }
}
