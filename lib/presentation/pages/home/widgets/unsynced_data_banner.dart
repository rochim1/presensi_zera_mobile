import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/service/_service.dart';
import 'package:auto_route/auto_route.dart';

/// Banner widget that shows the count of unsynced offline orders.
class UnsyncedDataBanner extends StatelessWidget {
  const UnsyncedDataBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final syncService = sl<SyncService>();

    return ValueListenableBuilder<int>(
      valueListenable: syncService.pendingCountNotifier,
      builder: (context, count, child) {
        if (count == 0) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: 0.1),
            border: Border.all(color: Colors.orange.withValues(alpha: 0.4)),
            borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
          ),
          child: Row(
            children: [
              Icon(
                PhosphorIcons.cloudArrowUpFill,
                color: Colors.orange,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Data Belum Tersinkronisasi',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.orange,
                      ),
                    ),
                    Text(
                      '$count data offline menunggu sinkronisasi',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.labelSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Lihat data offline',
                    onPressed: () =>
                        context.router.push(const ProfileSyncPageRoute()),
                    icon: const Icon(Icons.chevron_right_rounded),
                    color: Colors.orange,
                  ),
                  GestureDetector(
                    onTap: () => syncService.syncPendingOrders(),
                    child: Icon(
                      PhosphorIcons.arrowsClockwise,
                      color: Colors.orange,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
