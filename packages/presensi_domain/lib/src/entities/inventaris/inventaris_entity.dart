import 'package:equatable/equatable.dart';

class InventarisEntity extends Equatable {
  final String? id;
  final String? jenisKendaraan;
  final String? merk;
  final String? platNomer;
  final String? jadwalServisTerakhir;
  final String? kilometerTerakhir;
  final String? kilometerKembaliServis;
  final String? tanggalPembayaranPajak;
  final String? totalBiayaPajak;
  final bool? isCycleOffice;

  const InventarisEntity({
    this.id,
    this.jenisKendaraan,
    this.merk,
    this.platNomer,
    this.jadwalServisTerakhir,
    this.kilometerTerakhir,
    this.kilometerKembaliServis,
    this.tanggalPembayaranPajak,
    this.totalBiayaPajak,
    this.isCycleOffice,
  });

  @override
  List<Object?> get props {
    return [
      id,
      jenisKendaraan,
      merk,
      platNomer,
      jadwalServisTerakhir,
      kilometerTerakhir,
      kilometerKembaliServis,
      tanggalPembayaranPajak,
      totalBiayaPajak,
      isCycleOffice,
    ];
  }
}
