class SalesOrderEntity {
  final String? id;
  final String? noOrder;
  final String? tanggal;
  final String? tipeOrder;
  final String? status;
  final String? statusPembayaran;
  final String? metodePembayaran;
  final double? netSales;
  final String? outletNama;
  final String? salesmanNama;
  final double? totalOrder;
  final double? sisaTagihan;
  // UI-only fields for invoice picker
  final bool isSelected;
  final double paymentAmount;

  SalesOrderEntity({
    this.id,
    this.noOrder,
    this.tanggal,
    this.tipeOrder,
    this.status,
    this.statusPembayaran,
    this.metodePembayaran,
    this.netSales,
    this.outletNama,
    this.salesmanNama,
    this.totalOrder,
    this.sisaTagihan,
    this.isSelected = false,
    this.paymentAmount = 0,
  });

  SalesOrderEntity copyWith({
    bool? isSelected,
    double? paymentAmount,
  }) {
    return SalesOrderEntity(
      id: id,
      noOrder: noOrder,
      tanggal: tanggal,
      tipeOrder: tipeOrder,
      status: status,
      statusPembayaran: statusPembayaran,
      metodePembayaran: metodePembayaran,
      netSales: netSales,
      outletNama: outletNama,
      salesmanNama: salesmanNama,
      totalOrder: totalOrder,
      sisaTagihan: sisaTagihan,
      isSelected: isSelected ?? this.isSelected,
      paymentAmount: paymentAmount ?? this.paymentAmount,
    );
  }

  factory SalesOrderEntity.fromJson(Map<String, dynamic> json) {
    return SalesOrderEntity(
      id: json['_id'],
      noOrder: json['no_order'],
      tanggal: json['tanggal'],
      tipeOrder: json['tipe_order'],
      status: json['status'],
      statusPembayaran: json['status_pembayaran'],
      metodePembayaran: json['metode_pembayaran'],
      netSales: (json['net_sales'] as num?)?.toDouble(),
      outletNama: json['outlet_nama'],
      salesmanNama: json['salesman_nama'],
      totalOrder: (json['total_order'] as num?)?.toDouble(),
      sisaTagihan: (json['sisa_tagihan'] as num?)?.toDouble(),
    );
  }
}
