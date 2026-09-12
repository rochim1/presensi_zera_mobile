import 'package:equatable/equatable.dart';
import 'package:presensi_domain/presensi_domain.dart';

class InventarisFilterEntity extends Equatable {
  final GlobalPaginationEntity? pagination;
  final String? platNomer;
  final String? namaPegawai;

  /// please use enum `JenisKendaraan`
  final String? jenisKendaraan;
  final bool? isCycleOffice;

  const InventarisFilterEntity({
    this.pagination,
    this.platNomer,
    this.namaPegawai,
    this.jenisKendaraan,
    this.isCycleOffice,
  });

  @override
  List<Object?> get props {
    return [pagination, platNomer, namaPegawai, jenisKendaraan, isCycleOffice];
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "pagination": pagination?.toJson() ?? GlobalPaginationEntity().toJson(),
    };
  }
}
