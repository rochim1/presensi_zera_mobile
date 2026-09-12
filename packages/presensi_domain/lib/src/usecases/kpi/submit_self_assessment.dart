import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import '../../params/kpi/_kpi.dart';
import '../../repositories/kpi_repository.dart';

class SubmitSelfAssessment extends UseCase<void, SubmitSelfAssessmentParams> {
  final KpiRepository repository;
  SubmitSelfAssessment({required this.repository});

  @override
  Future<Either<Failure, void>> call(SubmitSelfAssessmentParams params) {
    return repository.submitSelfAssessment(params);
  }
}
