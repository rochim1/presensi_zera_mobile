import 'package:presensi_domain/src/params/common/pagination_params.dart';

class KpiFilterParams extends PaginationParams {
  final String? status;
  final String? periodeLabel;

  const KpiFilterParams({
    this.status,
    this.periodeLabel,
    int page = 1,
    int limit = 10,
  }) : super(page: page, limit: limit);

  @override
  List<Object?> get props => [status, periodeLabel, page, limit];
}
