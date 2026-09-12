part of 'user_post_image_cubit.dart';

class UserPostImageState extends Equatable {
  final Failure? failure;
  final TypeState typeState;
  final String? message;
  final bool? failed;

  const UserPostImageState({
    this.failure,
    this.typeState = TypeState.initial,
    this.message,
    this.failed = false,
  });

  @override
  List<Object?> get props => [failure, typeState, message, failed];

  UserPostImageState copyWith({
    Failure? failure,
    TypeState? typeState,
    String? message,
    bool? failed,
  }) {
    return UserPostImageState(
      failure: failure ?? this.failure,
      typeState: typeState ?? this.typeState,
      message: message ?? this.message,
      failed: failed ?? this.failed,
    );
  }
}
