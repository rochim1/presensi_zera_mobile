import 'package:presensi_mobile/l10n/hr_localization.dart';
import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/widgets/_widgets.dart';

class OvertimeRequestDetailView extends StatelessWidget {
  final OvertimeRequest request;
  const OvertimeRequestDetailView({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final color = request.status.toDisplayColor;

    return AppRequestDetailView(
      user: request.user,
      statusLabel: request.status.toDisplayName,
      statusColor: color,
      reason: request.reason,
      createdAt: request.createdAt,
      approvalHistory: request.approvalHistory,
      middleContent: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppDimens.h16,
          children: [
            if (request.date != null)
              AppRequestDetailItem(
                label: ('Tanggal').tr(context),
                date: request.date,
                icon: PhosphorIcons.calendarBlank,
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppTimelineConnector(
                  color: color,
                  width: AppDimens.w8,
                  height: AppDimens.h80,
                  isDashed: true,
                ),
                SizedBox(width: AppDimens.w10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: AppDimens.h16,
                    children: [
                      AppRequestDetailItem(
                        label: ('Waktu Mulai').tr(context),
                        textValue: request.startTime?.format(pattern: 'HH:mm'),
                        icon: PhosphorIcons.clock,
                      ),
                      AppRequestDetailItem(
                        label: ('Waktu Selesai').tr(context),
                        textValue: request.endTime?.format(pattern: 'HH:mm'),
                        icon: PhosphorIcons.clock,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
