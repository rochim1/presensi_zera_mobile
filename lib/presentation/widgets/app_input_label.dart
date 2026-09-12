import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

class AppInputLabel extends StatelessWidget {
  const AppInputLabel({
    super.key,
    required this.label,
    this.isRequired = false,
  });

  final String label;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: label,
        style: context.theme.textTheme.labelLarge?.copyWith(
          color: AppColors.labelSecondary,
          fontWeight: FontWeight.w500,
        ),
        children: [
          if (isRequired)
            TextSpan(
              text: ' *',
              style: context.theme.textTheme.labelLarge?.copyWith(
                color: AppColors.danger,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}
