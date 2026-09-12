import 'package:freezed_annotation/freezed_annotation.dart';

part 'van_stock_response.freezed.dart';
part 'van_stock_response.g.dart';

@freezed
abstract class VanStockProdukResponse with _$VanStockProdukResponse {
  const factory VanStockProdukResponse({
    @JsonKey(name: '_id') String? id,
    String? nama,
    String? code,
  }) = _VanStockProdukResponse;

  factory VanStockProdukResponse.fromJson(Map<String, dynamic> json) =>
      _$VanStockProdukResponseFromJson(json);
}

@freezed
abstract class VanStockResponse with _$VanStockResponse {
  const factory VanStockResponse({
    @JsonKey(name: '_id') String? id,
    String? salesman_id,
    VanStockProdukResponse? sku_id,
    double? qty_loaded,
    double? qty_sold,
    double? qty_returned,
    double? qty_current,
    String? tanggal_load,
    String? catatan,
  }) = _VanStockResponse;

  factory VanStockResponse.fromJson(Map<String, dynamic> json) =>
      _$VanStockResponseFromJson(json);
}

@freezed
abstract class PaginatedVanStockResponse with _$PaginatedVanStockResponse {
  const factory PaginatedVanStockResponse({
    List<VanStockResponse>? data,
    int? total,
    int? page,
    int? limit,
  }) = _PaginatedVanStockResponse;

  factory PaginatedVanStockResponse.fromJson(Map<String, dynamic> json) =>
      _$PaginatedVanStockResponseFromJson(json);
}

@freezed
abstract class VanStockSummaryResponse with _$VanStockSummaryResponse {
  const factory VanStockSummaryResponse({
    int? total_karyawan,
    double? sisa_stok,
    double? total_terjual,
    double? total_retur,
  }) = _VanStockSummaryResponse;

  factory VanStockSummaryResponse.fromJson(Map<String, dynamic> json) =>
      _$VanStockSummaryResponseFromJson(json);
}
