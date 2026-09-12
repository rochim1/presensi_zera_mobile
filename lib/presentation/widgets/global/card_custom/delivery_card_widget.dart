import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:presensi_mobile/core/_core.dart';

class DeliveryCardWidget extends StatelessWidget {
  final String? titleTime;
  final String? addreass;
  final String? title;
  final String? dateNow;
  final String? timeNow;
  final bool? isLoading;

  const DeliveryCardWidget({
    super.key,
    this.addreass,
    this.isLoading = false,
    required this.title,
    required this.titleTime,
    required this.dateNow,
    required this.timeNow,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
      ),
      color: AppColors.white,
      child: Row(
        children: [
          // Left accent strip
          Container(
            width: AppDimens.size4S,
            height: AppDimens.size8X + AppDimens.size3X,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.secondary],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.paddingMediumX,
                vertical: AppDimens.sizeM,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          title ?? '-',
                          style: context.textStyle.titleMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      AppDimens.sizeM.hSpace,
                      Text(
                        dateNow ?? '-',
                        style: context.textStyle.bodyMedium!.copyWith(
                          color: AppColors.labelSecondary,
                        ),
                      ),
                    ],
                  ),

                  AppDimens.sizeM.hSpace,

                  // Time label and big time
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppDimens.size3S),
                    decoration: BoxDecoration(
                      color: AppColors.grey.shade50,
                      borderRadius: BorderRadius.circular(
                        AppDimens.radiusSmall,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          titleTime ?? '-',
                          style: context.textStyle.bodySmall!.copyWith(
                            color: AppColors.labelSecondary,
                          ),
                        ),
                        AppDimens.size3S.hSpace,
                        Text(
                          timeNow ?? '-- : -- : --',
                          style: context.textStyle.headlineSmall!.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  AppDimens.sizeM.hSpace,

                  // Location row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppDimens.size2S),
                        decoration: BoxDecoration(
                          color: AppColors.red.withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: AppColors.red,
                          size: AppDimens.sizeM,
                        ),
                      ),
                      const SizedBox(width: AppDimens.size3S),
                      Expanded(
                        child: isLoading ?? false
                            ? Row(
                                children: [
                                  const SpinKitThreeBounce(
                                    color: AppColors.primary,
                                    size: AppDimens.sizeM,
                                  ),
                                  const SizedBox(width: AppDimens.sizeS),
                                  Flexible(
                                    child: Text(
                                      'Mencari alamat...',
                                      style: TextStyle(
                                        color: AppColors.labelSecondary,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                addreass ?? '-',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: context.textStyle.bodySmall!,
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
