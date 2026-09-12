import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

class ApotekMapCardWidget extends StatelessWidget {
  final GlobalAddressEntity? addreass;
  final LatLng? target;
  final bool? isLoading;
  final Function()? onEdit;

  const ApotekMapCardWidget({
    super.key,
    required this.target,
    required this.addreass,
    this.onEdit,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading == true) {
      return ShimmerCustom(size: Size(context.width, 140));
    }

    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
      ),
      color: AppColors.white,
      child: InkWell(
        onTap: onEdit,
        child: Row(
          children: [
            // Left accent strip (gradient)
            Container(
              width: AppDimens.size4S,
              height: AppDimens.size8X + AppDimens.size3XL,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, AppColors.secondary],
                ),
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingMediumX,
                  vertical: AppDimens.sizeM,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'Lokasi',
                            style: context.textStyle.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        AppDimens.sizeM.hSpace,
                        Text(
                          '${addreass?.province}, ${addreass?.country}',
                          style: context.textStyle.bodyMedium?.copyWith(
                            color: AppColors.labelSecondary,
                          ),
                        ),
                      ],
                    ),

                    AppDimens.sizeM.hSpace,

                    // Coordinates box
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppDimens.size3S),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                          AppDimens.radiusSmall,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildCoordinateItem(
                              context,
                              'Latitude',
                              target?.latitude.langLatSubString ?? '-',
                              Icons.my_location_outlined,
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: AppColors.primary.withValues(alpha: 0.3),
                            margin: const EdgeInsets.symmetric(
                              horizontal: AppDimens.paddingMediumX,
                            ),
                          ),
                          Expanded(
                            child: _buildCoordinateItem(
                              context,
                              'Longitude',
                              target?.longitude.langLatSubString ?? '-',
                              Icons.explore_outlined,
                            ),
                          ),
                        ],
                      ),
                    ),

                    AppDimens.sizeM.hSpace,

                    // Address row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppDimens.size2S),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(
                              AppDimens.radiusMedium,
                            ),
                          ),
                          child: const Icon(
                            Icons.location_on_rounded,
                            color: AppColors.primary,
                            size: AppDimens.size2M,
                          ),
                        ),
                        const SizedBox(width: AppDimens.size3S),
                        Expanded(
                          child: Text(
                            addreass?.toApotekAddress() ?? kAddressNotFound,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: context.textStyle.bodySmall,
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
      ),
    );
  }

  Widget _buildCoordinateItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(width: AppDimens.paddingSmall),
            Text(
              label,
              style: context.textStyle.bodySmall?.copyWith(
                color: AppColors.labelSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.paddingSmall),
        Text(
          value,
          style: context.textStyle.titleSmall?.copyWith(
            color: AppColors.secondary,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
