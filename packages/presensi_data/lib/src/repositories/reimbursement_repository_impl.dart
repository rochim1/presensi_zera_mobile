import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:presensi_data/core/mapper/app_mappr.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class ReimbursementRepositoryImpl implements ReimbursementRepository {
  final ReimbursementRemoteDatasource remoteDatasource;
  final AppMappr mapper;
  final Logger logger;

  ReimbursementRepositoryImpl({
    required this.remoteDatasource,
    required this.mapper,
    required this.logger,
  });

  @override
  Future<Either<Failure, List<Reimbursement>>> getReimbursements(
    GetReimbursementsParams params,
  ) async {
    try {
      final request = mapper
          .convert<GetReimbursementsParams, GetReimbursementsRequest>(params);
      final pagination = PaginationRequest(
        page: params.page,
        limit: params.limit,
      );
      logger.d(
        "ReimbursementRepositoryImpl.getReimbursements params: $params pagination: $pagination",
      );

      final response = await remoteDatasource.getReimbursements(
        request,
        pagination,
      );
      final result = response
          .map((v) => mapper.convert<ReimbursementResponse, Reimbursement>(v))
          .toList();

      return Right(result);
    } on GraphQlException catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "ReimbursementRepositoryImpl.getReimbursements graphQL",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "ReimbursementRepositoryImpl.getReimbursements unknown",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, Reimbursement>> getReimbursementById(
    String reimbursementId,
  ) async {
    try {
      logger.d(
        "ReimbursementRepositoryImpl.getReimbursementById id: $reimbursementId",
      );

      final response = await remoteDatasource.getReimbursementById(
        reimbursementId,
      );
      final result = mapper.convert<ReimbursementResponse, Reimbursement>(
        response,
      );

      return Right(result);
    } on GraphQlException catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "ReimbursementRepositoryImpl.getReimbursementById graphQL",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "ReimbursementRepositoryImpl.getReimbursementById unknown",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<ReimbursementCategory>>>
  getReimbursementCategories() async {
    try {
      logger.d("ReimbursementRepositoryImpl.getReimbursementCategories");

      final response = await remoteDatasource.getReimbursementCategories({
        'is_active': true,
      });
      final result = response
          .map(
            (v) => mapper
                .convert<ReimbursementCategoryResponse, ReimbursementCategory>(
                  v,
                ),
          )
          .toList();

      return Right(result);
    } on GraphQlException catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "ReimbursementRepositoryImpl.getReimbursementCategories graphQL",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "ReimbursementRepositoryImpl.getReimbursementCategories unknown",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, Reimbursement>> createReimbursement(
    CreateReimbursementParams params,
  ) async {
    try {
      logger.d(
        "ReimbursementRepositoryImpl.createReimbursement params: $params",
      );

      final request = mapper
          .convert<CreateReimbursementParams, CreateReimbursementRequest>(
            params,
          );
      final response = await remoteDatasource.createReimbursement(
        request,
        params.attachments,
      );
      final result = mapper.convert<ReimbursementResponse, Reimbursement>(
        response,
      );

      return Right(result);
    } on GraphQlException catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "ReimbursementRepositoryImpl.createReimbursement graphQL",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      if (e is! CacheException)
        logger.e(
          "ReimbursementRepositoryImpl.createReimbursement unknown",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, Reimbursement>> updateReimbursement(
    String id,
    CreateReimbursementParams params,
  ) async {
    try {
      final request = mapper
          .convert<CreateReimbursementParams, CreateReimbursementRequest>(
            params,
          );
      final response = await remoteDatasource.updateReimbursement(
        id,
        request,
        params.attachments,
      );
      return Right(
        mapper.convert<ReimbursementResponse, Reimbursement>(response),
      );
    } on GraphQlException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (_) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteReimbursement(String id) async {
    try {
      await remoteDatasource.deleteReimbursement(id);
      return const Right(null);
    } on GraphQlException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (_) {
      return Left(UnknownFailure());
    }
  }
}
