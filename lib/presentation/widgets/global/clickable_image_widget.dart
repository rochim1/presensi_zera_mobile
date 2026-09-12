import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

class ClickableImageWidget extends StatelessWidget {
  final String photo;
  final Size size;
  final double? radius;
  final String? defaultImage;

  const ClickableImageWidget({
    super.key,
    required this.photo,
    required this.size,
    this.radius,
    this.defaultImage,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(radius ?? AppDimens.radiusLarge),
      onTap: () => showDialog(
        context: context,
        builder: (context) => MemoryImageWidget(value: photo, size: size),
      ),
      child: MemoryImageWidget(
        size: size,
        value: photo,
        radius: radius,
        defaultImage: defaultImage,
      ),
    );
  }
}
