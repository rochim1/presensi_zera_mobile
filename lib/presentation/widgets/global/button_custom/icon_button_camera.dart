import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

class IconBottomCamera extends StatelessWidget {
  final bool? isTakingPicture;
  final void Function()? onCapture;
  final void Function()? onSave;
  final void Function()? onClose;

  const IconBottomCamera({
    super.key,
    this.isTakingPicture = false,
    this.onCapture,
    this.onSave,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry? border() {
      if (isTakingPicture!) return BorderRadius.circular(AppDimens.sizeXL);
      return null;
    }

    BoxShape shape() {
      if (!isTakingPicture!) return BoxShape.circle;
      return BoxShape.rectangle;
    }

    double? width() {
      if (!isTakingPicture!) return AppDimens.size2XL;
      return null;
    }

    Widget? child() {
      if (isTakingPicture!) {
        return Row(
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              splashRadius: AppDimens.sizeL,
              color: AppColors.bgPrimaryDark,
              icon: const Icon(Icons.close),
              onPressed: onClose,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppDimens.size3S),
              child: VerticalDivider(
                color: AppColors.bgPrimaryDark,
                width: AppDimens.size2S,
              ),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              splashRadius: AppDimens.sizeL,
              color: AppColors.bgPrimaryDark,
              icon: const Icon(Icons.check),
              onPressed: onSave,
            ),
          ],
        );
      }
      return null;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(AppDimens.sizeXL),
      onTap: isTakingPicture! ? null : onCapture,
      child: Container(
        padding: isTakingPicture!
            ? EdgeInsets.zero
            : const EdgeInsets.all(AppDimens.paddingSmall),
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: shape(),
          borderRadius: border(),
        ),
        alignment: Alignment.center,
        child: Container(
          width: width(),
          height: isTakingPicture! ? AppDimens.size3XL : AppDimens.size2XL,
          decoration: BoxDecoration(
            color: AppColors.white,
            shape: shape(),
            borderRadius: border(),
            border: isTakingPicture!
                ? null
                : Border.all(
                    color: AppColors.bgPrimaryDark,
                    width: AppDimens.sizeS,
                  ),
          ),
          child: child(),
        ),
      ),
    );
  }
}
