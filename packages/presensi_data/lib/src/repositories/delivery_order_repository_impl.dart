import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';
import '../datasources/remote/delivery_order_remote_datasource.dart';

class DeliveryOrderRepositoryImpl implements DeliveryOrderRepository {
  final DeliveryOrderRemoteDatasource datasource;

  DeliveryOrderRepositoryImpl({required this.datasource});

  @override
  Future<Either<Failure, List<DeliveryOrderEntity>>> getAllDeliveryOrders({
    String? outletId,
    String? status,
    String? search,
    String? driverId,
  }) async {
    try {
      final result = await datasource.getAllDeliveryOrders(
        outletId: outletId,
        status: status,
        search: search,
        driverId: driverId,
      );
      return Right(result);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
