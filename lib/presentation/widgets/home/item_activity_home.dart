import 'package:flutter/material.dart';
import 'package:presensi_domain/presensi_domain.dart';

import '../../../core/_core.dart';

class ItemActivityHome extends StatelessWidget {
  final void Function() onTap;
  final AktivitasEntity activity;

  const ItemActivityHome({
    super.key,
    required this.onTap,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    final apotek = activity.apotikId;
    final statusTask = activity.statusTask?.toStatusTask;
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingMediumX,
        vertical: AppDimens.size2S,
      ),
      child: Material(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
          child: Container(
            padding: const EdgeInsets.all(AppDimens.paddingMediumX),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
              border: Border.all(color: AppColors.dividerLight, width: 1),
            ),
            child: Row(
              children: [
                // Store Icon
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.store_rounded,
                    size: AppDimens.size4M,
                    color: AppColors.primary,
                  ),
                ),

                AppDimens.size3M.wSpace,

                // Store Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        apotek?.namaApotik ?? '-',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textStyle.titleSmall!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.labelPrimary,
                        ),
                      ),
                      AppDimens.size2S.hSpace,
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimens.size2S,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.fillSecondary,
                              borderRadius: BorderRadius.circular(
                                AppDimens.radiusSmall,
                              ),
                            ),
                            child: Text(
                              'Kode',
                              style: context.textStyle.labelSmall!.copyWith(
                                color: AppColors.labelSecondary,
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          AppDimens.size2S.wSpace,
                          Expanded(
                            child: Text(
                              apotek?.kodeApotik ?? '-',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.textStyle.bodySmall!.copyWith(
                                color: AppColors.labelSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                AppDimens.sizeM.wSpace,

                // Status and Arrow
                if (statusTask != null) ...[
                  _buildStatusChip(context, statusTask),
                ] else
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColors.labelSecondary,
                    size: 16,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, StatusTask statusTask) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.size3S,
        vertical: 4,
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
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
