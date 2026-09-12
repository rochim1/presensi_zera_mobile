part of 'global_in_app_upgrade_cubit.dart';

class GlobalInAppUpgradeState extends Equatable {
  final TypeState status;
  final String? message;
  final AppUpdateInfo? info;
  final AppUpdateResult? result;
  final Failure? failure;

  const GlobalInAppUpgradeState({
    this.status = TypeState.initial,
    this.info,
    this.message,
    this.result,
    this.failure,
  });

  @override
  List<Object?> get props => [status, message, info, result, failure];

  GlobalInAppUpgradeState copyWith({
    TypeState? status,
    AppUpdateInfo? info,
    String? message,
    AppUpdateResult? result,
    Failure? failure,
  }) {
    return GlobalInAppUpgradeState(
      status: status ?? this.status,
      info: info ?? this.info,
      message: message ?? this.message,
      result: result ?? this.result,
      failure: failure ?? this.failure,
    );
  }
}
