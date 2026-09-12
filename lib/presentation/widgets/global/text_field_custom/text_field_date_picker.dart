import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

class TextFieldDatePicker extends StatefulWidget {
  /// to use the [controller] please format to (DateTime ISO8601)
  ///
  /// normaly format text controller is `yMMMMd`
  ///
  /// please convert to `controller.text.toIso8601Server`
  final TextEditingController? controller;
  final String? title;
  final Color? colorTitle;
  final String hint;
  final bool enabled;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final void Function(String)? onChanged;
  final void Function(DateTime)? onDateChanged;
  final bool required;

  final String? Function(String?)? validator;

  const TextFieldDatePicker({
    super.key,
    required this.hint,
    this.title,
    this.colorTitle,
    required this.controller,
    this.enabled = true,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onChanged,
    this.validator,
    this.onDateChanged,
    this.required = false,
  });

  @override
  State<TextFieldDatePicker> createState() => _TextFieldDatePickerState();
}

class _TextFieldDatePickerState extends State<TextFieldDatePicker> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppDimens.size2S),
          child: RichText(
            text: TextSpan(
              text: widget.title ?? "",
              style: AppTextStyle.fieldLabel.copyWith(
                color: widget.colorTitle ?? AppColors.labelPrimary,
              ),
              children: [
                if (widget.required)
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
        AppDimens.size3S.hSpace,
        TextFormField(
          autocorrect: true,
          controller: widget.controller,
          onChanged: widget.onChanged,
          enabled: widget.enabled,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: widget.validator,
          decoration: InputDecoration(
            floatingLabelStyle: const TextStyle(color: AppColors.grey),
            hintText: widget.hint,
            contentPadding: const EdgeInsets.all(AppDimens.paddingMedium),
            enabledBorder: context.theme.inputDecorationTheme.enabledBorder,
            fillColor: !widget.enabled
                ? AppColors.grey.shade50
                : context.theme.inputDecorationTheme.fillColor,
            filled: context.theme.inputDecorationTheme.filled,
            disabledBorder: context.theme.inputDecorationTheme.disabledBorder,
            focusedBorder: context.theme.inputDecorationTheme.focusedBorder,
            prefixIcon: Icon(
              Icons.calendar_today,
              size: 18.0,
              color: AppColors.labelSecondary,
            ),
          ),
          readOnly: true,
          onTap: () async {
            if (widget.enabled) {
              DateTime? date = await showDatePicker(
                context: context,
                initialDate: widget.controller!.text.isNotEmpty
                    ? widget.controller!.text.toDateTime!
                    : DateTime.now(),
                firstDate: widget.firstDate ?? DateTime(1545),
                lastDate: widget.lastDate ?? DateTime.now(),
              );

              if (date != null) {
                widget.controller!.text = date.yMMMMd;

                if (widget.onDateChanged != null) {
                  widget.onDateChanged!(date);
                }
              } else {
                log('Date not selected');
              }
            }
          },
        ),
      ],
    );
  }
}
