import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import '../../entities/kpi/_kpi.dart';
import '../../repositories/kpi_repository.dart';

class GetKpiAssignmentDetail extends UseCase<KpiAssignment, String> {
  final KpiRepository repository;
  GetKpiAssignmentDetail({required this.repository});

  @override
  Future<Either<Failure, KpiAssignment>> call(String params) {
    return repository.getAssignmentDetail(params);
  }
}
