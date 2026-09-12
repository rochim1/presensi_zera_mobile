import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/service/_service.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:intl/intl.dart';

@RoutePage()
class ProfileSyncPage extends StatefulWidget {
  const ProfileSyncPage({super.key});

  @override
  State<ProfileSyncPage> createState() => _ProfileSyncPageState();
}

class _ProfileSyncPageState extends State<ProfileSyncPage> {
  final _syncService = sl<SyncService>();
  final _localCache = sl<LocalCacheService>();

  @override
  void initState() {
    super.initState();
    _syncService.pendingCountNotifier.addListener(_onSyncChanged);
  }

  @override
  void dispose() {
    _syncService.pendingCountNotifier.removeListener(_onSyncChanged);
    super.dispose();
  }

  void _onSyncChanged() {
    if (mounted) {
      setState(() {}); // Rebuild lists
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '-';
    try {
      final dt = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy, HH:mm').format(dt);
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sinkronisasi Data'),
          actions: [
            IconButton(
              icon: const Icon(Icons.sync_rounded),
              tooltip: 'Sinkronisasi Sekarang',
              onPressed: () {
                _syncService.syncPendingOrders();
              },
            ),
          ],
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withValues(alpha: 0.7),
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: const [
              Tab(text: 'Sales Order'),
              Tab(text: 'Presensi'),
              Tab(text: 'Kunjungan'),
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(
                AppDimens.w16,
                AppDimens.h16,
                AppDimens.w16,
                0,
              ),
              padding: EdgeInsets.all(AppDimens.w12),
              decoration: BoxDecoration(
                color: AppColors.infoBackground,
                border: Border.all(color: AppColors.infoBorder),
                borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline_rounded, color: AppColors.info),
                  AppDimens.w8.wSpace,
                  Expanded(
                    child: Text(
                      'Sinkronisasi otomatis tersedia untuk Sales Order dan checkout offline. '
                      'Data akan dikirim setelah server kembali. '
                      'Check-in, istirahat, dan kunjungan masih menunggu dukungan sinkronisasi. '
                      'Profil terakhir, daftar apotek, dan katalog produk adalah cache baca sehingga tidak tampil sebagai antrean.',
                      // Read-only caches are intentionally not counted as a
                      // pending queue because they do not need to be uploaded.
                      style: context.textStyle.bodySmall?.copyWith(
                        color: AppColors.bodyText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ValueListenableBuilder<int>(
                valueListenable: _syncService.pendingCountNotifier,
                builder: (context, pendingCount, child) {
                  return TabBarView(
                    children: [
                      _buildOrderList(),
                      _buildPresensiList(),
                      _buildVisitList(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _localCache.getPendingOrders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final items = snapshot.data ?? [];
        if (items.isEmpty) {
          return _buildEmptyState('Tidak ada antrean Sales Order');
        }

        return ListView.separated(
          padding: EdgeInsets.all(AppDimens.w16),
          itemCount: items.length,
          separatorBuilder: (_, _) => AppDimens.paddingMedium.hSpace,
          itemBuilder: (context, index) {
            final data = items[index];
            final entity = SalesOrderParamsEntity.fromJson(data);
            return _buildListItem(
              title: entity.outletNama ?? 'Outlet Tidak Diketahui',
              subtitle:
                  'Tipe: ${entity.tipeOrder ?? '-'} • Item: ${entity.items?.length ?? 0}',
              date: _formatDate(entity.tanggal),
              icon: Icons.shopping_cart_rounded,
            );
          },
        );
      },
    );
  }

  Widget _buildPresensiList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _localCache.getPendingPresensi(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final items = snapshot.data ?? [];
        if (items.isEmpty) {
          return _buildEmptyState('Tidak ada antrean Presensi');
        }

        return ListView.separated(
          padding: EdgeInsets.all(AppDimens.w16),
          itemCount: items.length,
          separatorBuilder: (_, _) => AppDimens.paddingMedium.hSpace,
          itemBuilder: (context, index) {
            final data = items[index];
            final type =
                data['sync_type']
                    ?.toString()
                    .replaceAll('_', ' ')
                    .toUpperCase() ??
                'PRESENSI';
            final waktu = data['waktu_lokasi'] ?? data['waktu_lokal'] ?? '-';
            final isCheckout = data['sync_type'] == 'check_out';

            return _buildListItem(
              title: type,
              subtitle:
                  'Koordinat: ${data['latitude'] ?? '-'}, ${data['longitude'] ?? '-'}',
              date: _formatDate(waktu),
              icon: Icons.fingerprint_rounded,
              status: isCheckout
                  ? 'Siap dikirim otomatis'
                  : 'Menunggu dukungan sinkronisasi',
            );
          },
        );
      },
    );
  }

  Widget _buildVisitList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _localCache.getPendingVisits(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final items = snapshot.data ?? [];
        if (items.isEmpty) {
          return _buildEmptyState('Tidak ada antrean Kunjungan');
        }

        return ListView.separated(
          padding: EdgeInsets.all(AppDimens.w16),
          itemCount: items.length,
          separatorBuilder: (_, _) => AppDimens.paddingMedium.hSpace,
          itemBuilder: (context, index) {
            final data = items[index];
            final type =
                data['sync_type']
                    ?.toString()
                    .replaceAll('_', ' ')
                    .toUpperCase() ??
                'KUNJUNGAN';

            return _buildListItem(
              title: type,
              subtitle: 'ID Tugas: ${data['task_id'] ?? data['id'] ?? '-'}',
              date: '-',
              icon: Icons.directions_walk_rounded,
              status: 'Menunggu dukungan sinkronisasi',
            );
          },
        );
      },
    );
  }

  Widget _buildListItem({
    required String title,
    required String subtitle,
    required String date,
    required IconData icon,
    String? status,
  }) {
    return Container(
      padding: EdgeInsets.all(AppDimens.w16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppDimens.w8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          AppDimens.paddingMedium.wSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.textStyle.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppDimens.paddingSmall.hSpace,
                Text(
                  subtitle,
                  style: context.textStyle.bodySmall?.copyWith(
                    color: AppColors.labelSecondary,
                  ),
                ),
                if (status != null) ...[
                  AppDimens.h4.hSpace,
                  Text(
                    status,
                    style: context.textStyle.labelSmall?.copyWith(
                      color: AppColors.warning,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          AppDimens.paddingSmall.wSpace,
          Text(
            date,
            style: context.textStyle.labelSmall?.copyWith(
              color: AppColors.labelSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_done_rounded,
            size: 64,
            color: AppColors.dividerLight,
          ),
          AppDimens.paddingMedium.hSpace,
          Text(
            message,
            style: context.textStyle.titleMedium?.copyWith(
              color: AppColors.labelSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
