import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class GetNotifications
    extends UseCase<List<AppNotification>, GetNotificationParams> {
  final NotificationRepository repository;

  GetNotifications({required this.repository});

  @override
  Future<Either<Failure, List<AppNotification>>> call(params) {
    return repository.getNotifications(params);
  }
}
