import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

/// Consistent surface for detail content shown inside bottom sheets.
class AppDetailSectionCard extends StatelessWidget {
  final String? title;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const AppDetailSectionCard({
    super.key,
    this.title,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: AppColors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Text(
                title!,
                style: context.textStyle.titleSmall?.copyWith(
                  color: AppColors.labelPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Divider(height: 1, color: AppColors.dividerLight),
          ],
          Padding(padding: padding ?? const EdgeInsets.all(12), child: child),
        ],
      ),
    );
  }
}
