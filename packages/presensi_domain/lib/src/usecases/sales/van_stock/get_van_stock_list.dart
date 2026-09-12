import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import '../../../entities/sales/van_stock.dart';
import '../../../params/sales/van_stock_filter_params.dart';
import '../../../repositories/van_stock_repository.dart';

class GetVanStockList extends UseCase<List<VanStock>, VanStockFilterParams> {
  final VanStockRepository repository;

  GetVanStockList(this.repository);

  @override
  Future<Either<Failure, List<VanStock>>> call(VanStockFilterParams params) async {
    return repository.getVanStockList(params);
  }
}
