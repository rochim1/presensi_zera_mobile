import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

abstract class SurveyRepository {
  Future<Either<Failure, List<Survey>>> getMySurveys(GetMySurveysParams params);
}
