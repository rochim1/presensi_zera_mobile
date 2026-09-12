import 'package:equatable/equatable.dart';
import 'package:presensi_domain/presensi_domain.dart';

class CutiParamsEntity extends Equatable {
  final String? id;
  final String? statusIzin;
  final String? tanggalIzin;
  final String? tanggalMasuk;
  final String? tipeCuti;
  final String? alasan;
  final GlobalImageParamsEntity? file;

  const CutiParamsEntity({
    this.id,
    this.statusIzin = 'diajukan',
    this.tanggalIzin,
    this.tanggalMasuk,
    this.tipeCuti,
    this.alasan,
    this.file,
  });

  @override
  List<Object?> get props => [
    id,
    statusIzin,
    tanggalIzin,
    tanggalMasuk,
    tipeCuti,
    alasan,
    file,
  ];

  Map<String, dynamic> toCreate() {
    return <String, dynamic>{
      "input": {
        "status_izin": statusIzin,
        "tipe_cuti": tipeCuti,
        "tanggal_izin": tanggalIzin,
        "tanggal_masuk": tanggalMasuk,
        "alasan": alasan,
      },
      "file": file?.file,
    };
  }

  Map<String, dynamic> toUpdate() {
    return <String, dynamic>{
      "cutiId": id,
      "input": {
        "tipe_cuti": tipeCuti,
        "tanggal_izin": tanggalIzin,
        "tanggal_masuk": tanggalMasuk,
        "alasan": alasan,
      },
      "file": file?.file,
    };
  }

  Map<String, dynamic> toDelete() {
    return <String, dynamic>{"cutiId": id};
  }
}
