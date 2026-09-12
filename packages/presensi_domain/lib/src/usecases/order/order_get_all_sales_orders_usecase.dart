import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class OrderGetAllSalesOrdersUsecase {
  final OrderRepository repository;

  OrderGetAllSalesOrdersUsecase(this.repository);

  Future<Either<Failure, List<SalesOrderEntity>>> call({String? statusPembayaran, String? outletId}) {
    return repository.getAllSalesOrders(statusPembayaran: statusPembayaran, outletId: outletId);
  }
}
