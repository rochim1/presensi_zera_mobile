import 'package:presensi_data/src/datasources/remote/sales_target_remote_datasource.dart';
import 'package:presensi_domain/src/entities/sales_target/sales_target.dart';
import 'package:presensi_domain/src/repositories/sales_target_repository.dart';

class SalesTargetRepositoryImpl implements SalesTargetRepository {
  final SalesTargetRemoteDatasource remoteDatasource;

  SalesTargetRepositoryImpl(this.remoteDatasource);

  @override
  Future<SalesTargetEntity?> getMySalesTarget({required String periode}) async {
    return await remoteDatasource.getMySalesTarget(periode);
  }
}
