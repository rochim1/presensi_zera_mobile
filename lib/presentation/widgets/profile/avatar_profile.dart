import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

class AvatarProfile extends StatelessWidget {
  final String name;
  final String? role;
  final String? photo;
  final bool hasDelete;
  final Function(AvatarAnswerState? state) onChange;
  final bool? isLoading;
  final bool compact;

  const AvatarProfile({
    super.key,
    required this.name,
    required this.role,
    required this.photo,
    required this.hasDelete,
    required this.onChange,
    this.isLoading = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final avatarSize = compact
        ? const Size(72, 72)
        : AppDimens.imageAvatarPSize;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: compact ? AppDimens.paddingSmall : AppDimens.paddingLargeX,
      ),
      child: Column(
        children: [
          Stack(
            children: [
              if (isLoading!)
                ShimmerCustom(size: avatarSize, radius: avatarSize.width / 2),
              if (!isLoading!)
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.white.withValues(alpha: 0.3),
                      width: 4,
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(avatarSize.width / 2),
                    child: ClipOval(
                      child: MemoryImageWidget(
                        size: avatarSize,
                        value: photo,
                        hasBorder: false,
                        fallbackWidget: Container(
                          width: avatarSize.width,
                          height: avatarSize.height,
                          color: AppColors.primary.withValues(alpha: 0.8),
                          alignment: Alignment.center,
                          child: Text(
                            name.isNotEmpty ? name[0].toUpperCase() : '?',
                            style: context.textStyle.displayMedium?.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => ImageViewWidget(
                        value: photo,
                        size: AppDimens.imageAvatarPSize,
                      ),
                    ),
                  ),
                ),
              Positioned(
                right: 0,
                bottom: 5,
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
                  child: Container(
                    padding: const EdgeInsets.all(AppDimens.paddingSmallX),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        AppDimens.radiusLarge,
                      ),
                      color: AppColors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: AppColors.primary,
                      size: AppDimens.size3M,
                    ),
                  ),
                  onTap: () async {
                    if (isLoading!) return;
                    final action = await AppModalBottom.showActionAvatar(
                      context,
                      hasDelete: hasDelete,
                    );
                    if (action != null) {
                      onChange(action);
                    }
                  },
                ),
              ),
            ],
          ),
          (compact ? AppDimens.paddingSmall : AppDimens.paddingMediumX).hSpace,
          if (isLoading!)
            const ShimmerCustom(
              size: Size(150, 24),
              radius: AppDimens.radiusLargeX,
            )
          else
            Text(
              name.capitalize,
              style:
                  (compact
                          ? context.textStyle.titleLarge
                          : context.textStyle.headlineSmall)!
                      .copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
            ),
          (compact ? AppDimens.paddingSmallX / 2 : AppDimens.paddingSmallX)
              .hSpace,
          if (isLoading!)
            const ShimmerCustom(
              size: Size(100, 20),
              radius: AppDimens.radiusLargeX,
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.paddingMediumX,
                vertical: AppDimens.paddingSmallX,
              ),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppDimens.radiusLargeX),
                border: Border.all(
                  color: AppColors.white.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                role ?? '',
                style: context.textStyle.bodyMedium!.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
