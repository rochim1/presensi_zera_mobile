import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import '../../params/kpi/_kpi.dart';
import '../../repositories/kpi_repository.dart';

class SubmitManagerReview extends UseCase<void, SubmitManagerReviewParams> {
  final KpiRepository repository;
  SubmitManagerReview({required this.repository});

  @override
  Future<Either<Failure, void>> call(SubmitManagerReviewParams params) {
    return repository.submitManagerReview(params);
  }
}
