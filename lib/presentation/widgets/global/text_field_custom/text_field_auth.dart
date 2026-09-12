import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

class TextFieldAuth extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String title;
  final String hint;
  final bool enabled;
  final bool multiline;
  final TextInputType? inputType;
  final TextInputAction? inputAction;
  final String? suffixText;
  final String? Function(String?)? validator;
  final bool obscure;
  final Widget? suffix;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;

  const TextFieldAuth({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.title,
    required this.hint,
    this.enabled = true,
    this.multiline = false,
    this.inputType,
    this.inputAction,
    this.suffixText,
    this.validator,
    this.obscure = false,
    this.suffix,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) Text(title, textAlign: TextAlign.left),
        if (title.isNotEmpty) const SizedBox(height: AppDimens.size3S),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: inputType,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.grey.shade300, width: 1),
              borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: AppColors.secondary,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.red, width: 1.5),
              borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.red, width: 1.5),
              borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
            ),
            errorStyle: const TextStyle(color: AppColors.red),
            alignLabelWithHint: true,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            floatingLabelStyle: TextStyle(color: AppColors.labelSecondary),
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.grey.shade300),
            contentPadding: const EdgeInsets.all(AppDimens.paddingMedium),
            suffix: suffix,
          ),
          enabled: enabled,
          maxLines: multiline ? 4 : 1,
          textInputAction: inputAction,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: obscure,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
        ),
      ],
    );
  }
}
