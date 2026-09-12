import 'package:equatable/equatable.dart';

class SalesOrderItemParamsEntity extends Equatable {
  final String? skuId;
  final String? namaProduk;
  final double? qty;
  final String? satuan;
  final double? harga;
  final String? pricingSource;
  final double? subtotal;

  const SalesOrderItemParamsEntity({
    this.skuId,
    this.namaProduk,
    this.qty,
    this.satuan,
    this.harga,
    this.pricingSource,
    this.subtotal,
  });

  Map<String, dynamic> toJson() {
    return {
      "sku_id": skuId,
      "nama_produk": namaProduk,
      "qty": qty,
      "satuan": satuan,
      "harga": harga,
      if (pricingSource != null) "pricing_source": pricingSource,
      if (subtotal != null) "subtotal": subtotal,
    };
  }

  factory SalesOrderItemParamsEntity.fromJson(Map<String, dynamic> json) {
    return SalesOrderItemParamsEntity(
      skuId: json['sku_id'],
      namaProduk: json['nama_produk'],
      qty: (json['qty'] as num?)?.toDouble(),
      satuan: json['satuan'],
      harga: (json['harga'] as num?)?.toDouble(),
      pricingSource: json['pricing_source'],
      subtotal: (json['subtotal'] as num?)?.toDouble(),
    );
  }

  @override
  List<Object?> get props => [skuId, namaProduk, qty, satuan, harga, pricingSource, subtotal];
}

class SalesOrderParamsEntity extends Equatable {
  final String? outletId;
  final String? outletNama;
  final String? salesmanId;
  final String? salesmanNama;
  final String? tipeOrder;
  final String? status;
  final String? tanggal;
  final String? metodePembayaran;
  final double? diskon;
  final String? catatan;
  final String? sumberOrder;
  final List<SalesOrderItemParamsEntity>? items;

  const SalesOrderParamsEntity({
    this.outletId,
    this.outletNama,
    this.salesmanId,
    this.salesmanNama,
    this.tipeOrder,
    this.status,
    this.tanggal,
    this.metodePembayaran,
    this.diskon,
    this.catatan,
    this.sumberOrder,
    this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      "input": {
        "outlet_id": outletId,
        "outlet_nama": outletNama,
        "salesman_id": salesmanId,
        "salesman_nama": salesmanNama,
        "tipe_order": tipeOrder,
        if (status != null) "status": status,
        if (tanggal != null) "tanggal": tanggal,
        if (metodePembayaran != null) "metode_pembayaran": metodePembayaran,
        if (diskon != null) "diskon": diskon,
        if (catatan != null) "catatan": catatan,
        if (sumberOrder != null) "sumber_order": sumberOrder,
        "items": items?.map((e) => e.toJson()).toList() ?? [],
      }
    };
  }

  /// Flat JSON for local queue storage.
  Map<String, dynamic> toQueueJson() {
    return {
      "outlet_id": outletId,
      "outlet_nama": outletNama,
      "salesman_id": salesmanId,
      "salesman_nama": salesmanNama,
      "tipe_order": tipeOrder,
      "status": status,
      "tanggal": tanggal,
      "metode_pembayaran": metodePembayaran,
      "diskon": diskon,
      "catatan": catatan,
      "sumber_order": sumberOrder,
      "items": items?.map((e) => e.toJson()).toList() ?? [],
    };
  }

  /// Reconstruct from flat queue JSON.
  factory SalesOrderParamsEntity.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];
    return SalesOrderParamsEntity(
      outletId: json['outlet_id'],
      outletNama: json['outlet_nama'],
      salesmanId: json['salesman_id'],
      salesmanNama: json['salesman_nama'],
      tipeOrder: json['tipe_order'],
      status: json['status'],
      tanggal: json['tanggal'],
      metodePembayaran: json['metode_pembayaran'],
      diskon: (json['diskon'] as num?)?.toDouble(),
      catatan: json['catatan'],
      sumberOrder: json['sumber_order'],
      items: rawItems.map((e) => SalesOrderItemParamsEntity.fromJson(Map<String, dynamic>.from(e))).toList(),
    );
  }

  @override
  List<Object?> get props => [
        outletId,
        outletNama,
        salesmanId,
        salesmanNama,
        tipeOrder,
        status,
        tanggal,
        metodePembayaran,
        diskon,
        catatan,
        sumberOrder,
        items,
      ];
}
