import 'package:equatable/equatable.dart';

class LoginParamsEntity extends Equatable {
  final String username;
  final String password;
  final bool? rememberMe;
  final String? macAddress;
  final String? captchaId;
  final String? captchaAnswer;
  final String? googleIdToken;
  final String? phoneNumber;
  final bool legalConsent;

  const LoginParamsEntity({
    required this.username,
    required this.password,
    this.rememberMe,
    this.macAddress,
    this.captchaId,
    this.captchaAnswer,
    this.googleIdToken,
    this.phoneNumber,
    this.legalConsent = false,
  });

  const LoginParamsEntity.google({
    required String idToken,
    this.phoneNumber,
    this.legalConsent = false,
    this.rememberMe = true,
    this.macAddress,
  }) : googleIdToken = idToken,
       username = '',
       password = '',
       captchaId = null,
       captchaAnswer = null;

  @override
  List<Object?> get props => [
    username,
    password,
    rememberMe,
    macAddress,
    captchaId,
    captchaAnswer,
    googleIdToken,
    phoneNumber,
    legalConsent,
  ];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'input': {
        if (googleIdToken == null) ...{
          'email_or_username': username,
          'password': password,
          if (captchaId != null) 'captcha_id': captchaId,
          if (captchaAnswer != null) 'captcha_answer': captchaAnswer,
        } else ...{
          'provider': 'google',
          'tokenId': googleIdToken,
          'telp_number': phoneNumber?.trim(),
          'legal_consent': legalConsent,
          'primary_product': 'hrms',
          'registration_source': 'mobile_zera',
          'access_via': 'mobile_app',
        },
        'remember_me': rememberMe,
        'mac_address': macAddress,
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
      googleIdToken: googleIdToken,
      phoneNumber: phoneNumber,
      legalConsent: legalConsent,
    );
  }
}
