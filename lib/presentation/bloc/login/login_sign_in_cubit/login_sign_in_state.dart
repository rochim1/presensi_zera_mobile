part of 'login_sign_in_cubit.dart';

class LoginSignInState extends Equatable {
  final AuthState status;
  final Failure? failure;
  final LoginUserEntity? userEntity;

  const LoginSignInState({
    this.status = AuthState.initial,
    this.failure = const UnknownFailure(),
    this.userEntity,
  });

  @override
  List<Object?> get props => [status, failure!, userEntity];

  LoginSignInState copyWith({
    AuthState? status,
    Failure? failure,
    LoginUserEntity? userEntity,
  }) {
    return LoginSignInState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      userEntity: userEntity ?? this.userEntity,
    );
  }
}
