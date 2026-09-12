import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import '../../../entities/sales/van_stock.dart';
import '../../../params/sales/van_stock_filter_params.dart';
import '../../../repositories/van_stock_repository.dart';

class GetVanStockSummary extends UseCase<VanStockSummary, VanStockFilterParams> {
  final VanStockRepository repository;

  GetVanStockSummary(this.repository);

  @override
  Future<Either<Failure, VanStockSummary>> call(VanStockFilterParams params) async {
    return repository.getVanStockSummary(params);
  }
}
