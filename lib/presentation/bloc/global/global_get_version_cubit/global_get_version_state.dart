part of 'global_get_version_cubit.dart';

class GlobalGetVersionState extends Equatable {
  final TypeState status;
  final String? version;
  final Failure? failure;

  const GlobalGetVersionState({
    this.status = TypeState.initial,
    this.version,
    this.failure,
  });

  @override
  List<Object?> get props => [status, version, failure];

  GlobalGetVersionState copyWith({
    TypeState? status,
    String? version,
    Failure? failure,
  }) {
    return GlobalGetVersionState(
      status: status ?? this.status,
      version: version ?? this.version,
      failure: failure ?? this.failure,
    );
  }
}
