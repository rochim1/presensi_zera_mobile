import 'package:presensi_domain/presensi_domain.dart';

class GetNotificationParams extends PaginationParams {
  final bool isMyNotif;

  GetNotificationParams({super.page, super.limit, this.isMyNotif = true});
}
