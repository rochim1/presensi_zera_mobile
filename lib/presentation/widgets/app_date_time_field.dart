import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_mobile/core/_core.dart';

import 'app_input_label.dart';

enum AppDateTimeFieldMode { date, time, datetime }

class AppDateTimeField extends StatefulWidget {
  const AppDateTimeField({
    super.key,
    this.mode = AppDateTimeFieldMode.date,
    this.label,
    this.hintText,
    this.value,
    this.onConfirmed,
    this.errorText,
    this.isRequired = false,
    this.firstDate,
    this.lastDate,
    this.enabled = true,
  });

  final AppDateTimeFieldMode mode;
  final String? label;
  final String? hintText;
  final DateTime? value;
  final ValueChanged<DateTime>? onConfirmed;
  final String? errorText;
  final bool isRequired;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool enabled;

  @override
  State<AppDateTimeField> createState() => _AppDateTimeFieldState();
}

class _AppDateTimeFieldState extends State<AppDateTimeField> {
  void _showPicker(BuildContext context) async {
    DateTimePickerType pickerType;
    switch (widget.mode) {
      case AppDateTimeFieldMode.date:
        pickerType = DateTimePickerType.date;
        break;
      case AppDateTimeFieldMode.time:
        pickerType = DateTimePickerType.time;
        break;
      case AppDateTimeFieldMode.datetime:
        pickerType = DateTimePickerType.datetime;
        break;
    }

    final now = DateTime.now();
    final result = await showBoardDateTimePicker(
      context: context,
      pickerType: pickerType,
      initialDate: widget.value ?? now,
      minimumDate: widget.firstDate,
      maximumDate: widget.lastDate,
      useSafeArea: true,
      headerWidget: Padding(
        padding: EdgeInsets.only(top: AppDimens.h8),
        child: Container(
          width: AppDimens.w40,
          height: AppDimens.h4,
          decoration: BoxDecoration(
            color: AppColors.divider,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
      customCloseButtonBuilder: (context, isModal, onClose) => IconButton(
        onPressed: onClose,
        icon: Icon(
          PhosphorIcons.checkCircleBold,
          color: AppColors.primary,
        ),
      ),
      options: BoardDateTimeOptions(
        languages: const BoardPickerLanguages(locale: 'id'),
        boardTitle: widget.label ?? _getDefaultTitle(),
        showDateButton: false,
        calendarItemDecoration: (context, day, date, isSelected) =>
            BoxDecoration(
              color: isSelected
                  ? AppColors.primary
                  : AppColors.labelPrimary.withValues(alpha: 0.02),
              border: Border.all(
                width: 1,
                color: AppColors.labelPrimary.withValues(alpha: 0.1),
              ),
              shape: BoxShape.circle,
            ),
        calendarSelectionBuilder: (context, day, textStyle) => Text(
          day,
          style: context.theme.textTheme.titleSmall?.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        startDayOfWeek: 1,
        pickerFormat: PickerFormat.dmy,
        backgroundColor: context.theme.scaffoldBackgroundColor,
        foregroundColor: AppColors.primary.withValues(alpha: 0.1),
        activeColor: AppColors.primary,
        activeTextColor: AppColors.primary,
        textColor: AppColors.labelPrimary,
        pickerMonthFormat: PickerMonthFormat.long,
        inputable: true,
        useResetButton: true,
        pickerSubTitles: BoardDateTimeItemTitles(
          day: 'Tanggal',
          month: 'Bulan',
          year: 'Tahun',
          hour: 'Jam',
          minute: 'Menit',
        ),
        separators: BoardDateTimePickerSeparators(),
        boardTitleTextStyle: context.theme.textTheme.titleSmall?.copyWith(
          color: AppColors.primary,
        ),
      ),
    );

    if (result != null) {
      widget.onConfirmed?.call(result);
    }
  }

  String _getDefaultTitle() {
    switch (widget.mode) {
      case AppDateTimeFieldMode.date:
        return 'Pilih Tanggal';
      case AppDateTimeFieldMode.time:
        return 'Pilih Waktu';
      case AppDateTimeFieldMode.datetime:
        return 'Pilih Tanggal & Waktu';
    }
  }

  String _getFormattedValue() {
    if (widget.value == null) return '';

    switch (widget.mode) {
      case AppDateTimeFieldMode.date:
        return DateFormat('dd MMMM yyyy', 'id_ID').format(widget.value!);
      case AppDateTimeFieldMode.time:
        return DateFormat('HH:mm', 'id_ID').format(widget.value!);
      case AppDateTimeFieldMode.datetime:
        return DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(widget.value!);
    }
  }

  IconData _getSuffixIcon() {
    switch (widget.mode) {
      case AppDateTimeFieldMode.date:
      case AppDateTimeFieldMode.datetime:
        return Icons.calendar_today_outlined;
      case AppDateTimeFieldMode.time:
        return Icons.access_time_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String formattedValue = _getFormattedValue();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          AppInputLabel(label: widget.label!, isRequired: widget.isRequired),
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
          child: InkWell(
            onTap: widget.enabled ? () => _showPicker(context) : null,
            borderRadius: BorderRadius.circular(AppDimens.radiusMediumX),
            child: InputDecorator(
              decoration: InputDecoration(
                errorText: widget.errorText,
                hintText: widget.hintText,
                hintStyle: context.theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.labelSecondary.withValues(alpha: 0.5),
                ),
                suffixIcon: Icon(
                  _getSuffixIcon(),
                  size: 20,
                  color: AppColors.labelSecondary,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingMediumX,
                  vertical: AppDimens.paddingMediumX,
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
                  borderSide: const BorderSide(
                    color: AppColors.danger,
                    width: 2,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusMediumX),
                  borderSide: const BorderSide(
                    color: AppColors.danger,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                formattedValue.isEmpty
                    ? (widget.hintText ?? '')
                    : formattedValue,
                style: context.theme.textTheme.bodyMedium?.copyWith(
                  color: formattedValue.isEmpty
                      ? AppColors.labelSecondary.withValues(alpha: 0.5)
                      : AppColors.labelPrimary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
