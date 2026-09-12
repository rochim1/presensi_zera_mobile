import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/widgets/_widgets.dart';

class OvertimeFilterBottomSheet extends StatefulWidget {
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final String? initialStatus;
  final Function(DateTime? start, DateTime? end, String? status) onApply;

  const OvertimeFilterBottomSheet({
    super.key,
    this.initialStartDate,
    this.initialEndDate,
    this.initialStatus,
    required this.onApply,
  });

  @override
  State<OvertimeFilterBottomSheet> createState() =>
      _OvertimeFilterBottomSheetState();
}

class _OvertimeFilterBottomSheetState extends State<OvertimeFilterBottomSheet> {
  DateTime? _startDate;
  DateTime? _endDate;
  String? _status;

  final List<String> _statusOptions = [
    'Semua',
    'diajukan',
    'diterima',
    'ditolak',
  ];

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;
    _status = widget.initialStatus ?? 'Semua';
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

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  Future<void> _selectMonth(BuildContext context) async {
    final now = DateTime.now();
    int selectedYear = _startDate?.year ?? now.year;
    final List<String> months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimens.radiusLarge),
        ),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Container(
              padding: const EdgeInsets.all(AppDimens.paddingLarge),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: () => setModalState(() => selectedYear--),
                      ),
                      Text(
                        selectedYear.toString(),
                        style: context.textStyle.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: () => setModalState(() => selectedYear++),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 2.5,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                    itemCount: 12,
                    itemBuilder: (context, index) {
                      return OutlinedButton(
                        onPressed: () {
                          final start = DateTime(selectedYear, index + 1, 1);
                          final end = DateTime(
                            selectedYear,
                            index + 2,
                            0,
                          ); // last day of month
                          setState(() {
                            _startDate = start;
                            _endDate = end;
                          });
                          Navigator.pop(ctx);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.labelPrimary,
                          side: const BorderSide(color: AppColors.dividerLight),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimens.radiusMedium,
                            ),
                          ),
                        ),
                        child: Text(
                          months[index],
                          style: context.textStyle.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                margin: const EdgeInsets.only(bottom: AppDimens.paddingMediumX),
                decoration: BoxDecoration(
                  color: AppColors.dividerLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            Text(
              'Filter Lembur',
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
                Text(
                  'Rentang Waktu',
                  style: context.textStyle.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () => _selectMonth(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 0,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                    Text(
                      (_startDate != null && _endDate != null)
                          ? '${DateFormat('dd MMM yyyy').format(_startDate!)} - ${DateFormat('dd MMM yyyy').format(_endDate!)}'
                          : 'Pilih Rentang Waktu',
                      style: context.textStyle.bodyMedium?.copyWith(
                        color: (_startDate != null)
                            ? AppColors.labelPrimary
                            : AppColors.labelSecondary,
                      ),
                    ),
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

            // Status
            Text(
              'Status',
              style: context.textStyle.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            AppDimens.paddingSmallX.hSpace,
            Wrap(
              spacing: 8.0,
              children: _statusOptions.map((status) {
                final isSelected = _status == status;
                return ChoiceChip(
                  label: Text(
                    status == 'Semua'
                        ? 'Semua'
                        : status[0].toUpperCase() + status.substring(1),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _status = status);
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
            AppDimens.paddingMediumX.hSpace,

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _startDate = null;
                        _endDate = null;
                        _status = 'Semua';
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
                        _status == 'Semua' ? null : _status,
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
    );
  }
}
