import 'package:equatable/equatable.dart';

class CutiEntity extends Equatable {
  final String? id;
  final String? alasan;
  final String? tanggalPengajuan;

  /// please use enum [StatusIzinType] `[value].name`
  final String? statusIzin;
  final String? tanggalAksi;
  final bool? isResponseByAdmin;
  final String? tanggalIzin;
  final String? tanggalMasuk;
  final String? fileIzin;
  final String? status;
  final String? deletedAt;
  final String? tipeCuti;
  final String? filename;

  const CutiEntity({
    this.id,
    this.alasan,
    this.tanggalPengajuan,
    this.statusIzin,
    this.tanggalAksi,
    this.isResponseByAdmin,
    this.tanggalIzin,
    this.tanggalMasuk,
    this.fileIzin,
    this.status,
    this.deletedAt,
    this.tipeCuti,
    this.filename,
  });

  @override
  List<Object?> get props {
    return [
      id,
      alasan,
      tanggalPengajuan,
      statusIzin,
      tanggalAksi,
      isResponseByAdmin,
      tanggalIzin,
      tanggalMasuk,
      fileIzin,
      status,
      deletedAt,
      tipeCuti,
      filename,
    ];
  }
}
