import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

class TextFieldTimePicker extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final String hint;
  final bool enabled;
  final TimeOfDay? initialTime;
  final void Function(String)? onChanged;
  final bool use24HourFormat;

  final String? Function(String?)? validator;

  const TextFieldTimePicker({
    super.key,
    required this.hint,
    required this.title,
    required this.controller,
    this.enabled = true,
    this.initialTime,
    this.onChanged,
    this.validator,
    this.use24HourFormat = true,
  });

  @override
  State<TextFieldTimePicker> createState() => _TextFieldTimePickerState();
}

class _TextFieldTimePickerState extends State<TextFieldTimePicker> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, textAlign: TextAlign.left),
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
              Icons.access_time,
              size: 18.0,
              color: AppColors.labelSecondary,
            ),
          ),
          readOnly: true,
          onTap: () async {
            if (widget.enabled) {
              TimeOfDay? time = await showTimePicker(
                context: context,
                initialTime: widget.initialTime ?? TimeOfDay.now(),
                builder: (BuildContext context, Widget? child) {
                  return MediaQuery(
                    data: MediaQuery.of(
                      context,
                    ).copyWith(alwaysUse24HourFormat: widget.use24HourFormat),
                    child: child ?? const SizedBox.shrink(),
                  );
                },
              );

              if (time != null) {
                // Format time as HH:mm
                final hour = time.hour.toString().padLeft(2, '0');
                final minute = time.minute.toString().padLeft(2, '0');
                widget.controller.text = '$hour:$minute';
                widget.onChanged != null
                    ? widget.onChanged!('$hour:$minute')
                    : null;
              } else {
                log('Time not selected');
                widget.onChanged != null ? widget.onChanged!('') : null;
              }
            }
          },
        ),
      ],
    );
  }
}
