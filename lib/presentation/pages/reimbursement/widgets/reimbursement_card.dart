import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/widgets/_widgets.dart';

class ReimbursementCard extends StatelessWidget {
  final Reimbursement? reimbursement;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool showUser;

  const ReimbursementCard({
    super.key,
    required this.reimbursement,
    this.onTap,
    this.showUser = true,
  }) : isLoading = false;

  const ReimbursementCard.shimmer({
    super.key,
    this.showUser = true,
  })
    : reimbursement = null,
      isLoading = true,
      onTap = null;

  @override
  Widget build(BuildContext context) {
    if (isLoading) return AppRequestCard.shimmer(showUser: showUser);
    return _buildCard(context, reimbursement!);
  }

  Widget _buildCard(BuildContext context, Reimbursement reimbursement) {
    return AppRequestCard(
      user: reimbursement.user,
      showUser: showUser,
      statusColor: AppColors.primary, // Using primary as default for Reimbursement status
      statusLabel: reimbursement.statusReimbursement?.toUpperCase() ?? '-',
      title: 'Reimbursement',
      subtitle: reimbursement.judul ?? '-',
      onTap: onTap,
      middleContent: [
        Row(
          children: [
            Expanded(
              child: AppRequestDateRow(
                title: 'Kategori',
                value: reimbursement.kategori ?? '-',
                icon: PhosphorIcons.tag,
                iconColor: AppColors.orange,
              ),
            ),
            Container(height: 28, width: 1, color: AppColors.dividerLight),
            SizedBox(width: AppDimens.w16),
            Expanded(
              child: AppRequestDateRow(
                title: 'Tanggal',
                value: reimbursement.tanggal?.format(pattern: 'dd MMM yyyy') ?? '-',
                icon: PhosphorIcons.calendarBlank,
                iconColor: AppColors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: AppRequestDateRow(
                title: 'Nominal',
                value: reimbursement.nominal?.toCurrency(reimbursement.mataUang ?? CurrencySymbol.IDR) ?? '-',
                icon: PhosphorIcons.coins,
                iconColor: AppColors.primary,
              ),
            ),
          ],
        ),
        if (reimbursement.catatanPengaju != null && reimbursement.catatanPengaju!.isNotEmpty) ...[
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.dividerLight),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(PhosphorIcons.note, size: 16, color: AppColors.labelSecondary),
              SizedBox(width: AppDimens.w8),
              Expanded(
                child: Text(
                  reimbursement.catatanPengaju!,
                  style: context.textTheme.bodySmall?.copyWith(color: AppColors.labelSecondary),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
