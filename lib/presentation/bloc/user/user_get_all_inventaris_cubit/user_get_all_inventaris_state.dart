part of 'user_get_all_inventaris_cubit.dart';

class UserGetAllInventarisState extends Equatable {
  final Failure? failure;
  final TypeState status;
  final List<InventarisEntity>? lstInventaris;

  const UserGetAllInventarisState({
    this.failure,
    this.status = TypeState.initial,
    this.lstInventaris,
  });

  @override
  List<Object?> get props => [failure, status, lstInventaris];

  UserGetAllInventarisState copyWith({
    Failure? failure,
    TypeState? status,
    List<InventarisEntity>? lstInventaris,
  }) {
    return UserGetAllInventarisState(
      failure: failure ?? this.failure,
      status: status ?? this.status,
      lstInventaris: lstInventaris ?? this.lstInventaris,
    );
  }
}
