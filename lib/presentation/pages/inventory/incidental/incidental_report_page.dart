import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/presentation/pages/inventory/incidental/bloc/incidental_report_cubit.dart';
import 'package:presensi_mobile/presentation/pages/inventory/incidental/bloc/incidental_report_state.dart';
import 'package:presensi_mobile/presentation/widgets/_widgets.dart';

@RoutePage()
class IncidentalReportPage extends StatefulWidget {
  const IncidentalReportPage({super.key});

  @override
  State<IncidentalReportPage> createState() => _IncidentalReportPageState();
}

class _IncidentalReportPageState extends State<IncidentalReportPage> {
  final _cubit = sl<IncidentalReportCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: const AppBarWidget(
          titleText: 'Incidental Report',
        ),
        body: BlocBuilder<IncidentalReportCubit, IncidentalReportState>(
          builder: (context, state) {
            if (state.reports.data.isEmpty && !state.reports.isLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('Belum Ada Laporan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('Data laporan insidental masih kosong.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              );
            }

            return AppInfiniteScrollView<IncidentalReport>(
                  state: state.reports,
                  onRefresh: () async => _cubit.loadData(),
                  onFetchNext: () => _cubit.fetchNextPage(),
                  padding: const EdgeInsets.all(16),
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, item) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.divider),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item.noIncident ?? '-',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              AppChip(
                                label: item.tindakan?.replaceAll('_', ' ').toUpperCase() ?? '-',
                                color: item.tindakan == 'recycle' ? Colors.blue : Colors.orange,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.namaInventaris ?? '-',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(PhosphorIcons.warningCircle, size: 16, color: Colors.red),
                              const SizedBox(width: 4),
                              Text(
                                item.jenisInsiden?.replaceAll('_', ' ').toUpperCase() ?? '-',
                                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                              ),
                              const SizedBox(width: 12),
                              Icon(PhosphorIcons.mapPin, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                item.lokasiKejadian?.replaceAll('_', ' ').toUpperCase() ?? '-',
                                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(PhosphorIcons.calendar, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                item.tanggalKejadian != null
                                    ? DateFormat('dd MMM yyyy HH:mm').format(DateTime.parse(item.tanggalKejadian!).toLocal())
                                    : '-',
                                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Jml Rusak', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                  Text(
                                    '${item.jumlahRusak ?? 0} ${item.unit ?? ''}',
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              if (item.tindakan == 'recycle')
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text('Hasil Recycle', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                    Text(
                                      '${item.jumlahHasilRecycle ?? 0} ${item.unit ?? ''}',
                                      style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.green),
                                    ),
                                  ],
                                ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text('Net Lost', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                  Text(
                                    '${item.jumlahHilang ?? 0} ${item.unit ?? ''}',
                                    style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.red),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            context.router.push(const IncidentalReportFormPageRoute()).then((value) {
              if (value == true) {
                _cubit.loadData();
              }
            });
          },
          backgroundColor: AppColors.primary,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text('Buat Laporan', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
