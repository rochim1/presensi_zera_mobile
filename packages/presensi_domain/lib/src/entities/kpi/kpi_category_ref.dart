import 'package:equatable/equatable.dart';

class KpiCategoryRef extends Equatable {
  final String? id;
  final String? namaKategori;

  const KpiCategoryRef({
    this.id,
    this.namaKategori,
  });

  @override
  List<Object?> get props => [id, namaKategori];
}
