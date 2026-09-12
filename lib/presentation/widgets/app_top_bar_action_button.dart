import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

class AppTopBarActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final int? badgeCount;

  const AppTopBarActionButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.badgeCount,
  });

  String? formatBadge(int? count) {
    if (count == null || count <= 0) return null;
    return count > 99 ? '99+' : '$count';
  }

  @override
  Widget build(BuildContext context) {
    final String? badgeText = formatBadge(badgeCount);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Icon(icon, color: AppColors.white, size: 20),
          ),
          if (badgeText != null)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                decoration: BoxDecoration(
                  color: AppColors.danger,
                  borderRadius: BorderRadius.circular(AppDimens.r100),
                  border: Border.all(color: AppColors.primary, width: 1.5),
                ),
                child: Center(
                  child: Text(
                    badgeText,
                    style: context.textStyle.labelSmall!.copyWith(
                      color: AppColors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
