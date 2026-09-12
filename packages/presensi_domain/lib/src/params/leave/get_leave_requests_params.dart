import 'package:presensi_domain/src/params/common/pagination_params.dart';

class GetLeaveRequestsParams extends PaginationParams {
  final String? userId;
  final DateTime? startDate;
  final String? statusIzin;
  final bool? detailCuti;

  GetLeaveRequestsParams({
    this.userId,
    this.startDate,
    this.statusIzin,
    this.detailCuti,
    super.page,
    super.limit,
  });
}
