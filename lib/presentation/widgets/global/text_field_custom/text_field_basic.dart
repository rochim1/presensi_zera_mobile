import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/_core.dart';

class TextFieldBasic extends StatelessWidget {
  final TextEditingController? controller;
  final String? title;
  final String hint;
  final bool enabled;
  final bool multiline;
  final String? initialValue;
  final TextInputType? inputType;
  final TextInputAction? inputAction;
  final String? suffixText;
  final String? Function(String?)? validator;
  final bool obscure;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final int? maxLength;
  final String? errorText;
  final Color? colorTitle;
  final TextStyle? style;
  final InputDecoration? decoration;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final bool? autofocus;
  final Iterable<String>? autofillHints;
  final bool required;

  const TextFieldBasic({
    super.key,
    this.title,
    required this.hint,
    this.controller,
    this.enabled = true,
    this.multiline = false,
    this.initialValue,
    this.inputType,
    this.inputAction,
    this.suffixText,
    this.validator,
    this.obscure = false,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.errorText,
    this.colorTitle,
    this.decoration,
    this.style,
    this.inputFormatters,
    this.maxLength = 225,
    this.prefixIcon,
    this.autofocus = false,
    this.autofillHints,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title label
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(left: AppDimens.size2S),
            child: RichText(
              text: TextSpan(
                text: title!,
                style: AppTextStyle.fieldLabel.copyWith(
                  color: colorTitle ?? AppColors.labelPrimary,
                ),
                children: [
                  if (required)
                    TextSpan(
                      text: ' *',
                      style: AppTextStyle.fieldLabel.copyWith(
                        color: AppColors.red,
                      ),
                    ),
                ],
              ),
            ),
          ),
        if (title != null) const SizedBox(height: AppDimens.size3S),

        // Text field
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
            focusNode: focusNode,
            initialValue: initialValue,
            keyboardType: inputType,
            style: style ?? AppTextStyle.fieldInput,
            autofillHints: autofillHints,
            decoration:
                decoration ??
                InputDecoration(
                  hintText: hint,
                  hintStyle: AppTextStyle.fieldHint,
                  suffixText: suffixText,
                  errorText: errorText,
                  prefixIcon: prefixIcon != null
                      ? Container(
                          padding: const EdgeInsets.all(
                            AppDimens.paddingMedium,
                          ),
                          child: prefixIcon,
                        )
                      : null,
                  filled: true,
                  fillColor: enabled ? AppColors.white : AppColors.grey.shade50,
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
                      color: AppColors.red,
                      width: 2,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimens.radiusMediumX,
                    ),
                    borderSide: const BorderSide(
                      color: AppColors.red,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingMediumX,
                    vertical: AppDimens.paddingMediumX,
                  ),
                  errorStyle: AppTextStyle.fieldError,
                ),
            enabled: enabled,
            maxLines: multiline ? 3 : 1,
            textInputAction: inputAction,
            validator: validator,
            autofocus: autofocus!,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            obscureText: obscure,
            onChanged: onChanged,
            onFieldSubmitted: onSubmitted,
            inputFormatters: [
              LengthLimitingTextInputFormatter(maxLength),
              ...inputFormatters ?? [],
            ],
          ),
        ),
      ],
    );
  }
}
