import 'package:equatable/equatable.dart';

class InventarisItem extends Equatable {
  final String id;
  final String? kodeInventaris;
  final String? namaInventaris;
  final String? unit;
  final String? kategoriId;
  final String? kategoriNama;
  final int? totalStok;

  const InventarisItem({
    required this.id,
    this.kodeInventaris,
    this.namaInventaris,
    this.unit,
    this.kategoriId,
    this.kategoriNama,
    this.totalStok,
  });

  @override
  List<Object?> get props => [
    id,
    kodeInventaris,
    namaInventaris,
    unit,
    kategoriId,
    kategoriNama,
    totalStok,
  ];
}
