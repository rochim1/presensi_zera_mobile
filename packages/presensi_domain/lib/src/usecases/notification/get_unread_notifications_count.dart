import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class GetUnreadNotificationsCount extends UseCase<int, NoParams> {
  final NotificationRepository repository;

  GetUnreadNotificationsCount({required this.repository});

  @override
  Future<Either<Failure, int>> call(params) {
    return repository.getUnreadNotificationsCount();
  }
}
