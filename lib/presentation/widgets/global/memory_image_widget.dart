import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

class MemoryImageWidget extends StatelessWidget {
  ///  this image can be convert to [Uint8List]
  final String? value;
  final Size size;
  final double? radius;
  final String? defaultImage;
  final bool? isLoading;
  final bool? hasBorder;
  final BoxFit? fit;
  final Color? backgroundColor;
  final Widget? fallbackWidget;

  const MemoryImageWidget({
    super.key,
    required this.value,
    required this.size,
    this.radius,
    this.defaultImage,
    this.fit = BoxFit.cover,
    this.isLoading = false,
    this.backgroundColor,
    this.hasBorder = false,
    this.fallbackWidget,
  });

  bool _isUrl(String value) {
    return value.startsWith('http://') || value.startsWith('https://');
  }

  Widget _buildDefaultImage() {
    if (fallbackWidget != null) return fallbackWidget!;
    if (defaultImage != null) {
      return Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(defaultImage!), fit: fit),
        ),
      );
    }
    return Container(
      width: size.width,
      height: size.height,
      color: AppColors.bgSecondary,
      child: Icon(
        PhosphorIcons.user,
        color: AppColors.labelSecondary,
        size: 24,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? AppDimens.radiusMediumX),
        border: hasBorder!
            ? Border.all(color: AppColors.white, width: 2.0)
            : null,
        color: backgroundColor ?? AppColors.grey.shade100,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? AppDimens.size4S),
        child: !isLoading!
            ? value != null && value!.isNotEmpty
                  ? _isUrl(value!)
                        ? Image.network(
                            value!,
                            width: size.width,
                            height: size.height,
                            fit: fit,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildDefaultImage(),
                          )
                        : Image.memory(
                            AppUtility.fromBase64String(value!),
                            width: size.width,
                            height: size.height,
                            fit: fit,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildDefaultImage(),
                          )
                  : _buildDefaultImage()
            : ShimmerCustom(size: size, radius: radius),
      ),
    );
  }
}
