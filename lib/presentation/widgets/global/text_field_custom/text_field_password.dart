import 'package:flutter/material.dart';

import '../../../../core/_core.dart';

class TextFieldPassword extends StatefulWidget {
  final TextEditingController? controller;
  final String? title;
  final String hint;
  final bool enabled;
  final bool multiline;
  final String? initialValue;
  final TextInputAction? inputAction;
  final String? suffixText;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final int? maxLength;
  final String? errorText;
  final Color? colorTitle;
  final bool? hasPrefixIcon;
  final Iterable<String>? autofillHints;

  const TextFieldPassword({
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
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.errorText,
    this.maxLength = 225,
    this.colorTitle,
    this.hasPrefixIcon = true,
    this.autofillHints,
  });

  @override
  State<TextFieldPassword> createState() => _TextFieldPasswordState();
}

class _TextFieldPasswordState extends State<TextFieldPassword> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title label
        if (widget.title != null)
          Padding(
            padding: const EdgeInsets.only(left: AppDimens.size2S),
            child: Text(
              widget.title!,
              style: AppTextStyle.fieldLabel.copyWith(
                color: widget.colorTitle ?? AppColors.labelPrimary,
              ),
            ),
          ),
        if (widget.title != null) const SizedBox(height: AppDimens.size3S),

        // Password field
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
            controller: widget.controller,
            focusNode: widget.focusNode,
            initialValue: widget.initialValue,
            keyboardType: TextInputType.visiblePassword,
            style: AppTextStyle.fieldInput,
            autofillHints: widget.autofillHints,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: AppTextStyle.fieldHint,
              prefixIcon: widget.hasPrefixIcon!
                  ? Container(
                      padding: const EdgeInsets.all(AppDimens.paddingMedium),
                      child: const Icon(
                        Icons.lock_outline_rounded,
                        size: AppDimens.sizeL,
                      ),
                    )
                  : null,
              suffixIcon: IconButton(
                onPressed: () => setState(() => _isVisible = !_isVisible),
                icon: Icon(
                  _isVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                splashRadius: 20,
              ),
              filled: true,
              fillColor: widget.enabled
                  ? AppColors.white
                  : AppColors.grey.shade50,
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
                borderSide: const BorderSide(color: AppColors.red, width: 2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimens.radiusMediumX),
                borderSide: const BorderSide(color: AppColors.red, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppDimens.paddingMediumX,
                vertical: AppDimens.paddingMediumX,
              ),
              errorStyle: AppTextStyle.fieldError,
            ),
            enabled: widget.enabled,
            maxLines: widget.multiline ? 4 : 1,
            textInputAction: widget.inputAction,
            validator: widget.validator,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            obscureText: _isVisible,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onSubmitted,
          ),
        ),
      ],
    );
  }
}
