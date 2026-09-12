import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import '../entities/sales/van_stock.dart';
import '../params/_params.dart';

abstract class VanStockRepository {
  Future<Either<Failure, List<VanStock>>> getVanStockList(VanStockFilterParams params);
  Future<Either<Failure, VanStockSummary>> getVanStockSummary(VanStockFilterParams params);
}
