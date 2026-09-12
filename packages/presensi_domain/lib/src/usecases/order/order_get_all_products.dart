import 'package:presensi_data/core/_core.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:dartz/dartz.dart';
import 'package:presensi_domain/presensi_domain.dart';

class OrderGetAllProducts
    implements UseCase<List<ProductEntity>, NoParams> {
  final OrderRepository repository;

  OrderGetAllProducts(this.repository);

  @override
  Future<Either<Failure, List<ProductEntity>>> call(NoParams params) async {
    return repository.getAllProducts();
  }
}
