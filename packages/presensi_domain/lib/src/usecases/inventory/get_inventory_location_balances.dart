import 'package:dartz/dartz.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/src/entities/inventory/inventory_location_balance.dart';
import 'package:presensi_domain/src/repositories/inventory_repository.dart';

class GetInventoryLocationBalancesUseCase
    implements UseCase<List<InventoryLocationBalance>, String> {
  final InventoryRepository repository;

  GetInventoryLocationBalancesUseCase(this.repository);

  @override
  Future<Either<Failure, List<InventoryLocationBalance>>> call(
    String inventoryId,
  ) {
    return repository.getLocationBalances(inventoryId: inventoryId);
  }
}
