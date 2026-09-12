import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:presensi_mobile/core/_core.dart';

import 'app_input_label.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.label,
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.onChanged,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.controller,
    this.initialValue,
    this.isRequired = false,
    this.maxLines = 1,
    this.enabled = true,
    this.readOnly = false,
    this.inputFormatters,
  });

  final String? label;
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;
  final String? initialValue;
  final Iterable<String>? autofillHints;
  final bool isRequired;
  final int maxLines;
  final bool enabled;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          AppInputLabel(label: label!, isRequired: isRequired),
          SizedBox(height: AppDimens.h4),
        ],
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
          child: TextFormField(
            controller: controller,
            initialValue: controller == null ? initialValue : null,
            onChanged: onChanged,
            enabled: enabled,
            readOnly: readOnly,
            obscureText: obscureText,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            autofillHints: autofillHints,
            maxLines: maxLines,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              errorText: errorText,
              hintText: hintText,
              hintStyle: context.theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.labelSecondary.withValues(alpha: 0.5),
              ),
              suffixIcon: suffixIcon,
              filled: true,
              fillColor: AppColors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimens.radiusMediumX),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimens.radiusMediumX),
                borderSide: BorderSide(
                  color: AppColors.grey.shade200,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimens.radiusMediumX),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimens.radiusMediumX),
                borderSide: const BorderSide(color: AppColors.danger, width: 2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimens.radiusMediumX),
                borderSide: const BorderSide(color: AppColors.danger, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppDimens.paddingMediumX,
                vertical: AppDimens.paddingMediumX,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
