part of 'presensi_get_one_cubit.dart';

class PresensiGetOneState extends Equatable {
  final Failure? failure;
  final TypeState status;

  final PresensiEntity data;

  const PresensiGetOneState({
    this.failure,
    this.status = TypeState.initial,
    this.data = const PresensiModel(),
  });

  @override
  List<Object?> get props => [failure, status, data];

  PresensiGetOneState copyWith({
    Failure? failure,
    TypeState? status,
    PresensiEntity? data,
  }) {
    return PresensiGetOneState(
      failure: failure ?? this.failure,
      status: status ?? this.status,
      data: data ?? this.data,
    );
  }
}
