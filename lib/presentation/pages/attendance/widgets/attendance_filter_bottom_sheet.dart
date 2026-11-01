import 'package:presensi_mobile/presentation/widgets/common/month_picker_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/widgets/_widgets.dart';

class AttendanceFilterBottomSheet extends StatefulWidget {
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final String? initialTypePresensi;
  final String? initialSearchName;
  final bool showSearchName;
  final Function(DateTime? start, DateTime? end, String? type, String? name)
  onApply;

  const AttendanceFilterBottomSheet({
    super.key,
    this.initialStartDate,
    this.initialEndDate,
    this.initialTypePresensi,
    this.initialSearchName,
    this.showSearchName = true,
    required this.onApply,
  });

  @override
  State<AttendanceFilterBottomSheet> createState() =>
      _AttendanceFilterBottomSheetState();
}

class _AttendanceFilterBottomSheetState
    extends State<AttendanceFilterBottomSheet> {
  DateTime? _startDate;
  DateTime? _endDate;
  String? _typePresensi;
  late TextEditingController _searchController;

  final List<String> _typeOptions = ['Semua', 'reguler', 'shift', 'oncall'];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startDate = widget.initialStartDate ?? DateTime(now.year, now.month, 1);
    _endDate = widget.initialEndDate ?? DateTime(now.year, now.month + 1, 0);
    _typePresensi = widget.initialTypePresensi ?? 'Semua';
    _searchController = TextEditingController(text: widget.initialSearchName);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: (_startDate != null && _endDate != null)
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.labelPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (!mounted) return;
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  Future<void> _selectMonth(BuildContext context) async {
    await MonthPickerBottomSheet.show(
      context,
      initialDate: _startDate ?? DateTime.now(),
      onMonthSelected: (month) {
        if (!mounted) return;
        setState(() {
          _startDate = DateTime(month.year, month.month, 1);
          _endDate = DateTime(month.year, month.month + 1, 0);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.9,
        ),
        padding: EdgeInsets.only(
          left: AppDimens.paddingMediumX,
          right: AppDimens.paddingMediumX,
          top: AppDimens.paddingMediumX,
          bottom:
              MediaQuery.of(context).viewInsets.bottom + AppDimens.paddingLarge,
        ),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimens.radiusLarge),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Indicator
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(
                    bottom: AppDimens.paddingMediumX,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.dividerLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              Text(
                'Filter Presensi',
                style: context.textStyle.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.labelPrimary,
                ),
              ),
              AppDimens.paddingLarge.hSpace,

              // Rentang Waktu
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Rentang Waktu',
                      style: context.textStyle.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => _selectMonth(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 0,
                      ),
                      minimumSize: const Size(48, 48),
                    ),
                    child: Text(
                      'Pilih Bulan',
                      style: context.textStyle.bodyMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              AppDimens.paddingSmallX.hSpace,
              InkWell(
                onTap: () => _selectDateRange(context),
                borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.dividerLight),
                    borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          (_startDate != null && _endDate != null)
                              ? '${DateFormat('dd MMM yyyy').format(_startDate!)} - ${DateFormat('dd MMM yyyy').format(_endDate!)}'
                              : 'Pilih Rentang Waktu',
                          style: context.textStyle.bodyMedium?.copyWith(
                            color: (_startDate != null)
                                ? AppColors.labelPrimary
                                : AppColors.labelSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.date_range,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              AppDimens.paddingLarge.hSpace,

              // Tipe Presensi
              Text(
                'Tipe Presensi',
                style: context.textStyle.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              AppDimens.paddingSmallX.hSpace,
              Wrap(
                spacing: 8.0,
                runSpacing: 8,
                children: _typeOptions.map((type) {
                  final isSelected = _typePresensi == type;
                  return ChoiceChip(
                    label: Text(
                      type == 'oncall'
                          ? 'On Call'
                          : type == 'Semua'
                          ? 'Semua'
                          : type[0].toUpperCase() + type.substring(1),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _typePresensi = type);
                      }
                    },
                    selectedColor: AppColors.primary.withValues(alpha: 0.1),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.labelSecondary,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                    backgroundColor: AppColors.white,
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.dividerLight,
                    ),
                  );
                }).toList(),
              ),
              AppDimens.paddingLarge.hSpace,

              // Cari Nama
              if (widget.showSearchName) ...[
                Text(
                  'Cari Nama Pegawai',
                  style: context.textStyle.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AppDimens.paddingSmallX.hSpace,
                TextFieldBasic(
                  controller: _searchController,
                  hint: 'Masukkan nama...',
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.labelSecondary,
                  ),
                ),
                AppDimens.paddingLarge.hSpace,
              ],
              AppDimens.paddingMediumX.hSpace,

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          final now = DateTime.now();
                          _startDate = DateTime(now.year, now.month, 1);
                          _endDate = DateTime(now.year, now.month + 1, 0);
                          _typePresensi = 'Semua';
                          _searchController.clear();
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimens.radiusMediumX,
                          ),
                        ),
                      ),
                      child: Text(
                        'Reset',
                        style: context.textStyle.bodyLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  AppDimens.w16.wSpace,
                  Expanded(
                    child: AppButton(
                      onPressed: () {
                        Navigator.pop(context);
                        widget.onApply(
                          _startDate,
                          _endDate,
                          _typePresensi == 'Semua' ? null : _typePresensi,
                          !widget.showSearchName ||
                                  _searchController.text.trim().isEmpty
                              ? null
                              : _searchController.text.trim(),
                        );
                      },
                      text: 'Terapkan',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
