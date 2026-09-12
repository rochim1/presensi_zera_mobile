import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

class AppBottomSheetTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const AppBottomSheetTitle({
    super.key,
    required this.title,
    this.subtitle = 'Informasi lengkap pengajuan',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        SizedBox(height: AppDimens.h2),
        Text(
          subtitle,
          style: context.textStyle.bodySmall?.copyWith(
            color: AppColors.labelSecondary,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
