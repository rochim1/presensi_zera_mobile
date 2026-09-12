import 'package:presensi_data/presensi_data.dart';
import '../../models/sales/van_stock/van_stock_response.dart';

abstract class VanStockRemoteDatasource {
  Future<PaginatedVanStockResponse> getVanStockList({
    String? salesmanId,
    int page = 1,
    int limit = 10,
  });

  Future<VanStockSummaryResponse> getVanStockSummary({String? salesmanId});
}

class VanStockRemoteDatasourceImpl implements VanStockRemoteDatasource {
  final GraphQlService gql;

  VanStockRemoteDatasourceImpl({required this.gql});

  @override
  Future<PaginatedVanStockResponse> getVanStockList({
    String? salesmanId,
    int page = 1,
    int limit = 10,
  }) async {
    final filter = <String, dynamic>{};
    if (salesmanId != null && salesmanId.isNotEmpty) {
      filter['salesman_id'] = salesmanId;
    }

    final result = await gql.query(
      query: '''
        query GetAllSalesVanStock(\$filterSalesmanId: ID, \$pagination: pagination) {
          GetAllSalesVanStock(filterSalesmanId: \$filterSalesmanId, pagination: \$pagination) {
            items {
              _id
              salesman_id {
                _id
                name
              }
              sku_id {
                _id
                nama_inventaris
                kode_inventaris
              }
              qty_loaded
              qty_sold
              qty_returned
              qty_current
              tanggal_load
            }
            totalCount
          }
        }
      ''',
      variables: {
        'filterSalesmanId': salesmanId,
        'pagination': {'page': page, 'limit': limit},
      },
    );

    final responseData = result?['GetAllSalesVanStock'];
    if (responseData == null)
      return const PaginatedVanStockResponse(data: [], total: 0);

    // Map GraphQL response to match Freezed model expectations
    final mappedData = {
      'data': (responseData['items'] as List<dynamic>? ?? []).map((item) {
        return {
          '_id': item['_id'],
          'salesman_id': item['salesman_id'] != null
              ? item['salesman_id']['_id']
              : null,
          'sku_id': item['sku_id'] != null
              ? {
                  '_id': item['sku_id']['_id'],
                  'nama': item['sku_id']['nama_inventaris'],
                  'code': item['sku_id']['kode_inventaris'],
                }
              : null,
          'qty_loaded': item['qty_loaded'],
          'qty_sold': item['qty_sold'],
          'qty_returned': item['qty_returned'],
          'qty_current': item['qty_current'],
          'tanggal_load': item['tanggal_load'],
          // 'catatan' field is omitted because it's not in the backend schema
        };
      }).toList(),
      'total': responseData['totalCount'] ?? 0,
      'page': page,
      'limit': limit,
    };

    return PaginatedVanStockResponse.fromJson(mappedData);
  }

  @override
  Future<VanStockSummaryResponse> getVanStockSummary({
    String? salesmanId,
  }) async {
    final result = await getVanStockList(
      salesmanId: salesmanId,
      page: 1,
      limit: 10000,
    );
    final rows = result.data ?? const <VanStockResponse>[];
    final salesmen = rows
        .map((row) => row.salesman_id)
        .whereType<String>()
        .where((id) => id.isNotEmpty)
        .toSet();

    return VanStockSummaryResponse(
      total_karyawan: salesmen.length,
      sisa_stok: rows.fold<double>(
        0,
        (sum, row) => sum + (row.qty_current ?? 0),
      ),
      total_terjual: rows.fold<double>(
        0,
        (sum, row) => sum + (row.qty_sold ?? 0),
      ),
      total_retur: rows.fold<double>(
        0,
        (sum, row) => sum + (row.qty_returned ?? 0),
      ),
    );
  }
}
