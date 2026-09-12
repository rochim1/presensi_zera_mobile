import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class GetAllDeliveryOrders {
  final DeliveryOrderRepository repository;
  GetAllDeliveryOrders(this.repository);

  Future<Either<Failure, List<DeliveryOrderEntity>>> call({
    String? outletId,
    String? status,
    String? search,
    String? driverId,
  }) {
    return repository.getAllDeliveryOrders(
      outletId: outletId,
      status: status,
      search: search,
      driverId: driverId,
    );
  }
}
