import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/bloc/order/order_get_all_sales_orders/order_get_all_sales_orders_cubit.dart';
import 'package:presensi_mobile/presentation/bloc/order/order_get_all_sales_orders/order_get_all_sales_orders_state.dart';

class SalesOrderDetailSheet extends StatelessWidget {
  final String noOrder;

  const SalesOrderDetailSheet({super.key, required this.noOrder});

  static Future<void> show(BuildContext context, String noOrder) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SalesOrderDetailSheet(noOrder: noOrder),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OrderGetAllSalesOrdersCubit>()..getAllData(),
      child: DraggableScrollableSheet(
        initialChildSize: 0.5,
        maxChildSize: 0.8,
        minChildSize: 0.3,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimens.radiusLarge)),
            ),
            child: Column(
              children: [
                const SizedBox(height: AppDimens.paddingMedium),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: AppDimens.paddingMedium),
                Text(
                  'Detail Tagihan',
                  style: context.textStyle.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Divider(),
                Expanded(
                  child: BlocBuilder<OrderGetAllSalesOrdersCubit, OrderGetAllSalesOrdersState>(
                    builder: (context, state) {
                      if (state.status.isLoading || state.status.isInitial) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state.status.isNotLoaded) {
                        return Center(
                          child: Text(
                            state.failure?.message ?? 'Terjadi kesalahan',
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }

                      final order = (state.salesOrders ?? []).where((e) => e.noOrder == noOrder).firstOrNull;

                      if (order == null) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('Data tagihan tidak ditemukan. Memerlukan sinkronisasi ulang dengan admin.', textAlign: TextAlign.center),
                          ),
                        );
                      }

                      return ListView(
                        controller: scrollController,
                        padding: EdgeInsets.fromLTRB(AppDimens.paddingMediumX, AppDimens.paddingMediumX, AppDimens.paddingMediumX, AppDimens.paddingMediumX + MediaQuery.viewInsetsOf(context).bottom + MediaQuery.paddingOf(context).bottom),
                        children: [
                          _buildInfoRow('No Order / Faktur', order.noOrder ?? '-'),
                          _buildInfoRow('Outlet', order.outletNama ?? '-'),
                          _buildInfoRow('Tipe Order', order.tipeOrder?.replaceAll('_', ' ').toUpperCase() ?? '-'),
                          _buildInfoRow('Tanggal', order.tanggal?.split('T').first ?? '-'),
                          _buildInfoRow('Status Pembayaran', order.statusPembayaran?.replaceAll('_', ' ').toUpperCase() ?? '-'),
                          const SizedBox(height: AppDimens.paddingMedium),
                          Container(
                            padding: const EdgeInsets.all(AppDimens.paddingMediumX),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                              border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Total Tagihan', style: TextStyle(color: AppColors.labelSecondary)),
                                    Text(
                                      'Rp ${(order.totalOrder ?? order.netSales ?? 0).toInt().textDecimalDigit}',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Sisa Harus Dibayar', style: TextStyle(color: AppColors.labelSecondary)),
                                    Text(
                                      'Rp ${(order.sisaTagihan ?? 0).toInt().textDecimalDigit}',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppDimens.paddingMediumX),
                          Text('Jadwal / Termin Pembayaran', style: context.textStyle.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: AppDimens.paddingSmall),
                          Container(
                            padding: const EdgeInsets.all(AppDimens.paddingMedium),
                            decoration: BoxDecoration(
                              color: Colors.orange.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline, color: Colors.orange.shade700, size: 20),
                                const SizedBox(width: 8),
                                const Expanded(
                                  child: Text(
                                    'Detail termin tidak tersedia pada sistem saat ini. Harap konfirmasi dengan admin.',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: TextStyle(color: AppColors.labelSecondary)),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
