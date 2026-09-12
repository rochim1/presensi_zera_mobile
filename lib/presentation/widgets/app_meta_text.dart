import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:presensi_mobile/core/_core.dart';

class AppMetaText extends StatelessWidget {
  /// Text content (e.g. ID, timestamps, metadata)
  final String text;

  /// Text alignment
  final TextAlign? textAlign;

  /// Override color (default = tertiary label)
  final Color? color;

  /// Force uppercase (useful for technical/meta info)
  final bool uppercase;

  /// Custom max lines (default: 1)
  final int maxLines;

  const AppMetaText(
    this.text, {
    super.key,
    this.textAlign,
    this.color,
    this.uppercase = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final value = uppercase ? text.toUpperCase() : text;

    return Text(
      value,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: context.textTheme.bodyMedium?.copyWith(
        fontSize: 10.sp,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.labelTertiary,
        letterSpacing: 0.5,
      ),
    );
  }
}
