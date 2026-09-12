import 'package:json_annotation/json_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'product_model.g.dart';

@JsonSerializable(createToJson: false)
class ProductModel extends ProductEntity {
  @JsonKey(name: '_id')
  final String? id;
  @JsonKey(name: 'kode_inventaris')
  final String? kodeInventaris;
  @JsonKey(name: 'nama_inventaris')
  final String? namaInventaris;
  @JsonKey(name: 'kategori')
  final String? kategori;
  @JsonKey(name: 'stok')
  final double? stok;
  @JsonKey(name: 'unit')
  final String? unit;
  @JsonKey(name: 'harga_jual')
  final double? hargaJual;

  ProductModel({
    this.id,
    this.kodeInventaris,
    this.namaInventaris,
    this.kategori,
    this.stok,
    this.unit,
    this.hargaJual,
  }) : super(
          id: id,
          kodeInventaris: kodeInventaris,
          namaInventaris: namaInventaris,
          kategori: kategori,
          stok: stok,
          unit: unit,
          hargaJual: hargaJual,
        );

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
}
