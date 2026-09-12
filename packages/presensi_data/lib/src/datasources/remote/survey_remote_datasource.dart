import 'package:logger/logger.dart';
import 'package:presensi_data/presensi_data.dart';

abstract class SurveyRemoteDatasource {
  Future<List<SurveyResponse>> getMySurveys(PaginationRequest pagination);
}

class SurveyRemoteDatasourceImpl
    with SurveyGraphql
    implements SurveyRemoteDatasource {
  final GraphQlService gql;
  final Logger logger;

  SurveyRemoteDatasourceImpl({required this.gql, required this.logger});

  @override
  Future<List<SurveyResponse>> getMySurveys(
    PaginationRequest pagination,
  ) async {
    logger.d(
      'SurveyRemoteDatasourceImpl.getMySurveys pagination: ${pagination.toJson()}',
    );

    final response = await gql.query(
      query: getMySurveysQuery,
      variables: {'pagination': pagination.toJson()},
    );

    logger.d('SurveyRemoteDatasourceImpl.getMySurveys response: $response');

    final surveys = response['GetMySurveys']['surveys'] as List<dynamic>;

    return surveys
        .map((item) => SurveyResponse.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
