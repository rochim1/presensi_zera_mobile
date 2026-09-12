import 'package:equatable/equatable.dart';
import 'package:presensi_domain/presensi_domain.dart';

class CutiFilterEntity extends Equatable {
  final GlobalPaginationEntity? pagination;
  final bool? detailCuti;

  /// format date is '2023-11'
  final String? kalender;

  const CutiFilterEntity({
    this.pagination,
    this.detailCuti = true,
    required this.kalender,
  });

  @override
  List<Object?> get props => [pagination, detailCuti, kalender];

  CutiFilterEntity copyWith({
    GlobalPaginationEntity? pagination,
    bool? detailCuti,
    String? kalender,
  }) {
    return CutiFilterEntity(
      pagination: pagination ?? this.pagination,
      detailCuti: detailCuti ?? this.detailCuti,
      kalender: kalender ?? this.kalender,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'pagination': pagination?.toJson() ?? GlobalPaginationEntity().toJson(),
      'filter': {"detail_cuti": detailCuti, "kalender": kalender},
    };
  }
}
