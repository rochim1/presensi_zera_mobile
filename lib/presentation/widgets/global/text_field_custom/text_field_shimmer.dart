import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

class TextFieldShimmer extends StatelessWidget {
  final String? title;
  final Color? colorTitle;

  const TextFieldShimmer({super.key, this.title, this.colorTitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(
            title!,
            textAlign: TextAlign.left,
            style: TextStyle(color: colorTitle ?? AppColors.labelPrimary),
          ),
        if (title != null) const SizedBox(height: AppDimens.size3S),
        ShimmerCustom(
          size: Size(context.width, AppDimens.size3XL),
          radius: AppDimens.radiusMedium,
        ),
      ],
    );
  }
}
