import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_mobile/core/_core.dart';

class AppApprovalNavigationButton extends StatelessWidget {
  final bool showingApproval;
  final VoidCallback onTap;
  final String returnLabel;

  const AppApprovalNavigationButton({
    super.key,
    required this.showingApproval,
    required this.onTap,
    this.returnLabel = 'Pengajuan Saya',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: AppDimens.w8),
      child: Material(
        color: AppColors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppDimens.r12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimens.r12),
          child: Container(
            height: AppDimens.w40,
            padding: EdgeInsets.symmetric(horizontal: AppDimens.w12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimens.r12),
              border: Border.all(color: AppColors.white.withValues(alpha: 0.1)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  showingApproval
                      ? PhosphorIcons.listChecks
                      : PhosphorIcons.checkCircle,
                  color: AppColors.white,
                  size: AppDimens.iconSmall,
                ),
                SizedBox(width: AppDimens.w6),
                Text(
                  showingApproval ? returnLabel : 'Approval',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
