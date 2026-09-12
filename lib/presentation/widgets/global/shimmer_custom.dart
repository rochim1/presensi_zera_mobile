import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:shimmer/shimmer.dart';

part 'shimmer_infinity.dart';
part 'shimmer_list_item.dart';

class ShimmerCustom extends StatelessWidget {
  final Size size;
  final double? radius;

  const ShimmerCustom({super.key, required this.size, this.radius});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.grey.shade100,
      highlightColor: AppColors.grey.shade50,
      child: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            radius ?? AppDimens.radiusMediumX,
          ),
          color: AppColors.grey.shade100,
        ),
      ),
    );
  }
}
