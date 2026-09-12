import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

class AppTimelineConnector extends StatelessWidget {
  final Color color;
  final double? width;
  final double? height;
  final bool isDashed;

  const AppTimelineConnector({
    super.key,
    required this.color,
    this.width,
    this.height,
    this.isDashed = true,
  });

  @override
  Widget build(BuildContext context) {
    // If bounded in height, IntrinsicHeight or Expanded handles this. But we provide an option.
    final child = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Filled start dot
        Container(
          width: AppDimens.w8,
          height: AppDimens.w8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        // Connector line
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: AppDimens.h4),
            child: isDashed
                ? _AppDashedLine(color: color, dashHeight: AppDimens.h4)
                : Container(
                    width: AppDimens.w2,
                    color: color.withValues(alpha: 0.4),
                  ),
          ),
        ),
        // Hollow end dot
        Container(
          width: AppDimens.w8,
          height: AppDimens.w8,
          decoration: BoxDecoration(
            border: Border.all(color: color, width: AppDimens.w2),
            shape: BoxShape.circle,
          ),
        ),
      ],
    );

    if (height != null || width != null) {
      return SizedBox(
        width: width ?? AppDimens.w24,
        height: height,
        child: child,
      );
    }

    return SizedBox(width: width ?? AppDimens.w24, child: child);
  }
}

class _AppDashedLine extends StatelessWidget {
  final Color color;
  final double dashHeight;

  const _AppDashedLine({required this.color, required this.dashHeight});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalHeight = constraints.maxHeight;
        if (totalHeight <= 0) return const SizedBox.shrink();

        final dashCount = (totalHeight / (dashHeight * 2)).floor();
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            dashCount,
            (_) => Padding(
              padding: EdgeInsets.only(bottom: dashHeight),
              child: Container(
                width: AppDimens.w2,
                height: dashHeight,
                color: color.withValues(alpha: 0.4),
              ),
            ),
          ),
        );
      },
    );
  }
}
