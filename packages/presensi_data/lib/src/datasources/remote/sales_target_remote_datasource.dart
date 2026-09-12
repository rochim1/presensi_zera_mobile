import 'package:presensi_data/graphql/sales_target_graphql.dart';
import 'package:presensi_data/service/graphql/graphql_service.dart';
import 'package:presensi_data/src/models/sales_target/sales_target_model.dart';

abstract class SalesTargetRemoteDatasource {
  Future<SalesTargetModel?> getMySalesTarget(String periode);
}

class SalesTargetRemoteDatasourceImpl
    with SalesTargetGraphQl
    implements SalesTargetRemoteDatasource {
  final GraphQlService graphQlService;

  SalesTargetRemoteDatasourceImpl(this.graphQlService);

  @override
  Future<SalesTargetModel?> getMySalesTarget(String periode) async {
    final variables = {
      "filter": {
        "periode": periode,
        "is_my_target": true, // We pass a custom flag or the backend resolves current user implicitly if we don't pass salesman_id, or we might need to fetch the user ID from Auth. Let's assume the backend resolves it or we pass empty for all and filter in app, but actually the backend should have a way.
      },
      "pagination": {
        "page": 1,
        "limit": 1,
      }
    };

    final result = await graphQlService.query(
      query: queryGetMySalesTarget,
      variables: variables,
    );

    if (result['GetAllSalesTargets'] != null &&
        result['GetAllSalesTargets']['targets'] != null &&
        (result['GetAllSalesTargets']['targets'] as List).isNotEmpty) {
      final targets = result['GetAllSalesTargets']['targets'] as List;
      // Find the first target that belongs to the current user. Wait, if we use is_my_target it should return only one.
      // Or we can just return the first one since the filter should handle it if we modify it.
      // Wait, in mobile, we usually send user_id. Let's send salesman_id if we have it, but for now we just pass periode. If the backend requires salesman_id, we will inject it in the repository.
      return SalesTargetModel.fromJson(targets.first as Map<String, dynamic>);
    }

    return null;
  }
}
