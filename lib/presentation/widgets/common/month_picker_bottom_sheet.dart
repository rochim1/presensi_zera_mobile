import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

class MonthPickerBottomSheet extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onMonthSelected;

  const MonthPickerBottomSheet({
    super.key,
    required this.initialDate,
    required this.onMonthSelected,
  });

  static Future<void> show(
    BuildContext context, {
    required DateTime initialDate,
    required ValueChanged<DateTime> onMonthSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimens.radiusLarge),
        ),
      ),
      builder: (context) => MonthPickerBottomSheet(
        initialDate: initialDate,
        onMonthSelected: onMonthSelected,
      ),
    );
  }

  @override
  State<MonthPickerBottomSheet> createState() => _MonthPickerBottomSheetState();
}

class _MonthPickerBottomSheetState extends State<MonthPickerBottomSheet> {
  late int selectedYear;

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

  @override
  void initState() {
    super.initState();
    selectedYear = widget.initialDate.year;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppDimens.paddingLarge,
        right: AppDimens.paddingLarge,
        top: AppDimens.paddingLarge,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppDimens.paddingLarge,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => setState(() => selectedYear--),
              ),
              Text(
                selectedYear.toString(),
                style: context.textStyle.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () => setState(() => selectedYear++),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2.5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: 12,
            itemBuilder: (context, index) {
              final isSelected = selectedYear == widget.initialDate.year && (index + 1) == widget.initialDate.month;

              return OutlinedButton(
                onPressed: () {
                  final start = DateTime(selectedYear, index + 1, 1);
                  widget.onMonthSelected(start);
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: isSelected ? AppColors.primary : AppColors.labelPrimary,
                  backgroundColor: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : AppColors.dividerLight,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                  ),
                ),
                child: Text(
                  months[index],
                  style: context.textStyle.bodySmall?.copyWith(
                    color: isSelected ? AppColors.primary : AppColors.labelPrimary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
