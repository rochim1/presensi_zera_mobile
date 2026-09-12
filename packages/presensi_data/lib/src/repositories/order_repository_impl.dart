import 'package:dartz/dartz.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;
  final LocalCacheService localCacheService;

  OrderRepositoryImpl({
    required this.remoteDatasource,
    required this.networkInfo,
    required this.localCacheService,
  });

  @override
  Future<Either<Failure, List<ProductEntity>>> getAllProducts() async {
    final isOnline = await networkInfo.isConnected;

    if (isOnline) {
      try {
        final response = await remoteDatasource.getAllProducts();

        // Cache for offline use
        try {
          final jsonList = response.map((p) => {
            '_id': p.id,
            'sku': p.sku,
            'kode_inventaris': p.kodeInventaris,
            'nama_inventaris': p.namaInventaris,
            'kategori': p.kategori,
            'stok': p.stok,
            'unit': p.unit,
            'base_unit': p.baseUnit,
            'harga_jual': p.hargaJual,
            'harga_beli': p.hargaBeli,
            'price_floor': p.priceFloor,
            'quantity_tiers': p.quantityTiers?.map((q) => {
              'min_qty': q.minQty,
              'max_qty': q.maxQty,
              'harga_jual': q.hargaJual,
              'diskon_persen': q.diskonPersen,
            }).toList() ?? [],
            'price_levels': p.priceLevels?.map((pl) => {
              'level_nama': pl.levelNama,
              'harga_jual': pl.hargaJual,
            }).toList() ?? [],
            'unit_conversions': p.unitConversions?.map((uc) => {
              'unit': uc.unit,
              'factor': uc.factor,
            }).toList() ?? [],
          }).toList();
          await localCacheService.cacheProductList(jsonList);
        } catch (_) {}

        return Right(response);
      } on Exception catch (e) {
        return Left(ServerFailure(message: e.toString()));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      // Offline: load from cache
      try {
        final cachedList = await localCacheService.getCachedProductList();
        if (cachedList.isEmpty) {
          return Left(ServerFailure(message: 'Tidak ada koneksi internet dan data produk cache kosong.'));
        }

        final products = cachedList.map((e) {
          final rawQuantityTiers = e['quantity_tiers'] as List<dynamic>? ?? [];
          final rawPriceLevels = e['price_levels'] as List<dynamic>? ?? [];
          final rawUnitConversions = e['unit_conversions'] as List<dynamic>? ?? [];

          return ProductEntity(
            id: e['_id'],
            sku: e['sku'],
            kodeInventaris: e['kode_inventaris'],
            namaInventaris: e['nama_inventaris'],
            kategori: e['kategori'],
            stok: (e['stok'] as num?)?.toDouble(),
            unit: e['unit'] ?? e['base_unit'] ?? 'unit',
            baseUnit: e['base_unit'],
            hargaJual: (e['harga_jual'] as num?)?.toDouble(),
            hargaBeli: (e['harga_beli'] as num?)?.toDouble(),
            priceFloor: (e['price_floor'] as num?)?.toDouble(),
            quantityTiers: rawQuantityTiers.map((q) => QuantityTierEntity(
              minQty: (q['min_qty'] as num?)?.toDouble(),
              maxQty: (q['max_qty'] as num?)?.toDouble(),
              hargaJual: (q['harga_jual'] as num?)?.toDouble(),
              diskonPersen: (q['diskon_persen'] as num?)?.toDouble(),
            )).toList(),
            priceLevels: rawPriceLevels.map((p) => PriceLevelEntity(
              levelNama: p['level_nama'],
              hargaJual: (p['harga_jual'] as num?)?.toDouble(),
            )).toList(),
            unitConversions: rawUnitConversions.map((u) => UnitConversionEntity(
              unit: u['unit'],
              factor: (u['factor'] as num?)?.toDouble(),
            )).toList(),
          );
        }).toList();

        return Right(products);
      } catch (e) {
        return Left(ServerFailure(message: 'Gagal memuat data offline: $e'));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> createSalesOrder(
      SalesOrderParamsEntity params) async {
    final isOnline = await networkInfo.isConnected;

    if (isOnline) {
      try {
        final response = await remoteDatasource.createSalesOrder(params);
        return Right(response);
      } on Exception catch (e) {
        return Left(ServerFailure(message: e.toString()));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      // Offline: queue the order locally
      try {
        await localCacheService.enqueueOrder(params.toQueueJson());
        return const Right(true); // Indicate success (queued)
      } catch (e) {
        return Left(ServerFailure(message: 'Gagal menyimpan order offline: $e'));
      }
    }
  }

  @override
  Future<Either<Failure, List<SalesOrderEntity>>> getAllSalesOrders({String? statusPembayaran, String? outletId}) async {
    try {
      final response = await remoteDatasource.getAllSalesOrders(statusPembayaran: statusPembayaran, outletId: outletId);
      return Right(response);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SalesOrderEntity>> recordSalesPayment({required String orderId, required double jumlahBayar, String? catatan}) async {
    try {
      final response = await remoteDatasource.recordSalesPayment(orderId: orderId, jumlahBayar: jumlahBayar, catatan: catatan);
      return Right(response);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
