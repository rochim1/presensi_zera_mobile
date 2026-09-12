import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

class FloatingPhotoInput extends StatelessWidget {
  static double safeBottomOffset(
    BuildContext context, {
    double sheetInitialSize = 0.4,
    double gap = 16,
  }) {
    return MediaQuery.sizeOf(context).height * sheetInitialSize + gap;
  }

  final String? imagePath;
  final XFile? imageFile;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final String label;
  final String? errorText;
  final double width;

  const FloatingPhotoInput({
    super.key,
    this.imagePath,
    this.imageFile,
    required this.onTap,
    required this.onDelete,
    this.label = 'Selfie',
    this.errorText,
    this.width = 100,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imageFile != null || imagePath != null;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: width,
            height: 125,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: errorText != null ? AppColors.danger : AppColors.white,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: hasImage
                  ? kIsWeb
                        ? _WebPhotoPreview(file: imageFile ?? XFile(imagePath!))
                        : Image.file(
                            File(imageFile?.path ?? imagePath!),
                            fit: BoxFit.cover,
                          )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            color: AppColors.primary,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          label,
                          textAlign: TextAlign.center,
                          style: context.textStyle.labelMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
        if (hasImage)
          Positioned(
            top: -4,
            right: -4,
            child: GestureDetector(
              onTap: onDelete,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(6),
                child: const Icon(
                  Icons.close,
                  color: AppColors.white,
                  size: 14,
                ),
              ),
            ),
          ),
        if (errorText != null)
          Positioned(
            bottom: -22,
            left: 0,
            right: 0,
            child: Text(
              errorText!,
              textAlign: TextAlign.center,
              style: context.textStyle.labelSmall?.copyWith(
                color: AppColors.danger,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }
}

class _WebPhotoPreview extends StatefulWidget {
  final XFile file;

  const _WebPhotoPreview({required this.file});

  @override
  State<_WebPhotoPreview> createState() => _WebPhotoPreviewState();
}

class _WebPhotoPreviewState extends State<_WebPhotoPreview> {
  late Future<Uint8List> _bytes;

  @override
  void initState() {
    super.initState();
    _bytes = widget.file.readAsBytes();
  }

  @override
  void didUpdateWidget(covariant _WebPhotoPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.file.path != widget.file.path) {
      _bytes = widget.file.readAsBytes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: _bytes,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Image.memory(
            snapshot.data!,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          );
        }
        if (snapshot.hasError) {
          return const Center(child: Icon(Icons.broken_image_outlined));
        }
        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
      },
    );
  }
}
