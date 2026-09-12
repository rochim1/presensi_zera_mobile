import 'package:presensi_domain/src/params/common/pagination_params.dart';

class GetReimbursementsParams extends PaginationParams {
  final String? userId;
  final DateTime? startDate;
  final DateTime? endDate;

  GetReimbursementsParams({
    super.page,
    super.limit,
    this.startDate,
    this.endDate,
    this.userId,
  });

  GetReimbursementsParams copyWith({
    int? page,
    int? limit,
    String? userId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return GetReimbursementsParams(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      userId: userId ?? this.userId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
