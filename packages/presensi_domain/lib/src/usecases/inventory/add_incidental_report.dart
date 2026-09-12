import 'package:dartz/dartz.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/src/entities/inventory/incidental_report.dart';
import 'package:presensi_domain/src/repositories/inventory_repository.dart';

class AddIncidentalReportUseCase
    implements UseCase<IncidentalReport, AddIncidentalReportParams> {
  final InventoryRepository repository;

  AddIncidentalReportUseCase(this.repository);

  @override
  Future<Either<Failure, IncidentalReport>> call(
    AddIncidentalReportParams params,
  ) async {
    return await repository.addIncidentalReport(input: params.input);
  }
}

class AddIncidentalReportParams {
  final Map<String, dynamic> input;

  AddIncidentalReportParams({required this.input});
}
