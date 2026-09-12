import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

abstract class DeliveryOrderRemoteDatasource {
  Future<List<DeliveryOrderEntity>> getAllDeliveryOrders({
    String? outletId,
    String? status,
    String? search,
    String? driverId,
  });
}

class DeliveryOrderRemoteDatasourceImpl extends DeliveryOrderRemoteDatasource
    with DeliveryOrderGraphQl {
  final GraphQlService graphQlService;

  DeliveryOrderRemoteDatasourceImpl({required this.graphQlService});

  @override
  Future<List<DeliveryOrderEntity>> getAllDeliveryOrders({
    String? outletId,
    String? status,
    String? search,
    String? driverId,
  }) async {
    final Map<String, dynamic> filter = {};
    if (outletId != null) filter['outlet_id'] = outletId;
    if (status != null) filter['status'] = status;
    if (search != null && search.isNotEmpty) filter['search'] = search;
    if (driverId != null) filter['driver_id'] = driverId;

    final data = await graphQlService.query(
      query: getAllDeliveryOrdersQuery,
      variables: {
        'filter': filter,
        'sorting': {'createdAt': 'desc'},
        'pagination': {'limit': 500, 'page': 0},
      },
    );

    final listAsMap = data?['GetAllSalesDeliveryOrders']?['items'] as List<dynamic>? ?? [];
    if (listAsMap.isNotEmpty) {
      return listAsMap.map((e) => DeliveryOrderEntity.fromJson(e)).toList();
    }
    return [];
  }
}
