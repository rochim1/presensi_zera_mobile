import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

class DestionationCardWidget extends StatelessWidget {
  final String? addreass;
  final String? title;
  final String? subTitle;
  final StatusTask? deliveryStatus;
  final bool? isLoading;
  final void Function()? onTap;

  const DestionationCardWidget({
    super.key,
    this.addreass,
    this.title,
    this.subTitle,
    this.deliveryStatus,
    this.isLoading = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading!) {
      return ShimmerCustom(size: Size(context.width, 115));
    }
    return InkWell(
      borderRadius: BorderRadius.circular(AppDimens.radiusMediumX),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.lightGreen,
          borderRadius: BorderRadius.circular(AppDimens.radiusMediumX),
          border: Border.all(color: AppColors.green),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.paddingMediumX,
                vertical: AppDimens.sizeM,
              ),
              child: Row(
                crossAxisAlignment: deliveryStatus != null
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title ?? '-',
                          maxLines: 1,
                          style: context.textStyle.titleMedium!,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),
                        if (deliveryStatus != null) ...[
                          AppDimens.size2S.hSpace,
                          Text(
                            subTitle ?? '-',
                            style: context.textStyle.bodyMedium!.copyWith(
                              color: AppColors.labelSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (deliveryStatus != null)
                    ChipWidget(
                      color: deliveryStatus!.toColor,
                      value: deliveryStatus!.toName,
                    )
                  else
                    Text(
                      subTitle ?? '-',
                      style: context.textStyle.bodyMedium!.copyWith(
                        color: AppColors.labelSecondary,
                      ),
                    ),
                ],
              ),
            ),
            const Divider(height: AppDimens.sizeZero),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.paddingMediumX,
                vertical: AppDimens.sizeM,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.location_on, color: AppColors.green),
                  AppDimens.size3S.wSpace,
                  Expanded(
                    child: Text(
                      addreass?.isEmptyStrip ?? '-',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textStyle.bodySmall!,
                    ),
                  ),
                  AppDimens.size3S.wSpace,
                  const Icon(Icons.keyboard_arrow_right),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
