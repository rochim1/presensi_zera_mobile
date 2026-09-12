import 'package:dartz/dartz.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/src/entities/inventory/incidental_report.dart';
import 'package:presensi_domain/src/entities/inventory/inventaris_item.dart';
import 'package:presensi_domain/src/entities/inventory/inventory_location_balance.dart';

abstract class InventoryRepository {
  Future<Either<Failure, List<IncidentalReport>>> getIncidentalReports({
    int? page,
    int? limit,
    String? search,
  });

  Future<Either<Failure, IncidentalReport>> addIncidentalReport({
    required Map<String, dynamic> input,
  });

  Future<Either<Failure, List<InventarisItem>>> getInventarisUmum({
    int? page,
    int? limit,
    String? search,
  });

  Future<Either<Failure, List<InventoryLocationBalance>>> getLocationBalances({
    required String inventoryId,
  });
}
