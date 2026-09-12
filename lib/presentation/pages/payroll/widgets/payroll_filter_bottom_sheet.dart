import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/widgets/_widgets.dart';

class PayrollFilterBottomSheet extends StatefulWidget {
  final int? initialMonth;
  final int? initialYear;
  final Function(int? month, int? year) onApply;

  const PayrollFilterBottomSheet({
    super.key,
    this.initialMonth,
    this.initialYear,
    required this.onApply,
  });

  @override
  State<PayrollFilterBottomSheet> createState() =>
      _PayrollFilterBottomSheetState();
}

class _PayrollFilterBottomSheetState extends State<PayrollFilterBottomSheet> {
  int? _month;
  int? _year;

  @override
  void initState() {
    super.initState();
    _month = widget.initialMonth;
    _year = widget.initialYear;
  }

  Future<void> _selectMonth(BuildContext context) async {
    final now = DateTime.now();
    int selectedYear = _year ?? now.year;
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
                      final isSelected =
                          _month == (index + 1) && _year == selectedYear;
                      return OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _month = index + 1;
                            _year = selectedYear;
                          });
                          Navigator.pop(ctx);
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: isSelected
                              ? AppColors.primary.withValues(alpha: 0.1)
                              : Colors.transparent,
                          foregroundColor: isSelected
                              ? AppColors.primary
                              : AppColors.labelPrimary,
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.dividerLight,
                          ),
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
    final List<String> monthsStr = [
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
              'Filter Slip Gaji',
              style: context.textStyle.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.labelPrimary,
              ),
            ),
            AppDimens.paddingLarge.hSpace,
            Text(
              'Bulan',
              style: context.textStyle.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            AppDimens.paddingSmallX.hSpace,
            InkWell(
              onTap: () => _selectMonth(context),
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
                      (_month != null && _year != null)
                          ? '${monthsStr[_month! - 1]} $_year'
                          : 'Pilih Bulan & Tahun',
                      style: context.textStyle.bodyMedium?.copyWith(
                        color: (_month != null)
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
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _month = null;
                        _year = null;
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
                      widget.onApply(_month, _year);
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
