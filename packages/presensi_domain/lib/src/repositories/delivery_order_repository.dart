import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

abstract class DeliveryOrderRepository {
  Future<Either<Failure, List<DeliveryOrderEntity>>> getAllDeliveryOrders({
    String? outletId,
    String? status,
    String? search,
    String? driverId,
  });
}
