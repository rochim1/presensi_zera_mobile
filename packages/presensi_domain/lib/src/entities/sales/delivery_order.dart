import 'package:equatable/equatable.dart';

class DeliveryOrderItemEntity extends Equatable {
  final String? namaProduk;
  final double? qty;
  final String? satuan;

  const DeliveryOrderItemEntity({
    this.namaProduk,
    this.qty,
    this.satuan,
  });

  factory DeliveryOrderItemEntity.fromJson(Map<String, dynamic> json) {
    return DeliveryOrderItemEntity(
      namaProduk: json['nama_produk'],
      qty: (json['qty'] as num?)?.toDouble(),
      satuan: json['satuan'],
    );
  }

  @override
  List<Object?> get props => [namaProduk, qty, satuan];
}

class DeliveryOrderEntity extends Equatable {
  final String? id;
  final String? noDo;
  final String? noOrder;
  final String? outletNama;
  final String? alamatKirim;
  final String? driverNama;
  final String? noKendaraan;
  final String? tanggalKirim;
  final String? status;
  final List<DeliveryOrderItemEntity>? items;
  final double? totalItem;
  final bool isSelected;

  const DeliveryOrderEntity({
    this.id,
    this.noDo,
    this.noOrder,
    this.outletNama,
    this.alamatKirim,
    this.driverNama,
    this.noKendaraan,
    this.tanggalKirim,
    this.status,
    this.items,
    this.totalItem,
    this.isSelected = false,
  });

  DeliveryOrderEntity copyWith({bool? isSelected}) {
    return DeliveryOrderEntity(
      id: id,
      noDo: noDo,
      noOrder: noOrder,
      outletNama: outletNama,
      alamatKirim: alamatKirim,
      driverNama: driverNama,
      noKendaraan: noKendaraan,
      tanggalKirim: tanggalKirim,
      status: status,
      items: items,
      totalItem: totalItem,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  factory DeliveryOrderEntity.fromJson(Map<String, dynamic> json) {
    return DeliveryOrderEntity(
      id: json['_id'],
      noDo: json['no_do'],
      noOrder: json['no_order'],
      outletNama: json['outlet_nama'],
      alamatKirim: json['alamat_kirim'],
      driverNama: json['driver_nama'],
      noKendaraan: json['no_kendaraan'],
      tanggalKirim: json['tanggal_kirim'],
      status: json['status'],
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => DeliveryOrderItemEntity.fromJson(e))
          .toList(),
      totalItem: (json['total_item'] as num?)?.toDouble(),
    );
  }

  @override
  List<Object?> get props => [
        id, noDo, noOrder, outletNama, alamatKirim,
        driverNama, noKendaraan, tanggalKirim, status,
        items, totalItem, isSelected,
      ];
}
