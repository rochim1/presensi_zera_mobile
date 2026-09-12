import 'package:flutter/material.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

class DeliveryTaskItemCard extends StatelessWidget {
  const DeliveryTaskItemCard({
    super.key,
    required this.task,
    this.onTap,
    this.onCanceled,
  });

  final TasksEntity task;
  final Function()? onTap;
  final Function()? onCanceled;

  @override
  Widget build(BuildContext context) {
    final aktivitas = task.aktivitas;
    final statusTask = aktivitas?.statusTask?.toStatusTask;
    final isCancelableTask = statusTask == StatusTask.pending;

    // Prioritaskan data outlet sales (GetAllVisitPlans), fallback ke apotek (legacy)
    final outlet = aktivitas?.outlet;
    final namaOutlet = (outlet?.namaOutlet?.isNotEmpty ?? false)
        ? outlet!.namaOutlet!
        : (aktivitas?.apotikId?.namaApotik ?? '-');
    final kodeOutlet = outlet?.kodeOutlet ?? aktivitas?.apotikId?.kodeApotik;
    final alamatOutlet = (outlet?.alamat?.isNotEmpty ?? false)
        ? outlet!.alamat!
        : (aktivitas?.apotikId?.alamat ?? '-');
    final telponOutlet = (outlet?.telponNumber?.isNotEmpty ?? false)
        ? outlet!.telponNumber!
        : (aktivitas?.apotikId?.telponNumber ?? '-');

    final hasTujuan =
        (aktivitas?.tujuanPengantaran ?? false) ||
        (aktivitas?.tujuanPenawaran ?? false) ||
        (aktivitas?.tujuanPenagihan ?? false);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimens.radiusMediumX),
        boxShadow: [
          BoxShadow(
            color: AppColors.labelSecondary.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: AppColors.labelSecondary.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppDimens.radiusMediumX),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimens.radiusMediumX),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.paddingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header: nama outlet + status chip ──
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            namaOutlet,
                            style: context.textStyle.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                              fontSize: 16,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (kodeOutlet != null && kodeOutlet.isNotEmpty) ...[
                            AppDimens.size2S.hSpace,
                            Text(
                              kodeOutlet,
                              style: context.textStyle.bodyMedium?.copyWith(
                                color: AppColors.labelSecondary,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: AppDimens.paddingMedium),
                    if (statusTask != null)
                      _buildStatusChip(context, statusTask),
                  ],
                ),

                // ── Badge Tujuan Kunjungan ──
                if (hasTujuan) ...[
                  AppDimens.size2S.hSpace,
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      if (aktivitas?.tujuanPengantaran ?? false)
                        _buildTujuanBadge(
                          context,
                          label: 'Pengantaran (DO)',
                          icon: Icons.local_shipping_outlined,
                          color: const Color(0xFF0EA5E9), // biru sky
                        ),
                      if (aktivitas?.tujuanPenawaran ?? false)
                        _buildTujuanBadge(
                          context,
                          label: 'Penawaran (SO)',
                          icon: Icons.shopping_cart_outlined,
                          color: const Color(0xFF22C55E), // hijau
                        ),
                      if (aktivitas?.tujuanPenagihan ?? false)
                        _buildTujuanBadge(
                          context,
                          label: 'Penagihan',
                          icon: Icons.credit_card_outlined,
                          color: AppColors.warning,
                        ),
                    ],
                  ),
                ],

                if (aktivitas?.isCompletedByOther ?? false) ...[
                  AppDimens.size2S.hSpace,
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E8FF),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: const Color(0xFFD8B4FE)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.supervisor_account_outlined,
                          size: 16,
                          color: Color(0xFF7E22CE),
                        ),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            'Dikerjakan oleh ${aktivitas?.completedByName ?? 'admin lain'}',
                            style: context.textStyle.bodySmall?.copyWith(
                              color: const Color(0xFF7E22CE),
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                AppDimens.size3M.hSpace,

                // Divider
                Container(
                  height: 1,
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),

                AppDimens.size3M.hSpace,

                // ── Detail Rows ──
                Column(
                  children: [
                    _buildDetailRow(
                      context,
                      'Kendaraan',
                      AppUtility.getTransportasi(task.inventaris) ?? '-',
                      Icons.directions_car,
                    ),
                    if (telponOutlet != '-') ...[
                      AppDimens.paddingMedium.hSpace,
                      _buildDetailRow(
                        context,
                        'No Telepon Outlet',
                        telponOutlet,
                        Icons.phone,
                      ),
                    ],
                    AppDimens.paddingMedium.hSpace,
                    _buildDetailRow(
                      context,
                      'Alamat Outlet',
                      alamatOutlet,
                      Icons.location_pin,
                      maxLines: 3,
                    ),
                    AppDimens.paddingMedium.hSpace,
                    _buildDetailRow(
                      context,
                      'Jarak Estimasi',
                      task
                              .countJarakFromAttendance
                              ?.toKilometer
                              ?.isEmptyStrip ??
                          '-',
                      Icons.route_rounded,
                      maxLines: 3,
                    ),
                    AppDimens.paddingMedium.hSpace,
                    _buildDetailRow(
                      context,
                      'Biaya Estimasi',
                      task.biayaActually?.toCurrency.isEmptyStrip ?? '-',
                      Icons.attach_money_rounded,
                      maxLines: 3,
                    ),

                    // No Referensi (DO / SO)
                    if ((aktivitas?.noReferensi?.isNotEmpty ?? false)) ...[
                      AppDimens.paddingMedium.hSpace,
                      _buildDetailRow(
                        context,
                        'No Referensi',
                        aktivitas!.noReferensi!.join(', '),
                        Icons.receipt_long_outlined,
                        maxLines: 2,
                      ),
                    ],

                    if ([
                      StatusTask.done,
                      StatusTask.cancel,
                    ].contains(statusTask)) ...[
                      AppDimens.paddingMedium.hSpace,
                      _buildDetailRow(
                        context,
                        'Catatan',
                        aktivitas?.note ?? '-',
                        Icons.edit_note,
                        maxLines: 3,
                      ),
                    ],
                  ],
                ),

                // ── Tombol Aksi ──
                if (isCancelableTask) ...[
                  AppDimens.size3M.hSpace,
                  Container(
                    height: 1,
                    color: AppColors.primary.withValues(alpha: 0.2),
                  ),
                  AppDimens.size3M.hSpace,
                  Row(
                    children: [
                      if (onCanceled != null)
                        Expanded(
                          flex: 2,
                          child: OutlinedButton(
                            onPressed: onCanceled,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.danger,
                              side: BorderSide(
                                color: AppColors.danger.withValues(alpha: 0.5),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: AppDimens.paddingMedium,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppDimens.radiusMedium,
                                ),
                              ),
                            ),
                            child: const Text(
                              'Batalkan',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      if (onCanceled != null && onTap != null)
                        AppDimens.size2M.wSpace,
                      if (onTap != null)
                        Expanded(
                          flex: 3,
                          child: ElevatedButton.icon(
                            onPressed: onTap,
                            icon: const Icon(
                              Icons.play_circle_outline,
                              size: 18,
                            ),
                            label: const Text(
                              'Kerjakan Kunjungan',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: AppDimens.paddingMedium,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppDimens.radiusMedium,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTujuanBadge(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.35), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, StatusTask statusTask) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.sizeM,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: (statusTask.toColor).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimens.size4M),
        border: Border.all(
          color: (statusTask.toColor).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Text(
        statusTask.toName,
        style: TextStyle(
          color: statusTask.toColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    int maxLines = 2,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 16, color: AppColors.primary),
        ),
        const SizedBox(width: AppDimens.paddingMedium),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.textStyle.bodySmall?.copyWith(
                  color: AppColors.labelSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: context.textStyle.bodyMedium?.copyWith(
                  color: AppColors.labelPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
