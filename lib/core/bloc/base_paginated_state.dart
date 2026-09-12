import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_data/core/_core.dart';

part 'base_paginated_state.freezed.dart';

@Freezed(genericArgumentFactories: true)
class BasePaginatedState<T> with _$BasePaginatedState<T> {
  const BasePaginatedState._();

  const factory BasePaginatedState.initial() = _Initial<T>;

  const factory BasePaginatedState.loading({
    @Default([]) List<T> data,
    @Default(1) int page,
    @Default(false) bool hasReachedMax,
  }) = _Loading<T>;

  const factory BasePaginatedState.success({
    required List<T> data,
    @Default(1) int page,
    @Default(false) bool hasReachedMax,
  }) = _Success<T>;

  const factory BasePaginatedState.loadingNext({
    required List<T> data,
    required int page,
    required bool hasReachedMax,
  }) = _LoadingNext<T>;

  const factory BasePaginatedState.failure(Failure failure) = _Failure<T>;

  bool get isLoading =>
      maybeWhen(loading: (_, _, _) => true, orElse: () => false);

  bool get isLoadingNext =>
      maybeWhen(loadingNext: (_, _, _) => true, orElse: () => false);

  bool get isInitial => maybeWhen(initial: () => true, orElse: () => false);

  bool get isSuccess =>
      maybeWhen(success: (_, _, _) => true, orElse: () => false);

  List<T> get data => maybeWhen(
    success: (d, _, _) => d,
    loadingNext: (d, _, _) => d,
    loading: (d, _, _) => d,
    orElse: () => [],
  );

  int get currentPage => maybeWhen(
    success: (_, p, _) => p,
    loadingNext: (_, p, _) => p,
    loading: (_, p, _) => p,
    orElse: () => 1,
  );

  bool get hasReachedMax => maybeWhen(
    success: (_, _, h) => h,
    loadingNext: (_, _, h) => h,
    loading: (_, _, h) => h,
    orElse: () => false,
  );

  bool get isError => maybeWhen(failure: (_) => true, orElse: () => false);

  Failure? get failure => maybeWhen(failure: (f) => f, orElse: () => null);
}
