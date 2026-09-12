part of 'shimmer_custom.dart';

class ShimmerInfinity extends StatelessWidget {
  final Size? size;

  const ShimmerInfinity({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.grey.shade100,
      highlightColor: AppColors.grey.shade50,
      child: Container(
        width: size?.width ?? context.width,
        height: size?.height ?? 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.grey.shade100,
        ),
      ),
    );
  }
}
