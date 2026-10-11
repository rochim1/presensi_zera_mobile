import 'package:presensi_domain/presensi_domain.dart';

class GetAnnouncementsParams extends PaginationParams {
  final String? statusWaktu;

  GetAnnouncementsParams({super.page, super.limit, this.statusWaktu});
}
