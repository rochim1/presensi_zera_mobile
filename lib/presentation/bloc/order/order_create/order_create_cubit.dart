import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'order_create_state.dart';
part 'order_create_cubit.freezed.dart';

class OrderCreateCubit extends Cubit<OrderCreateState> {
  bool _isSubmittingAction = false;

  final OrderCreateSalesOrder orderCreateSalesOrder;

  OrderCreateCubit(this.orderCreateSalesOrder)
    : super(const OrderCreateState());

  Future<void> submit(SalesOrderParamsEntity params) async {
    if (_isSubmittingAction || isClosed || state.status.isLoaded) {
      return;
    }
    _isSubmittingAction = true;
    try {
      emit(state.copyWith(status: TypeState.loading));
      final result = await orderCreateSalesOrder(params);
      if (isClosed) return;
      result.fold(
        (l) => emit(state.copyWith(status: TypeState.notLoaded, failure: l)),
        (r) => emit(state.copyWith(status: TypeState.loaded)),
      );
    } catch (_) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: TypeState.notLoaded,
            failure: UnknownFailure(
              message: 'Order gagal diproses, silakan coba lagi',
            ),
          ),
        );
      }
    } finally {
      _isSubmittingAction = false;
    }
  }
}
