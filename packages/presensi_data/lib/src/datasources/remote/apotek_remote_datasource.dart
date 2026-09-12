import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

abstract class ApotekRemoteDatasource {
  /// get all Apotek
  Future<List<ApotekEntity>> getAllData(ApotekFilterEntity params);

  /// create new apotek
  Future<ApotekEntity> postData(ApotekParamsEntity params);
}

class ApotekRemoteDatasourceImpl extends ApotekRemoteDatasource
    with ApotekGraphQl {
  final GraphQlService graphQlService;

  ApotekRemoteDatasourceImpl(this.graphQlService);

  @override
  Future<List<ApotekEntity>> getAllData(ApotekFilterEntity params) async {
    final data = await graphQlService.query(
      query: getAllApotik,
      variables: params.toJson(),
    );
    final listAsMap = data['GetAllOutlet']['outlet'] as List<dynamic>;

    return listAsMap.map((e) => ApotikModel.fromJson(e)).toList();
  }

  @override
  Future<ApotekEntity> postData(ApotekParamsEntity params) async {
    final data = await graphQlService.mutation(
      mutation: createApotek,
      variables: params.toJson(),
    );

    return ApotikModel.fromJson(data['CreateOutlet'] as Map<String, dynamic>);
  }
}
