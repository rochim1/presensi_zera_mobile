import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:shimmer/shimmer.dart';

class AppShimmer extends StatelessWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;

  const AppShimmer({
    super.key,
    required this.child,
    this.baseColor = AppColors.shimmerBaseColor,
    this.highlightColor = AppColors.shimmerHighlightColor,
  });

  factory AppShimmer.box({
    required double width,
    required double height,
    double radius = 8,
    Color? baseColor,
    Color? highlightColor,
  }) {
    return AppShimmer(
      baseColor: baseColor ?? AppColors.shimmerBaseColor,
      highlightColor: highlightColor ?? AppColors.shimmerHighlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  factory AppShimmer.circle({
    required double size,
    Color? baseColor,
    Color? highlightColor,
  }) {
    return AppShimmer(
      baseColor: baseColor ?? AppColors.shimmerBaseColor,
      highlightColor: highlightColor ?? AppColors.shimmerHighlightColor,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: child,
    );
  }
}
