import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

import 'order_get_all_sales_orders_state.dart';

class OrderGetAllSalesOrdersCubit extends Cubit<OrderGetAllSalesOrdersState> {
  final OrderGetAllSalesOrdersUsecase usecase;

  OrderGetAllSalesOrdersCubit({required this.usecase}) : super(OrderGetAllSalesOrdersState.initial());

  Future<void> getAllData({String? statusPembayaran}) async {
    emit(state.copyWith(status: TypeState.loading));

    final result = await usecase(statusPembayaran: statusPembayaran);

    result.fold(
      (failure) {
        emit(state.copyWith(status: TypeState.notLoaded, failure: failure));
      },
      (data) {
        emit(state.copyWith(
          status: TypeState.loaded,
          salesOrders: data,
        ));
      },
    );
  }

  Future<void> getAllSalesOrders({String? statusPembayaran, String? outletId}) async {
    emit(state.copyWith(status: TypeState.loading));

    final result = await usecase(statusPembayaran: statusPembayaran, outletId: outletId);

    result.fold(
      (failure) {
        emit(state.copyWith(status: TypeState.notLoaded, failure: failure));
      },
      (data) {
        emit(state.copyWith(
          status: TypeState.loaded,
          salesOrders: data,
        ));
      },
    );
  }
}
