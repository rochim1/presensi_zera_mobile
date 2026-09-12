import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

class TextFieldEmail extends StatelessWidget {
  final TextEditingController? controller;
  final String? title;
  final String hint;
  final bool enabled;
  final bool multiline;
  final String? initialValue;
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

  const TextFieldEmail({
    super.key,
    this.title,
    required this.hint,
    this.controller,
    this.enabled = true,
    this.multiline = false,
    this.initialValue,
    this.inputAction,
    this.suffixText,
    this.validator,
    this.obscure = false,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.errorText,
    this.maxLength = 225,
    this.colorTitle,
  });

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
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          initialValue: initialValue,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(
              Icons.person_outline_rounded,
              size: AppDimens.sizeL,
              color: AppColors.labelSecondary,
            ),
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
