import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class MarkNotificationAsReadById extends UseCase<void, String> {
  final NotificationRepository repository;

  MarkNotificationAsReadById({required this.repository});

  @override
  Future<Either<Failure, void>> call(params) {
    return repository.markAsReadById(params);
  }
}
