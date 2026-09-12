part of 'user_get_local_cubit.dart';

class UserGetLocalState extends Equatable {
  final Failure? failure;
  final TypeState status;
  final LoginUserEntity? data;
  final bool isMarketing;

  const UserGetLocalState({
    this.failure,
    this.status = TypeState.initial,
    this.data,
    this.isMarketing = false,
  });

  @override
  List<Object?> get props => [failure, status, data, isMarketing];

  UserGetLocalState copyWith({
    Failure? failure,
    TypeState? status,
    LoginUserEntity? data,
    bool? isMarketing,
  }) {
    return UserGetLocalState(
      failure: failure ?? this.failure,
      status: status ?? this.status,
      data: data ?? this.data,
      isMarketing: isMarketing ?? this.isMarketing,
    );
  }
}
