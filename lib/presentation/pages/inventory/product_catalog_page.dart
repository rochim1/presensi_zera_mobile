import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

@RoutePage()
class ProductCatalogPage extends StatefulWidget {
  const ProductCatalogPage({super.key});

  @override
  State<ProductCatalogPage> createState() => _ProductCatalogPageState();
}

class _ProductCatalogPageState extends State<ProductCatalogPage> {
  String _searchQuery = '';
  final String _selectedCategory = 'Semua';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProductGetAllCubit>()..fetch(),
      child: Scaffold(
        appBar: const AppTopBar(title: 'Katalog Produk Digital'),
        body: Column(
          children: [
            // Search Bar & Filters
            Container(
              padding: const EdgeInsets.all(AppDimens.paddingMediumX),
              color: Colors.white,
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari nama atau SKU produk...',
                      prefixIcon: Icon(PhosphorIcons.magnifyingGlass),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                        borderSide: BorderSide(color: AppColors.divider),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                        borderSide: BorderSide(color: AppColors.divider),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                      });
                    },
                  ),
                  const SizedBox(height: AppDimens.paddingSmall),
                  // Categories can be added here if needed
                ],
              ),
            ),
            
            // Product List
            Expanded(
              child: BlocBuilder<ProductGetAllCubit, ProductGetAllState>(
                builder: (context, state) {
                  if (state.status == TypeState.loading || state.status == TypeState.initial) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (state.status == TypeState.notLoaded) {
                    return Center(
                      child: Text(
                        state.failure?.message ?? 'Gagal memuat katalog',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  final allProducts = state.data ?? [];
                  
                  // Filter products
                  final filteredProducts = allProducts.where((p) {
                    final matchesSearch = (p.namaInventaris?.toLowerCase().contains(_searchQuery) ?? false) ||
                                          (p.sku?.toLowerCase().contains(_searchQuery) ?? false);
                    final matchesCategory = _selectedCategory == 'Semua' || (p.kategori == _selectedCategory);
                    return matchesSearch && matchesCategory;
                  }).toList();

                  if (filteredProducts.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(PhosphorIcons.package, size: 64, color: AppColors.labelSecondary),
                          const SizedBox(height: 16),
                          const Text('Produk tidak ditemukan'),
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(AppDimens.paddingMediumX),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: AppDimens.paddingMediumX,
                      mainAxisSpacing: AppDimens.paddingMediumX,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      final isOutOfStock = (product.stok ?? 0) <= 0;
                      
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                          border: Border.all(color: AppColors.divider),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Image Placeholder
                            Expanded(
                              flex: 3,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F7F9),
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(AppDimens.radiusMedium)),
                                ),
                                child: Center(
                                  child: Icon(
                                    PhosphorIcons.imageFill,
                                    size: 48,
                                    color: AppColors.labelTertiary,
                                  ),
                                ),
                              ),
                            ),
                            
                            // Product Details
                            Expanded(
                              flex: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(AppDimens.paddingMedium),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: isOutOfStock ? Colors.red.withValues(alpha: 0.1) : Colors.green.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        isOutOfStock ? 'Habis' : 'Stok: ${product.stok?.toInt()}',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: isOutOfStock ? Colors.red : Colors.green,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      product.namaInventaris ?? '-',
                                      style: context.textStyle.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      'SKU: ${product.sku ?? '-'}',
                                      style: context.textStyle.bodySmall?.copyWith(color: AppColors.labelSecondary),
                                    ),
                                    const Spacer(),
                                    Text(
                                      'Rp ${(product.hargaJual ?? 0).toInt().textDecimalDigit}',
                                      style: context.textStyle.titleSmall?.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
