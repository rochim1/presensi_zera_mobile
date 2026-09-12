part of 'presensi_get_all_data_cubit.dart';

class PresensiGetAllDataState extends Equatable {
  final Failure? failure;
  final TypeState status;
  final List<PresensiEntity>? lstData;
  final PresensiEntity? data;
  final PresensiFilterEntity? filter;
  final bool hasReachedMax;

  const PresensiGetAllDataState({
    this.failure,
    this.status = TypeState.initial,
    this.lstData,
    this.data,
    this.filter,
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [failure, status, lstData, filter, hasReachedMax];

  PresensiGetAllDataState copyWith({
    Failure? failure,
    TypeState? status,
    List<PresensiEntity>? lstData,
    PresensiEntity? data,
    PresensiFilterEntity? filter,
    bool? hasReachedMax,
  }) {
    return PresensiGetAllDataState(
      failure: failure ?? this.failure,
      status: status ?? this.status,
      lstData: lstData ?? this.lstData,
      data: data ?? this.data,
      filter: filter ?? this.filter,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}
