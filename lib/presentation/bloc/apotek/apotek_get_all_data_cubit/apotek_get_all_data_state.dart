part of 'apotek_get_all_data_cubit.dart';

class ApotekGetAllDataState extends Equatable {
  final Failure? failure;
  final TypeState status;
  final List<ApotekEntity>? apoteks;
  final ApotekFilterEntity? filter;
  final bool? hasMax;

  const ApotekGetAllDataState({
    this.failure,
    this.status = TypeState.initial,
    this.apoteks,
    this.filter,
    this.hasMax = false,
  });

  @override
  List<Object?> get props => [failure, status, apoteks, filter, hasMax];

  ApotekGetAllDataState copyWith({
    Failure? failure,
    TypeState? status,
    List<ApotekEntity>? apoteks,
    ApotekFilterEntity? filter,
    bool? hasMax,
  }) {
    return ApotekGetAllDataState(
      failure: failure ?? this.failure,
      status: status ?? this.status,
      apoteks: apoteks ?? this.apoteks,
      filter: filter ?? this.filter,
      hasMax: hasMax ?? this.hasMax,
    );
  }

  @override
  bool get stringify => true;
}
