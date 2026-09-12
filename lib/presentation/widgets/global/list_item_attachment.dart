import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

class ListItemAttachment extends StatelessWidget {
  final String fileName;
  final Color? fillColor;
  final Function()? onDelete;

  const ListItemAttachment({
    super.key,
    required this.fileName,
    this.fillColor,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppDimens.paddingMedium,
        right: onDelete != null ? AppDimens.sizeZero : AppDimens.paddingMedium,
        top: onDelete != null ? AppDimens.sizeZero : AppDimens.paddingMedium,
        bottom: onDelete != null ? AppDimens.sizeZero : AppDimens.paddingMedium,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: context
              .theme
              .inputDecorationTheme
              .enabledBorder!
              .borderSide
              .color,
          width: context
              .theme
              .inputDecorationTheme
              .enabledBorder!
              .borderSide
              .width,
        ),
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        color: fillColor ?? context.theme.inputDecorationTheme.fillColor,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.file_present_rounded,
            size: AppDimens.sizeL,
            color: AppColors.primary,
          ),
          AppDimens.size3S.wSpace,
          Expanded(
            child: Text(
              fileName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.theme.inputDecorationTheme.labelStyle!.copyWith(
                fontSize: AppDimens.size3M,
              ),
            ),
          ),
          if (onDelete != null)
            IconButton(
              onPressed: onDelete,
              icon: Icon(Icons.cancel_rounded, color: AppColors.labelSecondary),
              splashRadius: 0.5,
            ),
        ],
      ),
    );
  }
}
