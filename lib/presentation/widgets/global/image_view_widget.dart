import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

class ImageViewWidget extends StatelessWidget {
  final String? value;
  final String? imageUrl;
  final Size size;
  final String? defaultImage;

  const ImageViewWidget({
    super.key,
    this.value,
    this.imageUrl,
    required this.size,
    this.defaultImage,
  });

  @override
  Widget build(BuildContext context) {
    final hasUrl = imageUrl?.isNotEmpty ?? false;
    final hasBase64 = value?.isNotEmpty ?? false;
    final showDefault = !hasUrl && !hasBase64;

    return Stack(
      children: [
        Container(
          constraints: BoxConstraints.expand(height: context.height),
          child: showDefault
              ? (defaultImage != null
                    ? PhotoView(
                        imageProvider: AssetImage(defaultImage!),
                        basePosition: Alignment.center,
                      )
                    : const Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 48,
                          color: Colors.grey,
                        ),
                      ))
              : hasUrl
              ? PhotoView(
                  imageProvider: NetworkImage(imageUrl!),
                  basePosition: Alignment.center,
                  loadingBuilder: (context, event) =>
                      const Center(child: CircularProgressIndicator()),
                  errorBuilder: (context, error, stackTrace) =>
                      defaultImage != null
                      ? PhotoView(
                          imageProvider: AssetImage(defaultImage!),
                          basePosition: Alignment.center,
                        )
                      : const Center(
                          child: Icon(
                            Icons.broken_image,
                            size: 48,
                            color: Colors.grey,
                          ),
                        ),
                )
              : Image.memory(
                  AppUtility.fromBase64String(value!),
                  width: size.width,
                  height: size.height,
                  frameBuilder: (_, _, _, _) {
                    return PhotoView(
                      imageProvider: MemoryImage(
                        AppUtility.fromBase64String(value!),
                      ),
                      basePosition: Alignment.center,
                    );
                  },
                  errorBuilder: (_, _, _) {
                    return defaultImage != null
                        ? PhotoView(
                            imageProvider: AssetImage(defaultImage!),
                            basePosition: Alignment.center,
                          )
                        : const Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 48,
                              color: Colors.grey,
                            ),
                          );
                  },
                ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: SafeArea(
            child: ButtonAddAppBar(
              isDark: false,
              icon: const Icon(Icons.close, color: AppColors.white),
              onTap: () => context.router.pop(),
            ),
          ),
        ),
      ],
    );
  }
}
