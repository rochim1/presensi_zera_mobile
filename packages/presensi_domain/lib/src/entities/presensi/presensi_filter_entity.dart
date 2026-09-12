import 'package:equatable/equatable.dart';
import 'package:presensi_domain/presensi_domain.dart';

class PresensiFilterEntity extends Equatable {
  final GlobalPaginationEntity? pagination;
  final bool? detailPresensi;
  final String? nama;
  final String? statusKerja;
  final String? tanggalPresensi;
  final String? userId;
  final String? startDate;
  final String? endDate;
  final String? typePresensi;

  PresensiFilterEntity({
    this.pagination,
    this.detailPresensi = true,
    this.nama,
    this.statusKerja,
    this.tanggalPresensi,
    this.userId,
    this.startDate,
    this.endDate,
    this.typePresensi,
  });

  @override
  List<Object?> get props {
    return [
      pagination,
      detailPresensi,
      nama,
      statusKerja,
      tanggalPresensi,
      userId,
      startDate,
      endDate,
      typePresensi,
    ];
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'pagination': pagination?.toJson() ?? GlobalPaginationEntity().toJson(),
      'filter': {
        'detail_presensi': detailPresensi,
        'nama': nama,
        'status_kerja': statusKerja,
        'tanggal_presensi': tanggalPresensi,
        'user_id': userId,
        'start_date': startDate,
        'end_date': endDate,
        'type_presensi': typePresensi,
      },
    };
  }

  PresensiFilterEntity copyWith({
    GlobalPaginationEntity? pagination,
    bool? detailPresensi,
    String? nama,
    String? statusKerja,
    String? tanggalPresensi,
    String? userId,
    String? startDate,
    String? endDate,
    String? typePresensi,
  }) {
    return PresensiFilterEntity(
      pagination: pagination ?? this.pagination,
      detailPresensi: detailPresensi ?? this.detailPresensi,
      nama: nama ?? this.nama,
      statusKerja: statusKerja ?? this.statusKerja,
      tanggalPresensi: tanggalPresensi ?? this.tanggalPresensi,
      userId: userId ?? this.userId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      typePresensi: typePresensi ?? this.typePresensi,
    );
  }
}
