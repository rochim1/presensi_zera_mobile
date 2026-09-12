import 'package:equatable/equatable.dart';
import 'kpi_category_ref.dart';

class KpiIndicatorRef extends Equatable {
  final String? id;
  final String? namaIndikator;
  final String? deskripsi;
  final String? tipeData;
  final String? satuan;
  final KpiCategoryRef? category;

  const KpiIndicatorRef({
    this.id,
    this.namaIndikator,
    this.deskripsi,
    this.tipeData,
    this.satuan,
    this.category,
  });

  @override
  List<Object?> get props => [id, namaIndikator, deskripsi, tipeData, satuan, category];
}
