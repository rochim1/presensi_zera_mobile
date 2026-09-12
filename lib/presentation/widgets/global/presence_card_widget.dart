import 'package:flutter/material.dart';
import 'package:presensi_domain/presensi_domain.dart';

import '../../../core/_core.dart';

class PresenceCardWidget extends StatefulWidget {
  final void Function()? onCheckIn;
  final void Function()? onCheckOut;
  final String? startTime;
  final String? endTime;
  final String? dateNow;
  final bool? isLoading;
  final Widget child;
  final AttendanceType? selectedPresenceType;
  final void Function(AttendanceType)? onPresenceTypeChange;

  const PresenceCardWidget({
    super.key,
    this.onCheckIn,
    this.onCheckOut,
    required this.child,
    this.startTime,
    this.endTime,
    this.isLoading = false,
    this.dateNow,
    this.selectedPresenceType = AttendanceType.daily,
    this.onPresenceTypeChange,
  });

  @override
  State<PresenceCardWidget> createState() => _PresenceCardWidgetState();
}

class _PresenceCardWidgetState extends State<PresenceCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimens.paddingMediumX),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimens.radiusMediumX),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header with date (like "Hari Ini • 28 Aug 2025" and work hours)
          Padding(
            padding: const EdgeInsets.all(AppDimens.paddingMediumX),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.dateNow ?? "--",
                    style: context.textStyle.titleSmall!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.labelPrimary,
                    ),
                  ),
                ),
                Text(
                  '08:00 - 17:00', // Work hours like in image
                  style: context.textStyle.titleSmall!.copyWith(
                    color: AppColors.secondary, // Using theme color
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          _buildPresenceTypeSelector(),

          AppDimens.paddingMedium.hSpace,

          // Time Display Section (CHECK IN and CHECK OUT)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.paddingMediumX,
              vertical: AppDimens.paddingSmall,
            ),
            child: Row(
              children: [
                // Check In
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: widget.onCheckIn,
                      borderRadius: BorderRadius.circular(
                        AppDimens.radiusMedium,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(AppDimens.paddingMedium),
                        decoration: BoxDecoration(
                          color: widget.onCheckIn != null
                              ? AppColors.success.withValues(alpha: 0.05)
                              : AppColors.grey.shade50,
                          borderRadius: BorderRadius.circular(
                            AppDimens.radiusMedium,
                          ),
                          border: widget.onCheckIn != null
                              ? Border.all(
                                  color: AppColors.success.withValues(
                                    alpha: 0.3,
                                  ),
                                  width: 1,
                                )
                              : null,
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(AppDimens.size2S),
                              decoration: BoxDecoration(
                                color: AppColors.success.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(
                                  AppDimens.radiusSmall,
                                ),
                              ),
                              child: Icon(
                                Icons.login_rounded,
                                color: widget.onCheckIn != null
                                    ? AppColors.success
                                    : AppColors.success.withValues(alpha: 0.5),
                                size: 16,
                              ),
                            ),
                            AppDimens.size2S.wSpace,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CHECK IN',
                                    style: context.textStyle.labelSmall!
                                        .copyWith(
                                          color: widget.onCheckIn != null
                                              ? AppColors.labelPrimary
                                              : AppColors.labelSecondary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  AppDimens.sizeS.hSpace,
                                  if (widget.isLoading!)
                                    Container(
                                      width: 60,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: AppColors.grey.shade200,
                                        borderRadius: BorderRadius.circular(
                                          AppDimens.radiusSmall,
                                        ),
                                      ),
                                    )
                                  else
                                    Text(
                                      widget.startTime?.isNotEmpty ?? false
                                          ? widget.startTime!
                                          : (widget.onCheckIn != null
                                                ? 'Tap to Check In'
                                                : '--:--:--'),
                                      style: context.textStyle.titleMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: widget.onCheckIn != null
                                                ? AppColors.success
                                                : AppColors.labelPrimary,
                                            fontSize:
                                                widget.onCheckIn != null &&
                                                    (widget
                                                            .startTime
                                                            ?.isEmpty ??
                                                        true)
                                                ? 12
                                                : null,
                                          ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                AppDimens.sizeM.wSpace,

                // Check Out
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: widget.onCheckOut,
                      borderRadius: BorderRadius.circular(
                        AppDimens.radiusMedium,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(AppDimens.paddingMedium),
                        decoration: BoxDecoration(
                          color: widget.onCheckOut != null
                              ? AppColors.warning.withValues(alpha: 0.05)
                              : AppColors.grey.shade50,
                          borderRadius: BorderRadius.circular(
                            AppDimens.radiusMedium,
                          ),
                          border: widget.onCheckOut != null
                              ? Border.all(
                                  color: AppColors.warning.withValues(
                                    alpha: 0.3,
                                  ),
                                  width: 1,
                                )
                              : null,
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(AppDimens.size2S),
                              decoration: BoxDecoration(
                                color: AppColors.warning.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(
                                  AppDimens.radiusSmall,
                                ),
                              ),
                              child: Icon(
                                Icons.logout_rounded,
                                color: widget.onCheckOut != null
                                    ? AppColors.warning
                                    : AppColors.warning.withValues(alpha: 0.5),
                                size: 16,
                              ),
                            ),
                            AppDimens.size2S.wSpace,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CHECK OUT',
                                    style: context.textStyle.labelSmall!
                                        .copyWith(
                                          color: widget.onCheckOut != null
                                              ? AppColors.labelPrimary
                                              : AppColors.labelSecondary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  AppDimens.sizeS.hSpace,
                                  if (widget.isLoading!)
                                    Container(
                                      width: 60,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: AppColors.grey.shade200,
                                        borderRadius: BorderRadius.circular(
                                          AppDimens.radiusSmall,
                                        ),
                                      ),
                                    )
                                  else
                                    Text(
                                      widget.endTime?.isNotEmpty ?? false
                                          ? widget.endTime!
                                          : (widget.onCheckOut != null
                                                ? 'Tap to Check Out'
                                                : '--:--:--'),
                                      style: context.textStyle.titleMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: widget.onCheckOut != null
                                                ? AppColors.warning
                                                : AppColors.labelPrimary,
                                            fontSize:
                                                widget.onCheckOut != null &&
                                                    (widget.endTime?.isEmpty ??
                                                        true)
                                                ? 12
                                                : null,
                                          ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Divider line before break slider
          if (widget.child != const SizedBox.shrink()) ...[
            AppDimens.paddingSmall.hSpace,
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: AppDimens.paddingLarge,
              ),
              height: 1,
              color: AppColors.dividerLight,
            ),
            AppDimens.paddingSmall.hSpace,
          ],

          // Child widget (usually break slider)
          if (widget.child != const SizedBox.shrink()) widget.child,
        ],
      ),
    );
  }

  Widget _buildPresenceTypeSelector() {
    final types = [
      AttendanceType.daily,
      AttendanceType.shift,
      AttendanceType.oncall,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingMediumX),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.grey.shade50,
          borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        ),
        padding: const EdgeInsets.all(AppDimens.paddingSmall),
        child: Row(
          children: types.map((presenceType) {
            final isSelected = widget.selectedPresenceType == presenceType;
            return Expanded(
              child: GestureDetector(
                onTap: widget.onPresenceTypeChange != null
                    ? () => widget.onPresenceTypeChange!(presenceType)
                    : null,
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
                    presenceType.toName,
                    textAlign: TextAlign.center,
                    style: context.textStyle.bodySmall!.copyWith(
                      color: isSelected
                          ? AppColors.white
                          : AppColors.labelSecondary,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
