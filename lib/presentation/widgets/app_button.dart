import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

enum AppButtonNewVariant { primary, secondary, tertiary, danger }

enum AppButtonNewStyle { filled, outline, ghost, text }

class AppButtonNew extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonNewVariant variant;
  final AppButtonNewStyle style;
  final double radius;
  final bool fullWidth;
  final bool isLoading;
  final bool isDisabled;

  const AppButtonNew({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = AppButtonNewVariant.primary,
    this.style = AppButtonNewStyle.filled,
    this.radius = 24,
    this.fullWidth = true,
    this.isLoading = false,
    this.isDisabled = false,
  });

  Color get _baseColor {
    switch (variant) {
      case AppButtonNewVariant.primary:
        return AppColors.primary;
      case AppButtonNewVariant.secondary:
        return AppColors.secondary;
      case AppButtonNewVariant.tertiary:
        return AppColors.labelSecondary;
      case AppButtonNewVariant.danger:
        return AppColors.danger;
    }
  }

  Color? get _backgroundColor {
    switch (style) {
      case AppButtonNewStyle.ghost:
        return AppColors.white;
      case AppButtonNewStyle.text:
      case AppButtonNewStyle.outline:
        return Colors.transparent;
      case AppButtonNewStyle.filled:
        return _baseColor;
    }
  }

  Color get _textColor {
    if (style == AppButtonNewStyle.filled) {
      return Colors.white;
    }
    return _baseColor;
  }

  BoxBorder? get _border {
    if (style == AppButtonNewStyle.outline ||
        style == AppButtonNewStyle.ghost) {
      final borderColor = variant == AppButtonNewVariant.danger
          ? AppColors.dangerBorder
          : variant == AppButtonNewVariant.tertiary
          ? AppColors.neutralBorder
          : AppColors.successBorder;
      return Border.all(color: borderColor, width: 1);
    }
    return null;
  }

  bool get _hasShadow {
    return style == AppButtonNewStyle.filled;
  }

  @override
  Widget build(BuildContext context) {
    final bool effectiveDisabled = isDisabled || isLoading || onPressed == null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: fullWidth ? double.infinity : null,
      decoration: BoxDecoration(
        color: effectiveDisabled && style == AppButtonNewStyle.filled
            ? AppColors.divider
            : _backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        border: effectiveDisabled && style == AppButtonNewStyle.outline
            ? Border.all(color: AppColors.borderGrey, width: 1.5)
            : _border,
        boxShadow: effectiveDisabled || !_hasShadow
            ? null
            : [
                BoxShadow(
                  color: AppColors.labelPrimary.withValues(alpha: 0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(radius),
          onTap: effectiveDisabled ? null : onPressed,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: style == AppButtonNewStyle.text
                  ? AppDimens.h8
                  : AppDimens.h12,
              horizontal: style == AppButtonNewStyle.text
                  ? AppDimens.w8
                  : AppDimens.w16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: AppDimens.w20,
                              width: AppDimens.w20,
                              child: CircularProgressIndicator(
                                color: effectiveDisabled
                                    ? AppColors.labelSecondary
                                    : _textColor,
                                strokeWidth: 2,
                              ),
                            ),
                            SizedBox(width: AppDimens.w12),
                            Text(
                              "Memproses...",
                              style: context.theme.textTheme.titleMedium
                                  ?.copyWith(
                                    color: effectiveDisabled
                                        ? AppColors.labelSecondary
                                        : _textColor,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                            ),
                          ],
                        )
                      : Text(
                          text,
                          style: context.theme.textTheme.titleMedium?.copyWith(
                            color: effectiveDisabled
                                ? AppColors.labelSecondary
                                : _textColor,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
