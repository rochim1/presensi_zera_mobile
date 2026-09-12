part of 'login_sign_out_cubit.dart';

class LoginSignOutState extends Equatable {
  final Failure? failure;
  final bool? isSuccessed;
  final TypeState status;

  const LoginSignOutState({
    this.failure,
    this.status = TypeState.initial,
    this.isSuccessed = false,
  });

  @override
  List<Object?> get props => [failure, status, isSuccessed];

  LoginSignOutState copyWith({
    Failure? failure,
    bool? isSuccessed,
    TypeState? status,
  }) {
    return LoginSignOutState(
      failure: failure ?? this.failure,
      isSuccessed: isSuccessed ?? this.isSuccessed,
      status: status ?? this.status,
    );
  }
}
