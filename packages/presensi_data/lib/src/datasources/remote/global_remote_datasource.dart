import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

abstract class GlobalRemoteDatasource {
  /// check version BE
  Future<String?> getVersion();

  /// post token FCM
  Future<String?> postTokenFcm(GlobalFcmParamsEntity params);
}

class GlobalRemoteDatasourceImpl extends GlobalRemoteDatasource
    with GlobalGraphQl {
  final GraphQlService graphQlService;

  GlobalRemoteDatasourceImpl(this.graphQlService);

  @override
  Future<String?> getVersion() async {
    final data = await graphQlService.query(query: checkVersion);

    return data['CheckVersion']['version'];
  }

  @override
  Future<String?> postTokenFcm(GlobalFcmParamsEntity params) async {
    final data = await graphQlService.mutation(
      mutation: saveDeviceAppsId,
      variables: params.toJson(),
    );

    return data['saveDeviceAppsID']['apps_id'];
  }
}
