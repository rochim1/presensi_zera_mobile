import 'package:presensi_domain/src/entities/sales_target/sales_target.dart';

abstract class SalesTargetRepository {
  Future<SalesTargetEntity?> getMySalesTarget({required String periode});
}
