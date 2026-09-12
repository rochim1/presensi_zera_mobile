import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class GetMySurveys extends UseCase<List<Survey>, GetMySurveysParams> {
  final SurveyRepository repository;

  GetMySurveys({required this.repository});

  @override
  Future<Either<Failure, List<Survey>>> call(GetMySurveysParams params) {
    return repository.getMySurveys(params);
  }
}
