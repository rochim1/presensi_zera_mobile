import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/widgets/global/list_item_attachment.dart';
import 'app_input_label.dart';

class AppAttachmentField extends StatelessWidget {
  const AppAttachmentField({
    super.key,
    this.label,
    this.hintText,
    this.errorText,
    this.value,
    this.onTap,
    this.onDelete,
    this.suffixIcon,
    this.isRequired = false,
  });

  final String? label;
  final String? hintText;
  final String? errorText;
  final String? value;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final Widget? suffixIcon;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          AppInputLabel(label: label!, isRequired: isRequired),
          SizedBox(height: AppDimens.h4),
        ],
        if (value != null && value!.isNotEmpty) ...[
          ListItemAttachment(fileName: value!, onDelete: onDelete),
        ] else
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimens.radiusMediumX),
              boxShadow: [
                BoxShadow(
                  color: AppColors.grey.shade100,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(AppDimens.radiusMediumX),
              child: InputDecorator(
                decoration: InputDecoration(
                  errorText: errorText,
                  hintText: hintText,
                  hintStyle: context.theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.labelSecondary.withValues(alpha: 0.5),
                  ),
                  suffixIcon:
                      suffixIcon ??
                      Icon(Icons.attach_file, color: AppColors.labelSecondary),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingMediumX,
                    vertical: AppDimens.paddingMediumX,
                  ),
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimens.radiusMediumX,
                    ),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimens.radiusMediumX,
                    ),
                    borderSide: BorderSide(
                      color: AppColors.grey.shade200,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimens.radiusMediumX,
                    ),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimens.radiusMediumX,
                    ),
                    borderSide: const BorderSide(
                      color: AppColors.danger,
                      width: 2,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimens.radiusMediumX,
                    ),
                    borderSide: const BorderSide(
                      color: AppColors.danger,
                      width: 2,
                    ),
                  ),
                ),
                isEmpty: true,
                child: const SizedBox.shrink(),
              ),
            ),
          ),
      ],
    );
  }
}
