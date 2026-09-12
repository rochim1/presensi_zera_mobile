part of 'order_create_cubit.dart';

@freezed
abstract class OrderCreateState with _$OrderCreateState {
  const factory OrderCreateState({
    @Default(TypeState.initial) TypeState status,
    Failure? failure,
  }) = _OrderCreateState;
}
