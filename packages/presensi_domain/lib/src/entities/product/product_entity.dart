import 'package:equatable/equatable.dart';

class QuantityTierEntity extends Equatable {
  final double? minQty;
  final double? maxQty;
  final double? hargaJual;
  final double? diskonPersen;

  const QuantityTierEntity({
    this.minQty,
    this.maxQty,
    this.hargaJual,
    this.diskonPersen,
  });

  @override
  List<Object?> get props => [minQty, maxQty, hargaJual, diskonPersen];
}

class PriceLevelEntity extends Equatable {
  final String? levelNama;
  final double? hargaJual;

  const PriceLevelEntity({
    this.levelNama,
    this.hargaJual,
  });

  @override
  List<Object?> get props => [levelNama, hargaJual];
}

class UnitConversionEntity extends Equatable {
  final String? unit;
  final double? factor;

  const UnitConversionEntity({
    this.unit,
    this.factor,
  });

  @override
  List<Object?> get props => [unit, factor];
}

class ProductEntity extends Equatable {
  final String? id;
  final String? sku;
  final String? kodeInventaris;
  final String? namaInventaris;
  final String? kategori;
  final double? stok;
  final String? unit;
  final String? baseUnit;
  final double? hargaJual;
  final double? hargaBeli;
  final double? priceFloor;
  final List<QuantityTierEntity>? quantityTiers;
  final List<PriceLevelEntity>? priceLevels;
  final List<UnitConversionEntity>? unitConversions;

  const ProductEntity({
    this.id,
    this.sku,
    this.kodeInventaris,
    this.namaInventaris,
    this.kategori,
    this.stok,
    this.unit,
    this.baseUnit,
    this.hargaJual,
    this.hargaBeli,
    this.priceFloor,
    this.quantityTiers,
    this.priceLevels,
    this.unitConversions,
  });

  @override
  List<Object?> get props => [
        id,
        sku,
        kodeInventaris,
        namaInventaris,
        kategori,
        stok,
        unit,
        baseUnit,
        hargaJual,
        hargaBeli,
        priceFloor,
        quantityTiers,
        priceLevels,
        unitConversions,
      ];
}
