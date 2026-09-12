import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import '../../entities/kpi/_kpi.dart';
import '../../params/kpi/_kpi.dart';
import '../../repositories/kpi_repository.dart';

class GetTeamKpiSummary extends UseCase<KpiTeamSummary, KpiFilterParams> {
  final KpiRepository repository;
  GetTeamKpiSummary({required this.repository});

  @override
  Future<Either<Failure, KpiTeamSummary>> call(KpiFilterParams params) {
    return repository.getTeamSummary(params);
  }
}
