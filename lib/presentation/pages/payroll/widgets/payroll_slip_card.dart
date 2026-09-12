import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

class PayrollSlipCard extends StatelessWidget {
  final PayrollSlip? slip;
  final VoidCallback? onTap;
  final bool isLoading;

  const PayrollSlipCard({super.key, required this.slip, this.onTap})
    : isLoading = false;

  const PayrollSlipCard.shimmer({super.key})
    : slip = null,
      onTap = null,
      isLoading = true;

  String _formatCurrency(num value) => NumberFormat.simpleCurrency(
    locale: 'id',
    decimalDigits: 0,
    name: "Rp",
  ).format(value);

  String _periodLabel(PayrollSlip slip) {
    if (slip.month != null &&
        slip.year != null &&
        slip.month! >= 1 &&
        slip.month! <= 12) {
      return DateTime(slip.year!, slip.month!, 1).format(pattern: 'MMMM yyyy');
    }

    if (slip.period != null && slip.period!.isNotEmpty) {
      return slip.period!;
    }

    return '-';
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const AppRequestCard.shimmer(hasShadow: false);

    final statusColor = slip!.status.toDisplayColor;
    final slipUser = slip!.user;
    final user = PayrollSlipUser(
      id: slipUser?.id ?? '-',
      name: slipUser?.name ?? '-',
      email: slipUser?.email,
      departmentName: slipUser?.departmentName,
      positionName: slipUser?.positionName,
    );

    return AppRequestCard(
      hasShadow: false,
      user: User(
        id: user.id,
        name: user.name,
        department: user.departmentName != null
            ? Department(id: '', name: user.departmentName!)
            : null,
      ),
      statusColor: statusColor,
      statusLabel: slip!.status.toDisplayName,
      title: _periodLabel(slip!),
      subtitle: user.positionName ?? user.email,
      onTap: onTap,
      middleContent: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppDimens.h10,
          children: [
            AppRequestDateRow(
              title: 'Total Pendapatan',
              value: _formatCurrency(slip!.totalIncome),
              icon: PhosphorIcons.arrowUpRight,
              iconColor: AppColors.green,
            ),
            AppRequestDateRow(
              title: 'Total Potongan',
              value: _formatCurrency(slip!.totalDeduction),
              icon: PhosphorIcons.arrowDownRight,
              iconColor: AppColors.danger,
            ),
          ],
        ),
      ],
      footer: Text(
        'Gaji Bersih: ${_formatCurrency(slip!.netSalary)}',
        style: context.theme.textTheme.bodySmall?.copyWith(
          color: AppColors.green,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
