import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'order_create_state.dart';
part 'order_create_cubit.freezed.dart';

class OrderCreateCubit extends Cubit<OrderCreateState> {
  final OrderCreateSalesOrder orderCreateSalesOrder;

  OrderCreateCubit(this.orderCreateSalesOrder) : super(const OrderCreateState());

  Future<void> submit(SalesOrderParamsEntity params) async {
    emit(state.copyWith(status: TypeState.loading));
    final result = await orderCreateSalesOrder(params);
    result.fold(
      (l) => emit(state.copyWith(status: TypeState.notLoaded, failure: l)),
      (r) => emit(state.copyWith(status: TypeState.loaded)),
    );
  }
}
