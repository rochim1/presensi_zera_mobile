import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:presensi_mobile/core/_core.dart';

class TextFieldRadio extends StatefulWidget {
  final String title;
  final int? initialValue;
  final List<String> contentValue;
  final Function(int? value)? onChanged;
  final Color? colorTitle;
  final bool? leftFlex;
  final bool? enabled;
  final bool? isRequired;

  const TextFieldRadio({
    super.key,
    required this.title,
    this.initialValue,
    required this.contentValue,
    this.onChanged,
    this.colorTitle,
    this.enabled = true,
    this.leftFlex = false,
    this.isRequired = false,
  });

  @override
  State<TextFieldRadio> createState() => _TextFieldRadioState();
}

class _TextFieldRadioState extends State<TextFieldRadio> {
  late int _selectedValue = 3;
  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _selectedValue = widget.initialValue!;
    }
  }

  void _handleChangeValue(int? value) {
    if (widget.onChanged != null) {
      setState(() {
        widget.onChanged!(value!);
        _selectedValue = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !widget.enabled!,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: AppDimens.size2S),
              child: RichText(
                text: TextSpan(
                  text: widget.title,
                  style: context.textStyle.bodySmall?.copyWith(
                    color: widget.colorTitle ?? AppColors.labelPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    if (widget.isRequired == true)
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
          ),
          const SizedBox(height: AppDimens.size3S),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                flex: widget.leftFlex! ? 2 : 1,
                child: RadioButton<int>(
                  description: widget.contentValue.first,
                  value: 0,
                  groupValue: _selectedValue,
                  onChanged: _handleChangeValue,
                  textStyle: context.theme.inputDecorationTheme.labelStyle!
                      .copyWith(
                        fontSize: AppDimens.size2M,
                        color: _selectedValue == 0
                            ? AppColors.labelPrimary.withValues(alpha: 0.8)
                            : AppColors.labelSecondary,
                      ),
                ),
              ),
              Flexible(
                child: RadioButton<int>(
                  description: widget.contentValue.last,
                  value: 1,
                  groupValue: _selectedValue,
                  onChanged: _handleChangeValue,
                  textStyle: context.theme.inputDecorationTheme.labelStyle!
                      .copyWith(
                        fontSize: AppDimens.size2M,
                        color: _selectedValue == 0
                            ? AppColors.labelPrimary.withValues(alpha: 0.8)
                            : AppColors.labelSecondary,
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
