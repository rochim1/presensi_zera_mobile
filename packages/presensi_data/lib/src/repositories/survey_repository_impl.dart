import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:presensi_data/core/mapper/app_mappr.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class SurveyRepositoryImpl implements SurveyRepository {
  final SurveyRemoteDatasource remoteDatasource;
  final AppMappr mapper;
  final Logger logger;

  SurveyRepositoryImpl({
    required this.remoteDatasource,
    required this.mapper,
    required this.logger,
  });

  @override
  Future<Either<Failure, List<Survey>>> getMySurveys(
    GetMySurveysParams params,
  ) async {
    try {
      final pagination = PaginationRequest(
        page: params.page,
        limit: params.limit,
      );
      final response = await remoteDatasource.getMySurveys(pagination);

      final surveys = response
          .map((item) => mapper.convert<SurveyResponse, Survey>(item))
          .toList();

      return Right(surveys);
    } on GraphQlException catch (e, stackTrace) {
      if (e is! CacheException) logger.e(
        'SurveyRepositoryImpl.getMySurveys graphQL',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      if (e is! CacheException) logger.e(
        'SurveyRepositoryImpl.getMySurveys unknown',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure());
    }
  }
}
