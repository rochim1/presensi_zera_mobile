import 'package:equatable/equatable.dart';

class VanStock extends Equatable {
  final String id;
  final String salesmanId;
  final String skuId;
  final String produkName;
  final String produkKode;
  final double qtyLoaded;
  final double qtySold;
  final double qtyReturned;
  final double qtyCurrent;
  final DateTime? tanggalLoad;
  final String? catatan;

  const VanStock({
    required this.id,
    required this.salesmanId,
    required this.skuId,
    required this.produkName,
    required this.produkKode,
    required this.qtyLoaded,
    required this.qtySold,
    required this.qtyReturned,
    required this.qtyCurrent,
    this.tanggalLoad,
    this.catatan,
  });

  @override
  List<Object?> get props => [
    id,
    salesmanId,
    skuId,
    produkName,
    produkKode,
    qtyLoaded,
    qtySold,
    qtyReturned,
    qtyCurrent,
    tanggalLoad,
    catatan,
  ];
}

class VanStockSummary extends Equatable {
  final int totalKaryawan;
  final double sisaStok;
  final double totalTerjual;
  final double totalRetur;

  const VanStockSummary({
    required this.totalKaryawan,
    required this.sisaStok,
    required this.totalTerjual,
    required this.totalRetur,
  });

  @override
  List<Object?> get props => [
    totalKaryawan,
    sisaStok,
    totalTerjual,
    totalRetur,
  ];
}
