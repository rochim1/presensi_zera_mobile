import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

class CacheImageWidget extends StatelessWidget {
  final String imageUrl;
  final Size size;
  final double? radius;
  final String? defaultImage;
  final BoxFit fit;

  const CacheImageWidget({
    super.key,
    required this.imageUrl,
    required this.size,
    this.radius,
    this.defaultImage,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            radius ?? AppDimens.radiusMediumX,
          ),
          border: Border.all(color: AppColors.white, width: 1.0),
          image: DecorationImage(image: imageProvider, fit: fit),
        ),
      ),
      fit: fit,
      placeholder: (_, url) => ShimmerCustom(size: size, radius: radius),
      errorWidget: (_, url, error) => Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? AppDimens.radiusLarge),
          border: Border.all(color: AppColors.white, width: 2.0),
          color: AppColors.bgSecondary,
        ),
        child: defaultImage != null
            ? Image.asset(defaultImage!, fit: BoxFit.cover)
            : Icon(
                PhosphorIcons.imageBroken,
                color: AppColors.labelSecondary,
                size: 24,
              ),
      ),
    );
  }
}
