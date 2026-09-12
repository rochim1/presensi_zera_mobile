import 'package:equatable/equatable.dart';
import 'package:presensi_domain/presensi_domain.dart';

class ApotekFilterEntity extends Equatable {
  final GlobalPaginationEntity? pagination;
  final String? namaApotek;
  final String? status;

  const ApotekFilterEntity({this.namaApotek, this.pagination, this.status});

  @override
  List<Object?> get props => [namaApotek, pagination, status];

  ApotekFilterEntity copyWith({
    GlobalPaginationEntity? pagination,
    String? namaApotek,
    String? status,
  }) {
    return ApotekFilterEntity(
      pagination: pagination ?? this.pagination,
      namaApotek: namaApotek ?? this.namaApotek,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> filter = {};
    if (namaApotek != null && namaApotek!.isNotEmpty) {
      filter["nama_outlet"] = namaApotek;
    }
    if (status != null && status!.isNotEmpty) {
      filter["status"] = status;
    }

    return <String, dynamic>{
      'pagination': pagination?.toJson() ?? GlobalPaginationEntity().toJson(),
      'filter': filter,
    };
  }

  @override
  bool get stringify => true;
}
