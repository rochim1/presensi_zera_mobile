part of 'login_check_cubit.dart';

class LoginCheckState extends Equatable {
  final TypeState status;
  final String? token;
  final String? message;

  const LoginCheckState({
    this.status = TypeState.initial,
    this.message,
    this.token,
  });

  @override
  List<Object?> get props => [status, token, message];

  LoginCheckState copyWith({
    TypeState? status,
    String? token,
    String? message,
  }) {
    return LoginCheckState(
      status: status ?? this.status,
      token: token ?? this.token,
      message: message ?? this.message,
    );
  }
}
