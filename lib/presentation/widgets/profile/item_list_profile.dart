import 'package:presensi_mobile/l10n/hr_localization.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:presensi_mobile/core/_core.dart';

final _profileIconAssets = <IconData, String>{
  Icons.person_rounded: 'profile',
  Icons.qr_code_2_rounded: 'identity',
  Icons.account_circle_rounded: 'account',
  Icons.delete_forever_rounded: 'delete_account',
  Icons.business_rounded: 'company',
  Icons.directions_bike_rounded: 'van_stock',
  Icons.sync_rounded: 'sync',
  Icons.phone_rounded: 'contact',
  Icons.help_rounded: 'help',
  Icons.security_rounded: 'privacy',
  Icons.info_rounded: 'version',
  Icons.logout_rounded: 'logout',
};

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
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(
                      AppDimens.radiusMediumX,
                    ),
                  ),
                  child: _profileIconAssets.containsKey(icon)
                      ? Padding(
                          padding: const EdgeInsets.all(4),
                          child: Image.asset(
                            'assets/icons/menu/${_profileIconAssets[icon]}.png',
                            fit: BoxFit.contain,
                            cacheWidth: 120,
                            cacheHeight: 120,
                            excludeFromSemantics: true,
                            errorBuilder: (_, _, _) =>
                                Icon(icon, color: AppColors.primary, size: 24),
                          ),
                        )
                      : Icon(icon, color: AppColors.primary, size: 24),
                ),
                AppDimens.paddingMediumX.wSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HrText(
                        title,
                        style: context.textStyle.titleMedium!.copyWith(
                          color: AppColors.labelPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (description != null) ...[
                        AppDimens.paddingSmall.hSpace,
                        HrText(
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
