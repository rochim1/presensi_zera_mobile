import 'package:presensi_data/core/_core.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:dartz/dartz.dart';
import 'package:presensi_domain/presensi_domain.dart';

class OrderCreateSalesOrder
    implements UseCase<bool, SalesOrderParamsEntity> {
  final OrderRepository repository;

  OrderCreateSalesOrder(this.repository);

  @override
  Future<Either<Failure, bool>> call(SalesOrderParamsEntity params) async {
    return repository.createSalesOrder(params);
  }
}
