import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

class AppFlatSheetAction {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const AppFlatSheetAction({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });
}

class AppFlatSheetActions extends StatelessWidget {
  final List<AppFlatSheetAction> actions;

  const AppFlatSheetActions({super.key, required this.actions});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppDimens.w8,
      children: actions
          .map((action) => Expanded(child: _ActionItem(action: action)))
          .toList(),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final AppFlatSheetAction action;

  const _ActionItem({required this.action});

  @override
  Widget build(BuildContext context) {
    final effectiveColor = action.onTap == null
        ? AppColors.labelSecondary.withValues(alpha: 0.35)
        : action.color;
    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.r10),
        side: BorderSide(color: AppColors.dividerLight),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: action.onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppDimens.h12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                action.icon,
                size: AppDimens.iconSmall,
                color: effectiveColor,
              ),
              SizedBox(width: AppDimens.w6),
              Flexible(
                child: Text(
                  action.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyle.bodyMedium?.copyWith(
                    color: effectiveColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
