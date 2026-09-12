import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/widgets/_widgets.dart';

class ReimbursementDetailView extends StatelessWidget {
  final Reimbursement reimbursement;

  const ReimbursementDetailView({super.key, required this.reimbursement});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppDimens.h16,
        children: [
          AppDetailSectionCard(child: _buildMainInfo(context)),
          AppDetailSectionCard(child: _buildFinancialInfo(context)),
          if (reimbursement.deskripsi != null &&
              reimbursement.deskripsi!.isNotEmpty)
            AppDetailSectionCard(child: _buildDescription(context)),
          if (reimbursement.catatanPengaju != null &&
              reimbursement.catatanPengaju!.isNotEmpty)
            AppDetailSectionCard(
              child: _buildNotes(
                context,
                'Catatan Pengaju',
                reimbursement.catatanPengaju!,
              ),
            ),
          if (reimbursement.catatanFinance != null &&
              reimbursement.catatanFinance!.isNotEmpty)
            AppDetailSectionCard(
              child: _buildNotes(
                context,
                'Catatan Finance',
                reimbursement.catatanFinance!,
              ),
            ),
          if (reimbursement.approvalHistory != null)
            AppDetailSectionCard(child: _buildApprovalHistory(context)),
          AppDetailSectionCard(child: _buildTechnicalInfo(context)),
        ],
      ),
    );
  }

  Widget _buildMainInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppDimens.h12,
      children: [
        Row(
          children: [
            Expanded(
              child: AppLabeledValue(
                label: 'Judul',
                value: reimbursement.judul ?? '-',
              ),
            ),
            AppChip(
              label: reimbursement.statusReimbursement?.toUpperCase() ?? '-',
              borderRadius: AppDimens.r16,
            ),
          ],
        ),
        AppLabeledValue(
          label: 'Kategori',
          value: reimbursement.kategori ?? '-',
          icon: PhosphorIcons.tag,
          iconColor: AppColors.primary,
        ),
        AppLabeledValue(
          label: 'Tanggal Pengajuan',
          value:
              reimbursement.tanggalPengajuan?.format(
                pattern: 'EEEE, dd MMMM yyyy HH:mm',
              ) ??
              '-',
          icon: PhosphorIcons.calendarBlank,
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildFinancialInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppDimens.h12,
      children: [
        Text(
          'Informasi Keuangan',
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: AppLabeledValue(
                label: 'Tanggal Transaksi',
                value:
                    reimbursement.tanggal?.format(pattern: 'dd MMMM yyyy') ??
                    '-',
                icon: PhosphorIcons.calendar,
                iconColor: AppColors.primary,
              ),
            ),
            Expanded(
              child: AppLabeledValue(
                label: 'Nominal',
                value:
                    reimbursement.nominal?.toCurrency(
                      reimbursement.mataUang ?? CurrencySymbol.IDR,
                    ) ??
                    '-',
                icon: PhosphorIcons.currencyDollar,
                iconColor: AppColors.green,
              ),
            ),
          ],
        ),
        if (reimbursement.buktiPembayaran != null &&
            reimbursement.buktiPembayaran!.isNotEmpty) ...[
          AppLabeledValue(
            label: 'Bukti Pembayaran',
            value: reimbursement.filename ?? 'File bukti',
            icon: PhosphorIcons.fileImage,
            iconColor: AppColors.primary,
          ),
        ],
        const Divider(),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppDimens.h12,
      children: [
        Text(
          'Deskripsi',
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          reimbursement.deskripsi!,
          style: context.textTheme.bodyMedium?.copyWith(
            color: AppColors.labelSecondary,
            height: 1.5,
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildNotes(BuildContext context, String title, String notes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppDimens.h12,
      children: [
        Text(
          title,
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          notes,
          style: context.textTheme.bodyMedium?.copyWith(
            color: AppColors.labelSecondary,
            height: 1.5,
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildApprovalHistory(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppDimens.h12,
      children: [
        AppApprovalHistory(history: reimbursement.approvalHistory!),
        const Divider(),
      ],
    );
  }

  Widget _buildTechnicalInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppDimens.h8,
      children: [
        AppMetaText('ID: #${reimbursement.id}'),
        if (reimbursement.tanggalAksi != null)
          AppMetaText(
            'TANGGAKSI: ${reimbursement.tanggalAksi!.format(pattern: 'dd MMM yyyy, HH:mm')}',
          ),
        if (reimbursement.aktorAksi != null)
          AppMetaText('AKTORAKSI: ${reimbursement.aktorAksi!.name}'),
        if (reimbursement.createdAt != null)
          AppMetaText(
            'DIBUAT PADA: ${reimbursement.createdAt!.format(pattern: 'dd MMM yyyy, HH:mm')}',
          ),
        if (reimbursement.updatedAt != null)
          AppMetaText(
            'DIUPDATE PADA: ${reimbursement.updatedAt!.format(pattern: 'dd MMM yyyy, HH:mm')}',
          ),
      ],
    );
  }
}
