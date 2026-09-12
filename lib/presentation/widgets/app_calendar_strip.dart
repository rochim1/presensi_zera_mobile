import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:presensi_mobile/core/_core.dart';

enum AppCalendarStripMode { day, month, year }

class AppCalendarStrip extends StatefulWidget {
  const AppCalendarStrip({
    super.key,
    this.mode = AppCalendarStripMode.day,
    this.selectedDate,
    this.onChanged,
    this.startDate,
    this.endDate,
  });

  final AppCalendarStripMode mode;
  final DateTime? selectedDate;
  final ValueChanged<DateTime>? onChanged;
  final DateTime? startDate;
  final DateTime? endDate;

  @override
  State<AppCalendarStrip> createState() => _AppCalendarStripState();
}

class _AppCalendarStripState extends State<AppCalendarStrip> {
  late DateTime _selectedDate;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate ?? DateTime.now();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelected() {
    final items = _buildItems();
    final selectedIndex = items.indexWhere(_isItemSelected);
    if (selectedIndex == -1) return;
    final itemWidth = _itemWidth + 8; // item width + gap
    final offset = (selectedIndex * itemWidth) - 100;
    _scrollController.animateTo(
      offset.clamp(0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  double get _itemWidth {
    switch (widget.mode) {
      case AppCalendarStripMode.day:
        return 48;
      case AppCalendarStripMode.month:
        return 64;
      case AppCalendarStripMode.year:
        return 72;
    }
  }

  List<DateTime> _buildItems() {
    final start =
        widget.startDate ?? DateTime.now().subtract(const Duration(days: 30));
    final end = widget.endDate ?? DateTime.now().add(const Duration(days: 30));

    switch (widget.mode) {
      case AppCalendarStripMode.day:
        final days = end.difference(start).inDays + 1;
        return List.generate(days, (i) => start.add(Duration(days: i)));
      case AppCalendarStripMode.month:
        final months =
            ((end.year - start.year) * 12) + end.month - start.month + 1;
        return List.generate(
          months,
          (i) => DateTime(start.year, start.month + i, 1),
        );
      case AppCalendarStripMode.year:
        final years = end.year - start.year + 1;
        return List.generate(years, (i) => DateTime(start.year + i, 1, 1));
    }
  }

  bool _isItemSelected(DateTime item) {
    switch (widget.mode) {
      case AppCalendarStripMode.day:
        return item.year == _selectedDate.year &&
            item.month == _selectedDate.month &&
            item.day == _selectedDate.day;
      case AppCalendarStripMode.month:
        return item.year == _selectedDate.year &&
            item.month == _selectedDate.month;
      case AppCalendarStripMode.year:
        return item.year == _selectedDate.year;
    }
  }

  String _getItemLabel(DateTime item) {
    switch (widget.mode) {
      case AppCalendarStripMode.day:
        return DateFormat('d').format(item);
      case AppCalendarStripMode.month:
        return DateFormat('MMM', 'id_ID').format(item);
      case AppCalendarStripMode.year:
        return DateFormat('yyyy').format(item);
    }
  }

  String _getItemSubLabel(DateTime item) {
    switch (widget.mode) {
      case AppCalendarStripMode.day:
        return DateFormat('EEE', 'id_ID').format(item);
      case AppCalendarStripMode.month:
        return DateFormat('yyyy').format(item);
      case AppCalendarStripMode.year:
        return '';
    }
  }

  String? _getTodayLabel(DateTime item) {
    final now = DateTime.now();
    switch (widget.mode) {
      case AppCalendarStripMode.day:
        if (item.year == now.year &&
            item.month == now.month &&
            item.day == now.day) {
          return 'Hari Ini';
        }
        return null;
      case AppCalendarStripMode.month:
        if (item.year == now.year && item.month == now.month) {
          return 'Bulan Ini';
        }
        return null;
      case AppCalendarStripMode.year:
        if (item.year == now.year) {
          return 'Tahun Ini';
        }
        return null;
    }
  }

  void _onItemTap(DateTime item) {
    setState(() {
      switch (widget.mode) {
        case AppCalendarStripMode.day:
          _selectedDate = DateTime(item.year, item.month, item.day);
          break;
        case AppCalendarStripMode.month:
          _selectedDate = DateTime(item.year, item.month, _selectedDate.day);
          break;
        case AppCalendarStripMode.year:
          _selectedDate = DateTime(
            item.year,
            _selectedDate.month,
            _selectedDate.day,
          );
          break;
      }
    });
    widget.onChanged?.call(_selectedDate);
    _scrollToSelected();
  }

  @override
  Widget build(BuildContext context) {
    final items = _buildItems();

    return SizedBox(
      height: widget.mode == AppCalendarStripMode.year
          ? AppDimens.h56
          : AppDimens.h92,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.w16,
        ).copyWith(top: AppDimens.h8, bottom: AppDimens.h12),
        itemCount: items.length,
        separatorBuilder: (_, _) => SizedBox(width: AppDimens.w8),
        itemBuilder: (context, index) {
          final item = items[index];
          final isSelected = _isItemSelected(item);
          final subLabel = _getItemSubLabel(item);
          final todayLabel = _getTodayLabel(item);

          return GestureDetector(
            onTap: () => _onItemTap(item),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: _itemWidth,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(AppDimens.r24),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (subLabel.isNotEmpty) ...[
                    Text(
                      subLabel,
                      style: context.theme.textTheme.bodySmall?.copyWith(
                        color: isSelected
                            ? AppColors.white.withValues(alpha: 0.8)
                            : AppColors.labelSecondary,
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                      ),
                    ),
                    SizedBox(height: AppDimens.h4),
                  ],
                  Text(
                    _getItemLabel(item),
                    style: context.theme.textTheme.titleMedium?.copyWith(
                      color: isSelected
                          ? AppColors.white
                          : AppColors.labelPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (todayLabel != null) ...[
                    SizedBox(height: AppDimens.h2),
                    Text(
                      todayLabel,
                      style: context.theme.textTheme.bodySmall?.copyWith(
                        color: isSelected
                            ? AppColors.white.withValues(alpha: 0.85)
                            : AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 9,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
