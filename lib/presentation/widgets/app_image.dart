import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:presensi_mobile/core/_core.dart';

import 'app_shimmer.dart';

class AppImage extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? radius;
  final bool enablePreview;
  final String? heroTag;
  final Widget Function(BuildContext)? errorBuilder;

  const AppImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.radius,
    this.enablePreview = false,
    this.heroTag,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final uri = url?.resolvedApiUri;

    Widget image;

    if (uri == null) {
      image = _buildError(context);
    } else {
      image = Image.network(
        uri.toString(),
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return _buildShimmer();
        },
        errorBuilder: (_, _, _) => _buildError(context),
      );
    }

    /// Hero wrapper (optional)
    if (heroTag != null) {
      image = Hero(tag: heroTag!, child: image);
    }

    /// Clip radius
    if (radius != null) {
      image = ClipRRect(borderRadius: radius!, child: image);
    }

    /// Tap to preview
    if (enablePreview && uri != null) {
      image = GestureDetector(
        onTap: () => _openPreview(context, uri.toString()),
        child: image,
      );
    }

    return SizedBox(width: width, height: height, child: image);
  }

  void _openPreview(BuildContext context, String imageUrl) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black,
        pageBuilder: (_, _, _) {
          return _ImagePreviewPage(imageUrl: imageUrl, heroTag: heroTag);
        },
      ),
    );
  }

  Widget _buildShimmer() {
    return AppShimmer.box(
      width: width ?? double.infinity,
      height: height ?? 120,
      radius: radius?.topLeft.x ?? 0,
    );
  }

  Widget _buildError(BuildContext context) {
    if (errorBuilder != null) {
      return errorBuilder!(context);
    }
    return Container(
      color: AppColors.white,
      alignment: Alignment.center,
      child: Icon(Icons.broken_image_outlined, color: AppColors.labelSecondary),
    );
  }
}

class _ImagePreviewPage extends StatelessWidget {
  final String imageUrl;
  final String? heroTag;

  const _ImagePreviewPage({required this.imageUrl, this.heroTag});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Center(
              child: Hero(
                tag: heroTag ?? imageUrl,
                child: PhotoView(
                  imageProvider: NetworkImage(imageUrl),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 3,
                  backgroundDecoration: const BoxDecoration(
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            /// Close button
            Positioned(
              top: 40,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
