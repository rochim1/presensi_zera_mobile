import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

class ItemCardWidget extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final String? status;
  final Color? colorStatus;
  final void Function()? onTap;
  final void Function()? onCanceled;
  final void Function()? onEdit;

  /// example used `ListComponentWidget`
  final List<Widget> children;

  const ItemCardWidget({
    super.key,
    this.status,
    this.colorStatus,
    this.title,
    this.onTap,
    this.onCanceled,
    this.onEdit,
    required this.children,
    this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppDimens.radiusMediumX),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgSecondary,
          borderRadius: BorderRadius.circular(AppDimens.radiusMediumX),
        ),
        child: Column(
          children: [
            Column(
              children: [
                if (title != null) ...[
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(AppDimens.radiusMediumX),
                      ),
                      color: AppColors.lightBlue,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimens.paddingMediumX,
                      horizontal: AppDimens.paddingMediumX,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title ?? '',
                                style: context.textStyle.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (subTitle != null && subTitle!.isNotEmpty) ...[
                                AppDimens.size2S.hSpace,
                                Text(
                                  subTitle!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: context.textStyle.bodySmall!.copyWith(
                                    color: AppColors.labelSecondary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        if (status != null && colorStatus != null)
                          ChipWidget(
                            color: colorStatus ?? AppColors.red,
                            value: status ?? '',
                          ),
                      ],
                    ),
                  ),
                  AppDimens.size2S.hSpace,
                ],
                ListView.separated(
                  itemCount: children.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(AppDimens.paddingMediumX),
                  itemBuilder: (BuildContext context, int index) =>
                      children[index],
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                ),
              ],
            ),
            if (onCanceled != null || onEdit != null)
              InkWell(
                onTap: onCanceled ?? onEdit,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDimens.paddingMedium,
                  ),
                  decoration: BoxDecoration(
                    color: onCanceled != null
                        ? AppColors.lightRed
                        : AppColors.lightBlue,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(AppDimens.radiusLarge),
                    ),
                  ),
                  child: Text(
                    onCanceled != null ? 'Batalkan Kunjungan' : 'Ubah Lokasi',
                    textAlign: TextAlign.center,
                    style: context.textStyle.bodyMedium!.copyWith(
                      color: onCanceled != null
                          ? AppColors.red
                          : AppColors.blue,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
