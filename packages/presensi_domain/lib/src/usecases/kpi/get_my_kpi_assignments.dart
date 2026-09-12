import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import '../../entities/kpi/_kpi.dart';
import '../../params/kpi/_kpi.dart';
import '../../repositories/kpi_repository.dart';

class GetMyKpiAssignments extends UseCase<List<KpiAssignment>, KpiFilterParams> {
  final KpiRepository repository;
  GetMyKpiAssignments({required this.repository});

  @override
  Future<Either<Failure, List<KpiAssignment>>> call(KpiFilterParams params) {
    return repository.getMyAssignments(params);
  }
}
