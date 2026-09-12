import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'product_get_all_state.dart';
part 'product_get_all_cubit.freezed.dart';

class ProductGetAllCubit extends Cubit<ProductGetAllState> {
  final OrderGetAllProducts orderGetAllProducts;

  ProductGetAllCubit(this.orderGetAllProducts)
      : super(const ProductGetAllState());

  Future<void> fetch() async {
    emit(state.copyWith(status: TypeState.loading));
    final result = await orderGetAllProducts(NoParams());
    result.fold(
      (l) => emit(state.copyWith(status: TypeState.notLoaded, failure: l)),
      (r) => emit(state.copyWith(status: TypeState.loaded, data: r)),
    );
  }
}
