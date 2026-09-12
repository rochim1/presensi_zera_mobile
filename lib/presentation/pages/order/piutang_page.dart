import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

@RoutePage()
class PiutangPage extends StatefulWidget {
  const PiutangPage({super.key});

  @override
  State<PiutangPage> createState() => _PiutangPageState();
}

class _PiutangPageState extends State<PiutangPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<OrderGetAllSalesOrdersCubit>()
            ..getAllData(statusPembayaran: 'unpaid'),
      child: Scaffold(
        appBar: const AppTopBar(title: 'Daftar Piutang Outlet'),
        body: BlocBuilder<OrderGetAllSalesOrdersCubit, OrderGetAllSalesOrdersState>(
          builder: (context, state) {
            if (state.status == TypeState.loading ||
                state.status == TypeState.initial) {
              return ListView.separated(
                padding: const EdgeInsets.all(AppDimens.paddingMediumX),
                itemCount: 5,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppDimens.paddingMediumX),
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(AppDimens.paddingMediumX),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        AppDimens.radiusMedium,
                      ),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppShimmer.box(width: 120, height: 20),
                            AppShimmer.box(
                              width: 70,
                              height: 24,
                              radius: AppDimens.radiusSmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimens.paddingMedium),
                        AppShimmer.box(width: double.infinity, height: 16),
                        const SizedBox(height: 8),
                        AppShimmer.box(width: 200, height: 16),
                        const SizedBox(height: 8),
                        AppShimmer.box(width: 150, height: 16),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppShimmer.box(width: 100, height: 16),
                            AppShimmer.box(width: 120, height: 24),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            }

            if (state.status == TypeState.notLoaded) {
              return Center(
                child: Text(
                  state.failure?.message ?? 'Terjadi kesalahan',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            final items = state.salesOrders ?? [];
            if (items.isEmpty) {
              return const Center(child: Text('Tidak ada piutang saat ini.'));
            }

            return RefreshIndicator(
              onRefresh: () => context
                  .read<OrderGetAllSalesOrdersCubit>()
                  .getAllData(statusPembayaran: 'unpaid'),
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppDimens.paddingMediumX),
                itemCount: items.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppDimens.paddingMediumX),
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isPartial = item.statusPembayaran == 'partial';
                  return Container(
                    padding: const EdgeInsets.all(AppDimens.paddingMediumX),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        AppDimens.radiusMedium,
                      ),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.noOrder ?? '-',
                              style: context.textStyle.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(
                                  AppDimens.radiusSmall,
                                ),
                              ),
                              child: Text(
                                isPartial ? 'Dibayar Sebagian' : 'Belum Lunas',
                                style: const TextStyle(
                                  color: AppColors.danger,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimens.paddingMedium),
                        Text('Outlet: ${item.outletNama ?? '-'}'),
                        Text(
                          'Tipe Order: ${item.tipeOrder?.replaceAll('_', ' ').toUpperCase() ?? '-'}',
                        ),
                        Text(
                          'Tgl Order: ${item.tanggal?.split('T').first ?? '-'}',
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Piutang',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              'Rp ${(item.sisaTagihan ?? item.totalOrder ?? item.netSales ?? 0).toInt().textDecimalDigit}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
