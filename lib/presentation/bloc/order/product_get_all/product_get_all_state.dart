part of 'product_get_all_cubit.dart';

@freezed
abstract class ProductGetAllState with _$ProductGetAllState {
  const factory ProductGetAllState({
    @Default(TypeState.initial) TypeState status,
    @Default([]) List<ProductEntity> data,
    Failure? failure,
  }) = _ProductGetAllState;
}
