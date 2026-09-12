import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:presensi_data/core/mapper/app_mappr.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class PayrollRepositoryImpl implements PayrollRepository {
  final PayrollRemoteDatasource remoteDatasource;
  final LoginLocalDatasource loginLocalDatasource;
  final AppMappr mapper;
  final Logger logger;

  PayrollRepositoryImpl({
    required this.remoteDatasource,
    required this.loginLocalDatasource,
    required this.mapper,
    required this.logger,
  });

  @override
  Future<Either<Failure, List<PayrollSlip>>> getPayrollSlips(
    GetPayrollSlipsParams params,
  ) async {
    try {
      final user = await loginLocalDatasource.getLogin();
      final request = mapper
          .convert<GetPayrollSlipsParams, GetPayrollSlipsRequest>(params)
          .copyWith(userId: user.userId);
      final pagination = PaginationRequest(
        page: params.page,
        limit: params.limit,
      );

      final response = await remoteDatasource.getPayrollSlips(
        request,
        pagination,
      );
      final payrollSlips = response
          .map((v) => mapper.convert<PayrollSlipResponse, PayrollSlip>(v))
          .toList();

      return Right(payrollSlips);
    } on GraphQlException catch (e, stackTrace) {
      if (e is! CacheException) logger.e(
        "PayrollRepositoryImpl.getPayrollSlips graphQL",
        error: e,
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      if (e is! CacheException) logger.e(
        "PayrollRepositoryImpl.getPayrollSlips unknown",
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, PayrollSlip>> getPayrollSlipById(String id) async {
    try {
      final response = await remoteDatasource.getPayrollSlipById(id);
      final payrollSlip = mapper.convert<PayrollSlipResponse, PayrollSlip>(
        response,
      );

      return Right(payrollSlip);
    } on GraphQlException catch (e, stackTrace) {
      if (e is! CacheException) logger.e(
        "PayrollRepositoryImpl.getPayrollSlipById graphQL",
        error: e,
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      if (e is! CacheException) logger.e(
        "PayrollRepositoryImpl.getPayrollSlipById unknown",
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, PayrollSlipPdf>> downloadPayrollSlipPdf(
    String id,
  ) async {
    try {
      final user = await loginLocalDatasource.getLogin();
      final token = user.token;
      if (token == null || token.isEmpty) {
        return Left(AuthFailure(message: EXCEPTION_UNAUTHORIZED));
      }

      final response = await remoteDatasource.downloadPayrollSlipPdf(
        id: id,
        token: token,
      );

      return Right(
        PayrollSlipPdf(bytes: response.bytes, fileName: response.fileName),
      );
    } on RestException catch (e, stackTrace) {
      final message = (e.message ?? '').trim();
      logger.e(
        "PayrollRepositoryImpl.downloadPayrollSlipPdf rest",
        error: message.isEmpty ? e.toString() : message,
        stackTrace: stackTrace,
      );
      return Left(
        ServerFailure(message: message.isEmpty ? EXCEPTION_UNKNOWN : message),
      );
    } catch (e, stackTrace) {
      if (e is! CacheException) logger.e(
        "PayrollRepositoryImpl.downloadPayrollSlipPdf unknown",
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure());
    }
  }
}
