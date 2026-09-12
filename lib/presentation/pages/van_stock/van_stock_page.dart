import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';
import 'package:presensi_mobile/presentation/pages/van_stock/bloc/van_stock_cubit.dart';
import 'package:presensi_mobile/presentation/pages/van_stock/bloc/van_stock_state.dart';
import 'package:intl/intl.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_domain/presensi_domain.dart';

@RoutePage()
class VanStockPage extends StatelessWidget {
  const VanStockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<VanStockCubit>()..loadStocks(isRefresh: true),
      child: Scaffold(
        appBar: const AppTopBar(title: 'Van Stock'),
        body: BlocBuilder<VanStockCubit, VanStockState>(
          builder: (context, state) {
            return state.maybeWhen(
              initial: () => const Center(child: CircularProgressIndicator()),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (message) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Gagal memuat Van Stock: \$message',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<VanStockCubit>().loadStocks(
                        isRefresh: true,
                      ),
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
              loaded: (stocks, hasReachedMax) {
                if (stocks.isEmpty) {
                  return const Center(
                    child: Text('Tidak ada stok di kendaraan Anda saat ini.'),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<VanStockCubit>().loadStocks(isRefresh: true);
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppDimens.paddingMedium),
                    itemCount: stocks.length + (hasReachedMax ? 0 : 1),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppDimens.paddingSmall),
                    itemBuilder: (context, index) {
                      if (index >= stocks.length) {
                        context.read<VanStockCubit>().loadStocks();
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final stock = stocks[index];
                      return _VanStockItemCard(stock: stock);
                    },
                  ),
                );
              },
              orElse: () => const SizedBox.shrink(),
            );
          },
        ),
      ),
    );
  }
}

class _VanStockItemCard extends StatelessWidget {
  final VanStock stock;

  const _VanStockItemCard({required this.stock});

  String _formatQty(double value) => value == value.truncateToDouble()
      ? value.toInt().toString()
      : value
            .toStringAsFixed(2)
            .replaceFirst(RegExp(r'0+$'), '')
            .replaceFirst(RegExp(r'\.$'), '');

  @override
  Widget build(BuildContext context) {
    final loadDate = stock.tanggalLoad == null
        ? '-'
        : DateFormat('dd MMM yyyy, HH:mm').format(stock.tanggalLoad!.toLocal());
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    stock.produkName,
                    style: context.textStyle.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
                  ),
                  child: Text(
                    stock.produkKode,
                    style: context.textStyle.bodySmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.paddingSmall),
            Text(
              'Tanggal Load: $loadDate',
              style: context.textStyle.bodySmall?.copyWith(
                color: AppColors.labelSecondary,
              ),
            ),
            if (stock.catatan != null && stock.catatan!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                'Catatan: ${stock.catatan}',
                style: context.textStyle.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn(
                  context,
                  'Awal',
                  _formatQty(stock.qtyLoaded),
                  Colors.blue,
                ),
                _buildStatColumn(
                  context,
                  'Terjual',
                  _formatQty(stock.qtySold),
                  Colors.green,
                ),
                _buildStatColumn(
                  context,
                  'Retur',
                  _formatQty(stock.qtyReturned),
                  Colors.orange,
                ),
                _buildStatColumn(
                  context,
                  'Sisa',
                  _formatQty(stock.qtyCurrent),
                  AppColors.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: context.textStyle.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: context.textStyle.bodySmall?.copyWith(
            color: AppColors.labelSecondary,
          ),
        ),
      ],
    );
  }
}
