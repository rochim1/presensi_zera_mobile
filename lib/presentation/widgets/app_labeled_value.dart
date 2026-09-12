import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:presensi_mobile/core/_core.dart';

class AppLabeledValue extends StatelessWidget {
  /// Optional label displayed above the value.
  /// Hidden if null or empty.
  final String? label;

  /// Main text content (required).
  /// Will be truncated if it exceeds [maxLines].
  final String value;

  /// Custom leading widget (highest priority).
  /// If provided, [icon] will be ignored.
  final Widget? leading;

  /// Optional icon displayed before the value.
  /// Used only if [leading] is null.
  final IconData? icon;

  /// Color applied to the icon (if used).
  /// Defaults to [AppColors.labelPrimary].
  final Color? iconColor;

  /// Color of the value text.
  /// Defaults to [AppColors.labelPrimary].
  final Color? valueColor;

  /// Vertical spacing between label and value.
  /// Defaults to [AppDimens.h2].
  final double? spacing;

  /// Maximum number of lines for the value text.
  /// Defaults to 1 with ellipsis overflow.
  final int? maxLines;

  const AppLabeledValue({
    super.key,
    this.label,
    required this.value,
    this.leading,
    this.icon,
    this.iconColor,
    this.valueColor,
    this.spacing,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;

    final hasLabel = label?.isNotEmpty == true;
    final gap = spacing ?? AppDimens.h2;

    final Widget? resolvedLeading = _buildLeading();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasLabel) ...[
          Text(
            label!,
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.labelSecondary,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: gap),
        ],
        Row(
          children: [
            if (resolvedLeading != null) ...[
              resolvedLeading,
              SizedBox(width: AppDimens.w6),
            ],
            Expanded(
              child: Text(
                value,
                maxLines: maxLines ?? 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall?.copyWith(
                  color: valueColor ?? AppColors.labelPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Resolves which leading widget to display.
  ///
  /// Priority:
  /// 1. [leading] (custom widget)
  /// 2. [icon]
  /// 3. null (no leading)
  Widget? _buildLeading() {
    if (leading != null) return leading;

    if (icon != null) {
      return Icon(
        icon,
        size: 14.sp,
        color: iconColor ?? AppColors.labelPrimary,
      );
    }

    return null;
  }
}
