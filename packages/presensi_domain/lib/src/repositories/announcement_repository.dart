import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

abstract class AnnouncementRepository {
  Future<Either<Failure, List<Announcement>>> getAnnouncements(
    GetAnnouncementsParams params,
  );
}
