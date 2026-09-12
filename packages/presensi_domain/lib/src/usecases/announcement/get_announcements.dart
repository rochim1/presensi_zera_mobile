import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class GetAnnouncements
    extends UseCase<List<Announcement>, GetAnnouncementsParams> {
  final AnnouncementRepository repository;

  GetAnnouncements({required this.repository});

  @override
  Future<Either<Failure, List<Announcement>>> call(params) {
    return repository.getAnnouncements(params);
  }
}
