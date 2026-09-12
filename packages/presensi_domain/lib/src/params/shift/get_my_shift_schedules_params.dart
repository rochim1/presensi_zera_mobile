import 'package:presensi_domain/presensi_domain.dart';

class GetMyShiftSchedulesParams extends PaginationParams {
  final DateTime? date;

  GetMyShiftSchedulesParams({super.page, super.limit, this.date});
}
