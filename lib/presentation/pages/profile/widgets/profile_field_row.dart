import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

class ProfileFieldRow extends StatelessWidget {
  final String title;
  final String value;

  const ProfileFieldRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: context.textStyle.bodyMedium?.copyWith(
                color: AppColors.labelSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            ' :  ',
            style: context.textStyle.bodyMedium?.copyWith(
              color: AppColors.labelSecondary,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: context.textStyle.bodyMedium?.copyWith(
                color: AppColors.labelPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
