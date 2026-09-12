import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

/// for implement icon close on AppDialog.detail
class IconCloseButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? color;

  const IconCloseButton({super.key, this.onPressed, this.color});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: AppDimens.size3M,
      top: AppDimens.size3M,
      child: IconButton(
        onPressed: () => onPressed!.call(),
        icon: const Icon(Icons.close),
        color: color ?? AppColors.labelSecondary,
        splashRadius: AppDimens.size2M,
        iconSize: AppDimens.sizeL,
        padding: EdgeInsets.zero,
      ),
    );
  }
}
