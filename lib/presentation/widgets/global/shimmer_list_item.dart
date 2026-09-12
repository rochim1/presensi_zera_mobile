part of 'shimmer_custom.dart';

class ShimmerListItem extends StatelessWidget {
  const ShimmerListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.grey.shade100,
      highlightColor: AppColors.grey.shade50,
      child: Container(
        height: AppDimens.itemListHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
          color: AppColors.grey.shade100,
        ),
      ),
    );
  }
}
