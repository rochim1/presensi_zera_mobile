import 'package:presensi_mobile/core/themes/pantoo_ui.dart';
import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

class AppCard extends StatelessWidget {
  /// Top section (e.g. user info, title row)
  final Widget? header;

  /// Main content (required)
  final Widget content;

  /// Bottom section (e.g. actions, extra info)
  final Widget? footer;

  /// Optional left indicator (status color bar)
  final Color? leadingIndicatorColor;

  /// Card padding
  final EdgeInsetsGeometry? padding;

  /// Tap handler
  final VoidCallback? onTap;

  /// Enable press animation
  final bool enableScaleAnimation;

  /// Whether to show a divider between header -> content
  final bool showHeaderDivider;

  /// Whether to show a divider between content -> footer
  final bool showFooterDivider;

  const AppCard({
    super.key,
    this.header,
    required this.content,
    this.footer,
    this.leadingIndicatorColor,
    this.padding,
    this.onTap,
    this.enableScaleAnimation = true,
    this.showHeaderDivider = true,
    this.showFooterDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final divider = Divider(
      height: 1,
      thickness: 1,
      color: AppColors.dividerLight.withValues(alpha: 0.6),
    );

    final child = IntrinsicHeight(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(PantooUi.cardRadius),
          border: Border.fromBorderSide(PantooUi.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (leadingIndicatorColor != null)
              Container(width: 1, color: AppColors.divider),

            Expanded(
              child: Padding(
                padding: padding ?? const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// HEADER
                    if (header != null) ...[
                      header!,
                      if (showHeaderDivider) ...[
                        SizedBox(height: AppDimens.h12),
                        divider,
                        SizedBox(height: AppDimens.h12),
                      ] else
                        SizedBox(height: AppDimens.h12),
                    ],

                    /// CONTENT
                    content,

                    /// FOOTER
                    if (footer != null) ...[
                      if (showFooterDivider) ...[
                        SizedBox(height: AppDimens.h12),
                        divider,
                        SizedBox(height: AppDimens.h12),
                      ] else
                        SizedBox(height: AppDimens.h12),
                      footer!,
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (onTap == null) return child;

    if (!enableScaleAnimation) {
      return GestureDetector(onTap: onTap, child: child);
    }

    return _Pressable(onTap: onTap!, child: child);
  }
}

class _Pressable extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _Pressable({required this.child, required this.onTap});

  @override
  State<_Pressable> createState() => _PressableState();
}

class _PressableState extends State<_Pressable> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) => setState(() => isPressed = false),
      onTapCancel: () => setState(() => isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: isPressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 120),
        child: widget.child,
      ),
    );
  }
}
