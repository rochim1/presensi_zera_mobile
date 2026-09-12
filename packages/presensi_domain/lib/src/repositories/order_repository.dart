import 'package:presensi_data/presensi_data.dart';
import 'package:dartz/dartz.dart';
import 'package:presensi_domain/presensi_domain.dart';

abstract class OrderRepository {
  Future<Either<Failure, List<ProductEntity>>> getAllProducts();
  Future<Either<Failure, bool>> createSalesOrder(SalesOrderParamsEntity params);
  Future<Either<Failure, List<SalesOrderEntity>>> getAllSalesOrders({String? statusPembayaran, String? outletId});
  Future<Either<Failure, SalesOrderEntity>> recordSalesPayment({required String orderId, required double jumlahBayar, String? catatan});
}
