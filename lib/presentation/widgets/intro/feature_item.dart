import 'package:flutter/material.dart';

import '../../../core/themes/colors_theme.dart';
import '../../../core/themes/text_style_theme.dart';
import '../../../core/utils/dimens_util.dart';

class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const FeatureItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Simple icon container
        Container(
          padding: const EdgeInsets.all(AppDimens.paddingMedium),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
          ),
          child: Icon(icon, color: AppColors.primary, size: AppDimens.sizeL),
        ),
        const SizedBox(width: AppDimens.sizeL),
        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyle.fieldLabel.copyWith(
                  color: AppColors.labelPrimary,
                ),
              ),
              const SizedBox(height: AppDimens.size2S),
              Text(
                subtitle,
                style: AppTextStyle.fieldHint.copyWith(fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
