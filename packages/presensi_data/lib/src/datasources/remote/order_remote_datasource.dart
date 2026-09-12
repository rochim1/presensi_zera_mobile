import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

abstract class OrderRemoteDatasource {
  Future<List<ProductEntity>> getAllProducts();
  Future<bool> createSalesOrder(SalesOrderParamsEntity params);
  Future<List<SalesOrderEntity>> getAllSalesOrders({
    String? statusPembayaran,
    String? outletId,
  });
  Future<SalesOrderEntity> recordSalesPayment({
    required String orderId,
    required double jumlahBayar,
    String? catatan,
  });
}

class OrderRemoteDatasourceImpl extends OrderRemoteDatasource
    with OrderGraphQl {
  final GraphQlService graphQlService;

  OrderRemoteDatasourceImpl({required this.graphQlService});

  @override
  Future<List<ProductEntity>> getAllProducts() async {
    final data = await graphQlService.query(
      query: getAllProductsQuery,
      variables: {
        "filter": {"kategori": "barang_dagangan"},
        "sorting": {"createdAt": "desc"},
        "pagination": {"limit": 500, "page": 1},
      },
    );

    final listAsMap = data['GetAllInventarisUmum']['items'] as List<dynamic>;

    if (listAsMap.isNotEmpty) {
      return listAsMap.map((e) {
        final rawQuantityTiers = e['quantity_tiers'] as List<dynamic>? ?? [];
        final rawPriceLevels = e['price_levels'] as List<dynamic>? ?? [];
        final rawUnitConversions =
            e['unit_conversions'] as List<dynamic>? ?? [];

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
          quantityTiers: rawQuantityTiers
              .map(
                (q) => QuantityTierEntity(
                  minQty: (q['min_qty'] as num?)?.toDouble(),
                  maxQty: (q['max_qty'] as num?)?.toDouble(),
                  hargaJual: (q['harga_jual'] as num?)?.toDouble(),
                  diskonPersen: (q['diskon_persen'] as num?)?.toDouble(),
                ),
              )
              .toList(),
          priceLevels: rawPriceLevels
              .map(
                (p) => PriceLevelEntity(
                  levelNama: p['level_nama'],
                  hargaJual: (p['harga_jual'] as num?)?.toDouble(),
                ),
              )
              .toList(),
          unitConversions: rawUnitConversions
              .map(
                (u) => UnitConversionEntity(
                  unit: u['unit'],
                  factor: (u['factor'] as num?)?.toDouble(),
                ),
              )
              .toList(),
        );
      }).toList();
    } else {
      return [];
    }
  }

  @override
  Future<bool> createSalesOrder(SalesOrderParamsEntity params) async {
    final data = await graphQlService.mutation(
      mutation: createSalesOrderMutation,
      variables: params.toJson(),
    );

    if (data != null && data['CreateSalesOrder'] != null) {
      return true;
    }
    return false;
  }

  @override
  Future<List<SalesOrderEntity>> getAllSalesOrders({
    String? statusPembayaran,
    String? outletId,
  }) async {
    final Map<String, dynamic> filter = {};
    if (statusPembayaran != null) {
      filter['status_pembayaran'] = statusPembayaran;
    }
    if (outletId != null) {
      filter['outlet_id'] = outletId;
    }

    final data = await graphQlService.query(
      query: getAllSalesOrdersQuery,
      variables: {
        "filter": filter,
        "sorting": {"createdAt": "desc"},
        "pagination": {"limit": 500, "page": 1},
      },
    );

    final listAsMap =
        data['GetAllSalesOrders']['orders'] as List<dynamic>? ?? [];

    if (listAsMap.isNotEmpty) {
      return listAsMap.map((e) => SalesOrderEntity.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  @override
  Future<SalesOrderEntity> recordSalesPayment({
    required String orderId,
    required double jumlahBayar,
    String? catatan,
  }) async {
    final data = await graphQlService.mutation(
      mutation: recordSalesPaymentMutation,
      variables: {
        'order_id': orderId,
        'jumlah_bayar': jumlahBayar,
        if (catatan != null) 'catatan': catatan,
      },
    );

    if (data != null && data['RecordSalesPayment'] != null) {
      return SalesOrderEntity.fromJson(data['RecordSalesPayment']);
    }
    throw Exception('Gagal mencatat pembayaran');
  }
}
