part of 'apotek_post_data_cubit.dart';

class ApotekPostDataState extends Equatable {
  final Failure? failure;
  final TypeState status;
  final ApotekEntity? data;

  const ApotekPostDataState({
    this.failure,
    this.status = TypeState.initial,
    this.data,
  });

  @override
  List<Object?> get props => [failure, status, data];

  ApotekPostDataState copyWith({
    Failure? failure,
    TypeState? status,
    ApotekEntity? data,
  }) {
    return ApotekPostDataState(
      failure: failure ?? this.failure,
      status: status ?? this.status,
      data: data ?? this.data,
    );
  }
}
