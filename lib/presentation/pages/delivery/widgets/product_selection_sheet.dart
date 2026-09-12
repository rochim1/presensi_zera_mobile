import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';
import 'package:presensi_mobile/presentation/widgets/global/text_field_custom/text_formatter.dart';

class ProductSelectionSheet extends StatefulWidget {
  final List<SalesOrderItemParamsEntity> initialItems;
  final String? priceLevel;
  final bool allowManualPrice;

  const ProductSelectionSheet({
    super.key,
    required this.initialItems,
    this.priceLevel,
    this.allowManualPrice = true,
  });

  @override
  State<ProductSelectionSheet> createState() => _ProductSelectionSheetState();
}

class _ProductSelectionSheetState extends State<ProductSelectionSheet> {
  List<SalesOrderItemParamsEntity> currentItems = [];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    currentItems = List.from(widget.initialItems);
  }

  void updateQty(ProductEntity product, double newQty) {
    setState(() {
      final index = currentItems.indexWhere((e) => e.skuId == product.id);
      if (newQty <= 0) {
        if (index >= 0) currentItems.removeAt(index);
      } else {
        // Resolve pricing using PricingResolver
        final resolved = PricingResolver.resolvePrice(
          product,
          qty: newQty,
          segment: widget.priceLevel,
          unit: product.unit ?? product.baseUnit,
        );

        final newItem = SalesOrderItemParamsEntity(
          skuId: product.id,
          namaProduk: product.namaInventaris,
          qty: newQty,
          satuan: product.unit ?? product.baseUnit,
          harga: resolved.pricePerUnit,
          pricingSource: resolved.appliedRule,
          subtotal: resolved.pricePerUnit * newQty,
        );

        if (index >= 0) {
          currentItems[index] = newItem;
        } else {
          currentItems.add(newItem);
        }
      }
    });
  }

  void _showEditPriceDialog(
    BuildContext context,
    ProductEntity product,
    double currentPrice,
  ) {
    final controller = TextEditingController(
      text: IdrTextInputFormatter.formatNumber(currentPrice),
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Harga Manual'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [IdrTextInputFormatter()],
            decoration: const InputDecoration(
              prefixText: 'Rp ',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final newPrice = IdrTextInputFormatter.tryParse(
                  controller.text,
                );
                if (newPrice != null && newPrice >= 0) {
                  setState(() {
                    final index = currentItems.indexWhere(
                      (e) => e.skuId == product.id,
                    );
                    if (index >= 0) {
                      final existingItem = currentItems[index];
                      currentItems[index] = SalesOrderItemParamsEntity(
                        skuId: existingItem.skuId,
                        namaProduk: existingItem.namaProduk,
                        qty: existingItem.qty,
                        satuan: existingItem.satuan,
                        harga: newPrice,
                        pricingSource: 'manual',
                        subtotal: newPrice * (existingItem.qty ?? 0),
                      );
                    } else {
                      currentItems.add(
                        SalesOrderItemParamsEntity(
                          skuId: product.id,
                          namaProduk: product.namaInventaris,
                          qty: 1,
                          satuan: product.unit ?? product.baseUnit,
                          harga: newPrice,
                          pricingSource: 'manual',
                          subtotal: newPrice,
                        ),
                      );
                    }
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  double get totalOrderValue => currentItems.fold(
    0,
    (sum, item) =>
        sum + (item.subtotal ?? ((item.harga ?? 0) * (item.qty ?? 0))),
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProductGetAllCubit>()..fetch(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        padding: const EdgeInsets.all(AppDimens.paddingMediumX),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pilih Produk',
                  style: context.textStyle.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 4),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari produk/SKU...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val.toLowerCase();
                });
              },
            ),
            const SizedBox(height: 8),
            Expanded(
              child: BlocBuilder<ProductGetAllCubit, ProductGetAllState>(
                builder: (context, state) {
                  if (state.status.isLoading || state.status.isInitial) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.status.isNotLoaded) {
                    return Center(
                      child: Text(
                        state.failure?.message ?? 'Gagal memuat produk',
                      ),
                    );
                  }

                  var products = state.data;
                  if (_searchQuery.isNotEmpty) {
                    products = products
                        .where(
                          (p) =>
                              (p.namaInventaris?.toLowerCase().contains(
                                    _searchQuery,
                                  ) ??
                                  false) ||
                              (p.sku?.toLowerCase().contains(_searchQuery) ??
                                  false) ||
                              (p.kodeInventaris?.toLowerCase().contains(
                                    _searchQuery,
                                  ) ??
                                  false),
                        )
                        .toList();
                  }

                  if (products.isEmpty) {
                    return const Center(
                      child: Text('Tidak ada produk tersedia'),
                    );
                  }

                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      final existingItem = currentItems
                          .cast<SalesOrderItemParamsEntity?>()
                          .firstWhere(
                            (e) => e?.skuId == product.id,
                            orElse: () => null,
                          );
                      final currentQty = existingItem?.qty ?? 0.0;
                      final currentPrice =
                          existingItem?.harga ?? product.hargaJual ?? 0.0;
                      final pricingSource =
                          existingItem?.pricingSource ?? 'reguler';

                      return Column(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 0,
                            ),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    product.namaInventaris ?? '-',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                if (product.quantityTiers?.isNotEmpty ?? false)
                                  const Padding(
                                    padding: EdgeInsets.only(left: 4),
                                    child: Icon(
                                      Icons.local_offer,
                                      size: 16,
                                      color: Colors.orange,
                                    ),
                                  ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  'SKU: ${product.sku ?? product.kodeInventaris ?? '-'}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: widget.allowManualPrice
                                          ? () {
                                              _showEditPriceDialog(
                                                context,
                                                product,
                                                currentPrice,
                                              );
                                            }
                                          : null,
                                      child: Row(
                                        children: [
                                          Text(
                                            'Rp ${currentPrice.toInt().textDecimalDigit} / ${product.unit ?? product.baseUnit ?? '-'}',
                                            style: TextStyle(
                                              color: Theme.of(
                                                context,
                                              ).primaryColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          if (widget.allowManualPrice) ...[
                                            const SizedBox(width: 4),
                                            Icon(
                                              Icons.edit,
                                              size: 14,
                                              color: Theme.of(
                                                context,
                                              ).primaryColor,
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    if (pricingSource != 'reguler') ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: pricingSource == 'manual'
                                              ? Colors.orange.withValues(
                                                  alpha: 0.2,
                                                )
                                              : Colors.green.withValues(
                                                  alpha: 0.2,
                                                ),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Text(
                                          pricingSource.toUpperCase(),
                                          style: TextStyle(
                                            color: pricingSource == 'manual'
                                                ? Colors.orange
                                                : Colors.green,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Subtotal: Rp ${(existingItem?.subtotal ?? 0).toInt().textDecimalDigit}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Stok: ${product.stok ?? 0}',
                                  style: TextStyle(
                                    color: (product.stok ?? 0) > 0
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: currentQty > 0
                                          ? () => updateQty(
                                              product,
                                              currentQty - 1,
                                            )
                                          : null,
                                      child: Icon(
                                        Icons.remove_circle_outline,
                                        color: currentQty > 0
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 28,
                                      child: Text(
                                        currentQty.toInt().toString(),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: currentQty < (product.stok ?? 999)
                                          ? () => updateQty(
                                              product,
                                              currentQty + 1,
                                            )
                                          : null,
                                      child: Icon(
                                        Icons.add_circle_outline,
                                        color:
                                            currentQty < (product.stok ?? 999)
                                            ? Colors.green
                                            : Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 1),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            AppDimens.size1X.hSpace,
            Container(
              padding: EdgeInsets.fromLTRB(
                AppDimens.paddingMedium,
                AppDimens.paddingMedium,
                AppDimens.paddingMedium,
                AppDimens.paddingMedium +
                    MediaQuery.viewInsetsOf(context).bottom +
                    MediaQuery.paddingOf(context).bottom,
              ),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Pesanan',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        'Rp ${totalOrderValue.toInt().textDecimalDigit}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${currentItems.length} produk',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 140,
                    child: AppButton(
                      text: 'Simpan',
                      onPressed: () {
                        Navigator.of(context).pop(currentItems);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
