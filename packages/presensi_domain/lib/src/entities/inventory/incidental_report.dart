import 'package:equatable/equatable.dart';

class IncidentalReport extends Equatable {
  final String id;
  final String? noIncident;
  final String? inventarisId;
  final String? kodeInventaris;
  final String? namaInventaris;
  final String? unit;
  final String? jenisInsiden;
  final String? lokasiKejadian;
  final String? tindakan;
  final String? tanggalKejadian;
  final int? jumlahRusak;
  final int? jumlahHasilRecycle;
  final int? jumlahHilang;
  final int? stokSebelum;
  final int? stokSesudah;
  final String? movementType;
  final String? keterangan;
  final String? status;
  final String? createdByName;

  const IncidentalReport({
    required this.id,
    this.noIncident,
    this.inventarisId,
    this.kodeInventaris,
    this.namaInventaris,
    this.unit,
    this.jenisInsiden,
    this.lokasiKejadian,
    this.tindakan,
    this.tanggalKejadian,
    this.jumlahRusak,
    this.jumlahHasilRecycle,
    this.jumlahHilang,
    this.stokSebelum,
    this.stokSesudah,
    this.movementType,
    this.keterangan,
    this.status,
    this.createdByName,
  });

  @override
  List<Object?> get props => [
    id,
    noIncident,
    inventarisId,
    kodeInventaris,
    namaInventaris,
    unit,
    jenisInsiden,
    lokasiKejadian,
    tindakan,
    tanggalKejadian,
    jumlahRusak,
    jumlahHasilRecycle,
    jumlahHilang,
    stokSebelum,
    stokSesudah,
    movementType,
    keterangan,
    status,
    createdByName,
  ];
}
