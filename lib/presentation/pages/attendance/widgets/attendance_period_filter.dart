import 'package:presensi_mobile/l10n/app_language_controller.dart';
import 'package:presensi_mobile/l10n/hr_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/widgets/common/month_picker_bottom_sheet.dart';
import 'attendance_filter_bottom_sheet.dart';

/// Month-first filter shared by personal/team attendance; modal needs no router.
class AttendancePeriodFilter extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? type;
  final String? searchName;
  final bool showSearchName;
  final void Function(DateTime?, DateTime?, String?, String?) onApply;
  const AttendancePeriodFilter({
    super.key,
    this.startDate,
    this.endDate,
    this.type,
    this.searchName,
    required this.showSearchName,
    required this.onApply,
  });

  String get summary {
    final start = startDate;
    final end = endDate;
    final fullMonth =
        start != null &&
        end != null &&
        start.day == 1 &&
        start.year == end.year &&
        start.month == end.month &&
        end.day == DateTime(start.year, start.month + 1, 0).day;
    final period = start == null || end == null
        ? 'Bulan Ini'
        : fullMonth
        ? DateFormat(
            'MMMM yyyy',
            AppLanguageController.instance.effectiveLocale.languageCode,
          ).format(start)
        : '${DateFormat('dd MMM yyyy', AppLanguageController.instance.effectiveLocale.languageCode).format(start)} – ${DateFormat('dd MMM yyyy', AppLanguageController.instance.effectiveLocale.languageCode).format(end)}';
    return [
      period,
      if (type?.isNotEmpty == true)
        type == 'oncall'
            ? 'On Call'
            : '${type![0].toUpperCase()}${type!.substring(1)}',
      if (showSearchName && searchName?.isNotEmpty == true) searchName!,
    ].join(' · ');
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Material(
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.dividerLight),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => MonthPickerBottomSheet.show(
                context,
                initialDate: startDate ?? DateTime.now(),
                onMonthSelected: (month) => onApply(
                  DateTime(month.year, month.month, 1),
                  DateTime(month.year, month.month + 1, 0),
                  type,
                  showSearchName ? searchName : null,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.date_range,
                      size: 20,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: HrText(
                        summary,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.labelPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: AppColors.labelSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(width: 1, height: 24, color: AppColors.divider),
          IconButton(
            tooltip: ('Filter presensi lainnya').tr(context),
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: const Icon(Icons.tune, size: 20, color: AppColors.primary),
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => AttendanceFilterBottomSheet(
                initialStartDate: startDate,
                initialEndDate: endDate,
                initialTypePresensi: type,
                initialSearchName: showSearchName ? searchName : null,
                showSearchName: showSearchName,
                onApply: onApply,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
