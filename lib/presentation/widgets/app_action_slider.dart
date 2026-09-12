import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

class AppActionSlider extends StatelessWidget {
  final String text;
  final Function(ActionSliderController controller) onAction;
  final Color baseColor;
  final IconData icon;
  final ActionSliderController? controller;
  final bool enabled;

  const AppActionSlider({
    super.key,
    required this.text,
    required this.onAction,
    this.baseColor = AppColors.primary,
    this.icon = Icons.arrow_forward_rounded,
    this.controller,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.r32),
        boxShadow: [
          BoxShadow(
            color: baseColor.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ActionSlider.custom(
        sliderBehavior: SliderBehavior.stretch,
        height: 56,
        controller: controller,
        toggleWidth: 48,
        toggleMargin: const EdgeInsets.all(4),
        foregroundBuilder: (context, state, child) {
          Widget? iconWidget;

          if (state.sliderMode == SliderMode.loading) {
            iconWidget = const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.white,
              ),
            );
          } else if (state.sliderMode == SliderMode.success) {
            iconWidget = const Icon(
              Icons.check_rounded,
              color: AppColors.white,
              size: 24,
            );
          } else if (state.sliderMode == SliderMode.failure) {
            iconWidget = const Icon(
              Icons.close_rounded,
              color: AppColors.white,
              size: 24,
            );
          } else {
            iconWidget = Icon(icon, color: AppColors.white, size: 24);
          }

          final currentColor = enabled ? baseColor : AppColors.grey;

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [currentColor, currentColor.withValues(alpha: 0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppDimens.r32),
              boxShadow: enabled
                  ? [
                      BoxShadow(
                        color: currentColor.withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Center(child: iconWidget),
          );
        },
        outerBackgroundBuilder: (context, state, child) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.bgSecondary,
              borderRadius: BorderRadius.circular(AppDimens.r32),
              border: Border.all(
                color: (enabled ? baseColor : AppColors.grey).withValues(
                  alpha: 0.1,
                ),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                text,
                style: context.textStyle.bodyMedium?.copyWith(
                  color: enabled
                      ? AppColors.labelPrimary
                      : AppColors.labelSecondary,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          );
        },
        action: enabled ? onAction : null,
      ),
    );
  }
}
