part of 'user_get_data_cubit.dart';

class UserGetDataState extends Equatable {
  final Failure? failure;
  final TypeState status;
  final LoginUserEntity? data;
  final DivisiType? divisiType;

  const UserGetDataState({
    this.failure,
    this.status = TypeState.initial,
    this.data,
    this.divisiType,
  });

  @override
  List<Object?> get props => [failure, status, data, divisiType];

  UserGetDataState copyWith({
    Failure? failure,
    TypeState? status,
    LoginUserEntity? data,
    DivisiType? divisiType,
  }) {
    return UserGetDataState(
      failure: failure ?? this.failure,
      status: status ?? this.status,
      data: data ?? this.data,
      divisiType: divisiType ?? this.divisiType,
    );
  }
}
