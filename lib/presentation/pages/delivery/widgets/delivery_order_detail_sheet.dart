import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/bloc/delivery_order/delivery_order_get_all_cubit.dart';

class DeliveryOrderDetailSheet extends StatelessWidget {
  final String noDo;

  const DeliveryOrderDetailSheet({super.key, required this.noDo});

  static Future<void> show(BuildContext context, String noDo) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DeliveryOrderDetailSheet(noDo: noDo),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DeliveryOrderGetAllCubit>()..loadDeliveryOrders(),
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
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
                  'Detail Surat Jalan (DO)',
                  style: context.textStyle.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Divider(),
                Expanded(
                  child: BlocBuilder<DeliveryOrderGetAllCubit, DeliveryOrderGetAllState>(
                    builder: (context, state) {
                      if (state is DeliveryOrderGetAllLoading || state is DeliveryOrderGetAllInitial) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state is DeliveryOrderGetAllError) {
                        return Center(
                          child: Text(
                            state.message,
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }

                      if (state is DeliveryOrderGetAllLoaded) {
                        final order = state.deliveryOrders.where((e) {
                          final query = noDo.trim().toLowerCase();
                          final matchDo = (e.noDo ?? '').toLowerCase() == query;
                          final matchOrder = (e.noOrder ?? '').toLowerCase() == query;
                          return matchDo || matchOrder;
                        }).firstOrNull;

                        if (order == null) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text('Data DO ($noDo) tidak ditemukan di daftar server. Memerlukan sinkronisasi ulang.', textAlign: TextAlign.center),
                            ),
                          );
                        }

                        return ListView(
                          controller: scrollController,
                          padding: EdgeInsets.fromLTRB(AppDimens.paddingMediumX, AppDimens.paddingMediumX, AppDimens.paddingMediumX, AppDimens.paddingMediumX + MediaQuery.viewInsetsOf(context).bottom + MediaQuery.paddingOf(context).bottom),
                          children: [
                            _buildInfoRow('No DO', order.noDo ?? '-'),
                            _buildInfoRow('No Order Ref', order.noOrder ?? '-'),
                            _buildInfoRow('Outlet', order.outletNama ?? '-'),
                            _buildInfoRow('Alamat Kirim', order.alamatKirim ?? '-'),
                            _buildInfoRow('Driver / Kendaraan', '${order.driverNama ?? '-'} / ${order.noKendaraan ?? '-'}'),
                            _buildInfoRow('Tgl Kirim', order.tanggalKirim?.split('T').first ?? '-'),
                            _buildInfoRow('Status', order.status?.replaceAll('_', ' ').toUpperCase() ?? '-'),
                            
                            const SizedBox(height: AppDimens.paddingMediumX),
                            Text('Daftar Item', style: context.textStyle.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: AppDimens.paddingSmall),
                            
                            if (order.items != null && order.items!.isNotEmpty)
                              ...order.items!.map((item) => _buildItemRow(item)),
                            if (order.items == null || order.items!.isEmpty)
                              const Text('Tidak ada item tercatat.', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
                              
                            const SizedBox(height: AppDimens.paddingMediumX),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Total Qty Item', style: TextStyle(fontWeight: FontWeight.w600)),
                                Text(
                                  order.totalItem?.toStringAsFixed(0) ?? '0',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                      
                      return const SizedBox.shrink();
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

  Widget _buildItemRow(DeliveryOrderItemEntity item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              item.namaProduk ?? '-',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${item.qty?.toStringAsFixed(0) ?? '0'} ${item.satuan ?? ''}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
