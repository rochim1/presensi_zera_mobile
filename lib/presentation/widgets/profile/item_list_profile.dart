import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:presensi_mobile/core/_core.dart';

class ItemListProfile extends StatelessWidget {
  final Function()? onTap;
  final String title;
  final String? description;
  final IconData icon;
  final ItemTypeProfile? typeItem;

  const ItemListProfile({
    super.key,
    this.onTap,
    required this.title,
    this.description,
    required this.icon,
    this.typeItem = ItemTypeProfile.general,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingMediumX,
        vertical: AppDimens.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(AppDimens.radiusMediumX),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimens.radiusMediumX),
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.paddingMediumX),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                      AppDimens.radiusMediumX,
                    ),
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 24),
                ),
                AppDimens.paddingMediumX.wSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: context.textStyle.titleMedium!.copyWith(
                          color: AppColors.labelPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (description != null) ...[
                        AppDimens.paddingSmall.hSpace,
                        Text(
                          description!,
                          style: context.textStyle.bodySmall!.copyWith(
                            color: AppColors.labelSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (typeItem!.isText)
                  FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (_, snapshot) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.paddingSmallX,
                          vertical: AppDimens.paddingSmall,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(
                            AppDimens.radiusSmall,
                          ),
                        ),
                        child: Text(
                          snapshot.hasData ? 'v${snapshot.data?.version}' : '',
                          style: context.textStyle.bodySmall!.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  )
                else
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: AppColors.labelTertiary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
