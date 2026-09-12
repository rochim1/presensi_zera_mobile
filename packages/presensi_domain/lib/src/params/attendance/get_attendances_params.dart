import 'package:presensi_domain/presensi_domain.dart';

class GetAttendancesParams extends PaginationParams {
  final String? userId;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? typePresensi;
  final String? searchName;

  GetAttendancesParams({
    super.page,
    super.limit,
    this.userId,
    this.startDate,
    this.endDate,
    this.typePresensi,
    this.searchName,
  });

  GetAttendancesParams copyWith({
    int? page,
    int? limit,
    String? userId,
    DateTime? startDate,
    DateTime? endDate,
    String? typePresensi,
    String? searchName,
  }) {
    return GetAttendancesParams(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      userId: userId ?? this.userId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      typePresensi: typePresensi ?? this.typePresensi,
      searchName: searchName ?? this.searchName,
    );
  }
}
