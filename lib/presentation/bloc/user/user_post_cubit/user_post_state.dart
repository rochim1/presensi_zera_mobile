part of 'user_post_cubit.dart';

class UserPostState extends Equatable {
  final Failure? failure;
  final TypeState typeState;
  final String? message;

  const UserPostState({
    this.failure,
    this.typeState = TypeState.initial,
    this.message,
  });

  @override
  List<Object?> get props => [failure, typeState, message];

  UserPostState copyWith({
    Failure? failure,
    TypeState? typeState,
    String? message,
  }) {
    return UserPostState(
      failure: failure ?? this.failure,
      typeState: typeState ?? this.typeState,
      message: message ?? this.message,
    );
  }
}
