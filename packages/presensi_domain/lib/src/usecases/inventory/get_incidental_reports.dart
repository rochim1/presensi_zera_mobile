import 'package:dartz/dartz.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/src/entities/inventory/incidental_report.dart';
import 'package:presensi_domain/src/repositories/inventory_repository.dart';

class GetIncidentalReportsUseCase
    implements UseCase<List<IncidentalReport>, GetIncidentalReportsParams> {
  final InventoryRepository repository;

  GetIncidentalReportsUseCase(this.repository);

  @override
  Future<Either<Failure, List<IncidentalReport>>> call(
    GetIncidentalReportsParams params,
  ) async {
    return await repository.getIncidentalReports(
      page: params.page,
      limit: params.limit,
      search: params.search,
    );
  }
}

class GetIncidentalReportsParams {
  final int? page;
  final int? limit;
  final String? search;

  GetIncidentalReportsParams({this.page, this.limit, this.search});
}
