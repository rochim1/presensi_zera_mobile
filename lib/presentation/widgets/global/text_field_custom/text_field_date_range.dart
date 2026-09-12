import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

class TextFieldDateRage extends StatefulWidget {
  /// default format '12 jan 2023 - 23 Apr 2023'
  /// please convert to [DateTimeRange] use toDateTimeRange
  final TextEditingController? controller;
  final String? title;
  final Color? colorTitle;
  final String hint;
  final bool? enabled;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final void Function(String)? onChanged;

  final String? Function(String?)? validator;
  final bool required;

  const TextFieldDateRage({
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
    this.required = false,
  });

  @override
  State<TextFieldDateRage> createState() => _TextFieldDateRageState();
}

class _TextFieldDateRageState extends State<TextFieldDateRage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: AppDimens.size2S),
            child: RichText(
              text: TextSpan(
                text: widget.title!,
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
        ],
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
            fillColor: context.theme.inputDecorationTheme.fillColor,
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
            if (widget.enabled!) {
              DateTimeRange? date = await showDateRangePicker(
                context: context,
                initialDateRange: widget.controller!.text.isNotEmpty
                    ? widget.controller!.text.toDateTimeRange
                    : null,
                firstDate: widget.firstDate ?? DateTime(1545),
                lastDate: widget.lastDate ?? DateTime.now(),
                locale: AppUtility.locale,
              );

              if (date != null) {
                widget.controller!.text = date.fromDateTimeRange;
              } else {
                log('Date range not selected');
              }
            }
          },
        ),
      ],
    );
  }
}
