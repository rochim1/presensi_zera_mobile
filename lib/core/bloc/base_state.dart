import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_data/core/_core.dart';

part 'base_state.freezed.dart';

@Freezed(genericArgumentFactories: true)
class BaseState<T> with _$BaseState<T> {
  const BaseState._();

  const factory BaseState.initial() = _Initial<T>;

  const factory BaseState.loading() = _Loading<T>;

  const factory BaseState.success(T data) = _Success<T>;

  const factory BaseState.failure(Failure failure) = _Failure<T>;

  bool get isInitial => maybeWhen(initial: () => true, orElse: () => false);

  bool get isLoading => maybeWhen(loading: () => true, orElse: () => false);

  bool get isSuccess => maybeWhen(success: (_) => true, orElse: () => false);

  bool get isError => maybeWhen(failure: (_) => true, orElse: () => false);

  Failure? get failure => maybeWhen(failure: (v) => v, orElse: () => null);

  T? get data => maybeWhen(success: (v) => v, orElse: () => null);
}
