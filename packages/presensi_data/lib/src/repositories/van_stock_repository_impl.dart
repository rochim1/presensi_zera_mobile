import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:presensi_domain/presensi_domain.dart';
import '../../core/_core.dart';
import '../datasources/remote/van_stock_remote_datasource.dart';

class VanStockRepositoryImpl implements VanStockRepository {
  final VanStockRemoteDatasource datasource;
  final Logger logger;

  VanStockRepositoryImpl({required this.datasource, required this.logger});

  @override
  Future<Either<Failure, List<VanStock>>> getVanStockList(
    VanStockFilterParams params,
  ) async {
    try {
      final response = await datasource.getVanStockList(
        salesmanId: params.salesmanId,
        page: params.page,
        limit: params.limit,
      );

      final dataList = response.data ?? [];
      final result = dataList
          .map(
            (e) => VanStock(
              id: e.id ?? '',
              salesmanId: e.salesman_id ?? '',
              skuId: e.sku_id?.id ?? '',
              produkName: e.sku_id?.nama ?? '',
              produkKode: e.sku_id?.code ?? '',
              qtyLoaded: e.qty_loaded ?? 0,
              qtySold: e.qty_sold ?? 0,
              qtyReturned: e.qty_returned ?? 0,
              qtyCurrent: e.qty_current ?? 0,
              tanggalLoad: e.tanggal_load != null
                  ? DateTime.tryParse(e.tanggal_load!)
                  : null,
              catatan: e.catatan,
            ),
          )
          .toList();

      return Right(result);
    } on GraphQlException catch (e) {
      logger.e('VanStockRepositoryImpl.getVanStockList: $e');
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      logger.e('VanStockRepositoryImpl.getVanStockList: $e');
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, VanStockSummary>> getVanStockSummary(
    VanStockFilterParams params,
  ) async {
    try {
      final response = await datasource.getVanStockSummary(
        salesmanId: params.salesmanId,
      );

      final result = VanStockSummary(
        totalKaryawan: response.total_karyawan ?? 0,
        sisaStok: response.sisa_stok ?? 0,
        totalTerjual: response.total_terjual ?? 0,
        totalRetur: response.total_retur ?? 0,
      );

      return Right(result);
    } on GraphQlException catch (e) {
      logger.e('VanStockRepositoryImpl.getVanStockSummary: $e');
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      logger.e('VanStockRepositoryImpl.getVanStockSummary: $e');
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
