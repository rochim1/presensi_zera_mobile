import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

class AppFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const AppFilterChip({
    super.key,
    required this.label,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.w16,
          vertical: AppDimens.h6,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(AppDimens.r24),
          border: isSelected
              ? null
              : Border.all(color: AppColors.neutralBorder, width: 1),
        ),
        child: Text(
          label,
          style: context.theme.textTheme.bodyMedium?.copyWith(
            color: isSelected ? AppColors.white : AppColors.labelSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
