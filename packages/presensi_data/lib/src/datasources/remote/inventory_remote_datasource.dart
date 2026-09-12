import 'package:logger/logger.dart';
import 'package:presensi_data/presensi_data.dart';

abstract class InventoryRemoteDataSource {
  Future<dynamic> getIncidentalReports({int? page, int? limit, String? search});

  Future<dynamic> addIncidentalReport({required Map<String, dynamic> input});

  Future<dynamic> getInventarisUmum({int? page, int? limit, String? search});

  Future<dynamic> getLocationBalances({required String inventoryId});
}

class InventoryRemoteDataSourceImpl implements InventoryRemoteDataSource {
  final GraphQlService graphQLService;
  final Logger logger;

  InventoryRemoteDataSourceImpl({
    required this.graphQLService,
    required this.logger,
  });

  @override
  Future<dynamic> getIncidentalReports({
    int? page,
    int? limit,
    String? search,
  }) async {
    try {
      final Map<String, dynamic> variables = {
        'pagination': {'page': page ?? 1, 'limit': limit ?? 10},
      };

      if (search != null && search.isNotEmpty) {
        variables['filter'] = {'search': search};
      }

      final response = await graphQLService.query(
        query: InventoryGraphQL.getIncidentalReports,
        variables: variables,
      );

      return response;
    } catch (e) {
      logger.e('Error getting incidental reports: $e');
      rethrow;
    }
  }

  @override
  Future<dynamic> addIncidentalReport({
    required Map<String, dynamic> input,
  }) async {
    try {
      final response = await graphQLService.mutation(
        mutation: InventoryGraphQL.addIncidentalReport,
        variables: {'input': input},
      );

      return response;
    } catch (e) {
      logger.e('Error adding incidental report: $e');
      rethrow;
    }
  }

  @override
  Future<dynamic> getInventarisUmum({
    int? page,
    int? limit,
    String? search,
  }) async {
    try {
      final Map<String, dynamic> variables = {
        'pagination': {'page': page ?? 1, 'limit': limit ?? 10},
      };

      if (search != null && search.isNotEmpty) {
        variables['filter'] = {'search': search};
      }

      final response = await graphQLService.query(
        query: InventoryGraphQL.getInventarisUmum,
        variables: variables,
      );

      return response;
    } catch (e) {
      logger.e('Error getting inventaris umum: $e');
      rethrow;
    }
  }

  @override
  Future<dynamic> getLocationBalances({required String inventoryId}) async {
    try {
      return await graphQLService.query(
        query: InventoryGraphQL.getInventoryLocationBalances,
        variables: {
          'inventoryId': inventoryId,
          'pagination': {'page': 1, 'limit': 100},
        },
      );
    } catch (e) {
      logger.e('Error getting inventory location balances: $e');
      rethrow;
    }
  }
}
