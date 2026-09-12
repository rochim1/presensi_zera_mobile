import 'package:flutter/material.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

class AttendanceTypeSelector extends StatelessWidget {
  const AttendanceTypeSelector({
    super.key,
    required this.selectedType,
    required this.onChanged,
    this.availableTypes = AttendanceType.values,
    this.errorText,
    this.isRequired = false,
  });

  final AttendanceType selectedType;
  final ValueChanged<AttendanceType> onChanged;
  final List<AttendanceType> availableTypes;
  final String? errorText;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.grey.shade50,
            borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
            border: Border.all(
              color: errorText != null ? AppColors.danger : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(AppDimens.radiusMedium),
            child: Row(children: _buildItems(context)),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              errorText!,
              style: context.textStyle.labelSmall?.copyWith(
                color: AppColors.danger,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }

  List<Widget> _buildItems(BuildContext context) {
    final types = availableTypes.isEmpty
        ? [AttendanceType.daily]
        : availableTypes;
    return [
      for (var i = 0; i < types.length; i++) ...[
        if (i > 0) const SizedBox(width: AppDimens.sizeS),
        _buildItem(context, types[i]),
      ],
    ];
  }

  Widget _buildItem(BuildContext context, AttendanceType type) {
    final isSelected = selectedType == type;

    return Expanded(
      child: InkWell(
        onTap: () => onChanged(type),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppDimens.paddingSmall,
            horizontal: AppDimens.paddingSmall,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
          ),
          child: Text(
            type.toName,
            textAlign: TextAlign.center,
            style: context.textStyle.bodySmall!.copyWith(
              color: isSelected ? AppColors.white : AppColors.labelSecondary,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
