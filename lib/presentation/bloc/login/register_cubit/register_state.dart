part of 'register_cubit.dart';

class RegisterState extends Equatable {
  final TypeState submitStatus;
  final Failure? failure;
  final bool? isRegisterSuccess;
  final bool isCheckingEmail;
  final bool isCheckingUsername;
  final bool? isEmailAvailable;
  final bool? isUsernameAvailable;

  const RegisterState({
    this.submitStatus = TypeState.initial,
    this.failure,
    this.isRegisterSuccess,
    this.isCheckingEmail = false,
    this.isCheckingUsername = false,
    this.isEmailAvailable,
    this.isUsernameAvailable,
  });

  @override
  List<Object?> get props {
    return [
      submitStatus,
      failure,
      isRegisterSuccess,
      isCheckingEmail,
      isCheckingUsername,
      isEmailAvailable,
      isUsernameAvailable,
    ];
  }

  RegisterState copyWith({
    TypeState? submitStatus,
    Object? failure = _sentinel,
    Object? isRegisterSuccess = _sentinel,
    bool? isCheckingEmail,
    bool? isCheckingUsername,
    Object? isEmailAvailable = _sentinel,
    Object? isUsernameAvailable = _sentinel,
  }) {
    return RegisterState(
      submitStatus: submitStatus ?? this.submitStatus,
      failure: failure == _sentinel ? this.failure : failure as Failure?,
      isRegisterSuccess: isRegisterSuccess == _sentinel
          ? this.isRegisterSuccess
          : isRegisterSuccess as bool?,
      isCheckingEmail: isCheckingEmail ?? this.isCheckingEmail,
      isCheckingUsername: isCheckingUsername ?? this.isCheckingUsername,
      isEmailAvailable: isEmailAvailable == _sentinel
          ? this.isEmailAvailable
          : isEmailAvailable as bool?,
      isUsernameAvailable: isUsernameAvailable == _sentinel
          ? this.isUsernameAvailable
          : isUsernameAvailable as bool?,
    );
  }
}

const Object _sentinel = Object();
