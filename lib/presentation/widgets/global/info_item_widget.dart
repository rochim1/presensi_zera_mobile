import 'package:presensi_mobile/l10n/hr_localization.dart';
import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

class InfoItemWidget extends StatelessWidget {
  final String title;
  final String value;

  const InfoItemWidget({super.key, required this.title, this.value = '-'});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HrText(
          title,
          style: context.textStyle.titleSmall?.copyWith(color: AppColors.grey),
        ),
        AppDimens.sizeS.hSpace,
        Text(value, style: context.textStyle.bodyLarge),
      ],
    );
  }
}
