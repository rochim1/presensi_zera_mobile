import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_domain/presensi_domain.dart';

abstract class DeliveryOrderGetAllState {}

class DeliveryOrderGetAllInitial extends DeliveryOrderGetAllState {}

class DeliveryOrderGetAllLoading extends DeliveryOrderGetAllState {}

class DeliveryOrderGetAllLoaded extends DeliveryOrderGetAllState {
  final List<DeliveryOrderEntity> deliveryOrders;
  DeliveryOrderGetAllLoaded(this.deliveryOrders);
}

class DeliveryOrderGetAllError extends DeliveryOrderGetAllState {
  final String message;
  DeliveryOrderGetAllError(this.message);
}

class DeliveryOrderGetAllCubit extends Cubit<DeliveryOrderGetAllState> {
  final GetAllDeliveryOrders getAllDeliveryOrders;

  DeliveryOrderGetAllCubit({required this.getAllDeliveryOrders}) : super(DeliveryOrderGetAllInitial());

  Future<void> loadDeliveryOrders({String? outletId, String? status, String? driverId}) async {
    emit(DeliveryOrderGetAllLoading());
    final result = await getAllDeliveryOrders(
      outletId: outletId,
      status: status,
      driverId: driverId,
    );
    result.fold(
      (failure) => emit(DeliveryOrderGetAllError(failure.message)),
      (orders) => emit(DeliveryOrderGetAllLoaded(orders)),
    );
  }
}
