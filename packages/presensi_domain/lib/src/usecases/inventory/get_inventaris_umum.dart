import 'package:dartz/dartz.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/src/entities/inventory/inventaris_item.dart';
import 'package:presensi_domain/src/repositories/inventory_repository.dart';

class GetInventarisUmumUseCase
    implements UseCase<List<InventarisItem>, GetInventarisUmumParams> {
  final InventoryRepository repository;

  GetInventarisUmumUseCase(this.repository);

  @override
  Future<Either<Failure, List<InventarisItem>>> call(
    GetInventarisUmumParams params,
  ) async {
    return await repository.getInventarisUmum(
      page: params.page,
      limit: params.limit,
      search: params.search,
    );
  }
}

class GetInventarisUmumParams {
  final int? page;
  final int? limit;
  final String? search;

  GetInventarisUmumParams({this.page, this.limit, this.search});
}
