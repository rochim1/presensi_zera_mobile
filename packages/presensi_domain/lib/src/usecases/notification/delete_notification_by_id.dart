import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class DeleteNotificationById extends UseCase<void, String> {
  final NotificationRepository repository;

  DeleteNotificationById({required this.repository});

  @override
  Future<Either<Failure, void>> call(params) {
    return repository.deleteById(params);
  }
}
