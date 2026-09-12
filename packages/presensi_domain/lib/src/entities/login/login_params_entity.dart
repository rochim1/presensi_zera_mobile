import 'package:equatable/equatable.dart';

class LoginParamsEntity extends Equatable {
  final String username;
  final String password;
  final bool? rememberMe;
  final String? macAddress;

  const LoginParamsEntity({
    required this.username,
    required this.password,
    this.rememberMe,
    this.macAddress,
  });

  @override
  List<Object?> get props => [username, password, rememberMe, macAddress];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'input': {
        'email_or_username': username,
        'password': password,
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
  }) {
    return LoginParamsEntity(
      username: username ?? this.username,
      password: password ?? this.password,
      rememberMe: rememberMe ?? this.rememberMe,
      macAddress: macAddress ?? this.macAddress,
    );
  }
}
