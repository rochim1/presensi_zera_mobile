import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import '../../repositories/kpi_repository.dart';

class AcknowledgeKpiUseCase extends UseCase<void, String> {
  final KpiRepository repository;
  AcknowledgeKpiUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(String params) {
    return repository.acknowledgeKpi(params);
  }
}
