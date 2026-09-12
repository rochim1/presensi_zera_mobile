part of 'apotek_query_cubit.dart';

class ApotekQueryState extends Equatable {
  final Failure? failure;
  final TypeState status;
  final List<GlobalQueryEntity>? queries;
  final String? message;

  const ApotekQueryState({
    this.failure,
    this.status = TypeState.initial,
    this.queries,
    this.message,
  });

  @override
  List<Object?> get props => [failure, status, queries, message];

  ApotekQueryState copyWith({
    Failure? failure,
    TypeState? status,
    List<GlobalQueryEntity>? queries,
    String? message,
  }) {
    return ApotekQueryState(
      failure: failure ?? this.failure,
      status: status ?? this.status,
      queries: queries ?? this.queries,
      message: message ?? this.message,
    );
  }
}
