import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

abstract class NotificationRepository {
  Future<Either<Failure, int>> getUnreadNotificationsCount();

  Future<Either<Failure, List<AppNotification>>> getNotifications(
    GetNotificationParams params,
  );

  Future<Either<Failure, void>> markAsReadById(String id);

  Future<Either<Failure, void>> deleteById(String id);
}
