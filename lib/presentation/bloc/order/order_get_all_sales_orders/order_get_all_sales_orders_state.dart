import 'package:equatable/equatable.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

class OrderGetAllSalesOrdersState extends Equatable {
  final TypeState status;
  final Failure? failure;
  final List<SalesOrderEntity>? salesOrders;

  const OrderGetAllSalesOrdersState({
    required this.status,
    this.failure,
    this.salesOrders,
  });

  factory OrderGetAllSalesOrdersState.initial() {
    return const OrderGetAllSalesOrdersState(
      status: TypeState.initial,
    );
  }

  OrderGetAllSalesOrdersState copyWith({
    TypeState? status,
    Failure? failure,
    List<SalesOrderEntity>? salesOrders,
  }) {
    return OrderGetAllSalesOrdersState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      salesOrders: salesOrders ?? this.salesOrders,
    );
  }

  @override
  List<Object?> get props => [status, failure, salesOrders];
}
