import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:presensi_data/core/mapper/app_mappr.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDatasource remoteDatasource;
  final AppMappr mapper;
  final Logger logger;

  NotificationRepositoryImpl({
    required this.remoteDatasource,
    required this.mapper,
    required this.logger,
  });

  @override
  Future<Either<Failure, int>> getUnreadNotificationsCount() async {
    try {
      final response = await remoteDatasource.getUnreadNotificationsCount();
      return Right(response);
    } on GraphQlException catch (e, stackTrace) {
      if (e is! CacheException) logger.e(
        "NotificationRepositoryImpl.getUnreadNotificationsCount graphQL",
        error: e,
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      if (e is! CacheException) logger.e(
        "NotificationRepositoryImpl.getUnreadNotificationsCount unknown",
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<AppNotification>>> getNotifications(
    GetNotificationParams params,
  ) async {
    try {
      final request = mapper
          .convert<GetNotificationParams, GetNotificationsRequest>(params);
      final pagination = PaginationRequest(
        page: params.page,
        limit: params.limit,
      );

      final response = await remoteDatasource.getNotifications(
        request,
        pagination,
      );
      final notifications = response
          .map((v) => mapper.convert<NotificationResponse, AppNotification>(v))
          .toList();

      return Right(notifications);
    } on GraphQlException catch (e, stackTrace) {
      if (e is! CacheException) logger.e(
        "NotificationRepositoryImpl.getNotifications graphQL",
        error: e,
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      if (e is! CacheException) logger.e(
        "NotificationRepositoryImpl.getNotifications unknown",
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteById(String id) async {
    try {
      await remoteDatasource.deleteById(id);

      return Right(null);
    } on GraphQlException catch (e, stackTrace) {
      if (e is! CacheException) logger.e(
        "NotificationRepositoryImpl.deleteById graphQL",
        error: e,
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      if (e is! CacheException) logger.e(
        "NotificationRepositoryImpl.deleteById unknown",
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> markAsReadById(String id) async {
    try {
      await remoteDatasource.markAsReadById(id);

      return Right(null);
    } on GraphQlException catch (e, stackTrace) {
      if (e is! CacheException) logger.e(
        "NotificationRepositoryImpl.markAsReadById( graphQL",
        error: e,
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      if (e is! CacheException) logger.e(
        "NotificationRepositoryImpl.markAsReadById( unknown",
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure());
    }
  }
}
