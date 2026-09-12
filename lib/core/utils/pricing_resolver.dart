import 'package:presensi_domain/presensi_domain.dart';

class PriceResolution {
  final double pricePerUnit;
  final String appliedRule;
  final bool isGrosir;

  const PriceResolution({
    required this.pricePerUnit,
    required this.appliedRule,
    this.isGrosir = false,
  });
}

class PricingResolver {
  static PriceResolution resolvePrice(
    ProductEntity product, {
    required double qty,
    String? segment,
    String? unit,
  }) {
    double activePrice = product.hargaJual ?? 0.0;
    String appliedRule = 'reguler';
    bool isGrosir = false;

    // 1. Check Customer Segment/Price Levels
    if (segment != null && product.priceLevels != null) {
      final level = product.priceLevels!.where((l) => l.levelNama == segment).firstOrNull;
      if (level != null && level.hargaJual != null) {
        activePrice = level.hargaJual!;
        appliedRule = 'segment';
      }
    }

    // 2. Check Quantity Tiers
    if (product.quantityTiers != null && product.quantityTiers!.isNotEmpty) {
      // Find valid tiers
      final validTiers = product.quantityTiers!.where((t) {
        final min = t.minQty ?? 0;
        final max = t.maxQty ?? double.infinity;
        return qty >= min && qty <= max;
      }).toList();

      if (validTiers.isNotEmpty) {
        // Sort descending by min_qty to pick the highest tier matching the criteria
        validTiers.sort((a, b) => (b.minQty ?? 0).compareTo(a.minQty ?? 0));
        final tier = validTiers.first;

        if (tier.hargaJual != null) {
          final candidatePrice = tier.hargaJual!;
          // Only apply if it's cheaper
          if (candidatePrice < activePrice) {
            activePrice = candidatePrice;
            appliedRule = 'tier';
            isGrosir = true;
          }
        } else if (tier.diskonPersen != null) {
          final candidatePrice = activePrice * (1 - (tier.diskonPersen! / 100.0));
          if (candidatePrice < activePrice) {
            activePrice = candidatePrice;
            appliedRule = 'tier';
            isGrosir = true;
          }
        }
      }
    }

    // 3. Apply Unit Conversion Factor
    double pricePerUnit = activePrice;
    if (unit != null && unit != product.baseUnit && product.unitConversions != null) {
      final conversion = product.unitConversions!.where((u) => u.unit == unit).firstOrNull;
      if (conversion != null && conversion.factor != null) {
        pricePerUnit = activePrice * conversion.factor!;
      }
    }

    // 4. Check Price Floor
    if (product.priceFloor != null && pricePerUnit < product.priceFloor!) {
      pricePerUnit = product.priceFloor!;
    }

    return PriceResolution(
      pricePerUnit: pricePerUnit,
      appliedRule: appliedRule,
      isGrosir: isGrosir,
    );
  }
}
