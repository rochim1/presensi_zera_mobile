import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

class TextFieldImageView extends StatelessWidget {
  final String? base64String;
  final String? imageUrl;
  final String? fileName;
  final String? title;

  const TextFieldImageView({
    super.key,
    this.base64String,
    this.imageUrl,
    required this.fileName,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            textAlign: TextAlign.left,
            style: context.textStyle.bodySmall?.copyWith(
              color: AppColors.labelSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          AppDimens.size3S.hSpace,
        ],
        InkWell(
          onTap: () {
            // Check if we have either base64 or URL
            final hasBase64 = base64String?.isNotEmpty ?? false;
            final hasUrl = imageUrl?.isNotEmpty ?? false;

            if (!hasBase64 && !hasUrl) return;

            if (hasBase64) {
              if (base64String!.isPdf) {
                context.router.navigate(
                  GlobalPdfViewerPageRoute(base64String: base64String),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) => ImageViewWidget(
                    value: base64String,
                    size: AppDimens.imageAvatarPSize,
                    defaultImage: AppImages.somethingWrongSvg,
                  ),
                );
              }
            } else if (hasUrl) {
              showDialog(
                context: context,
                builder: (context) => ImageViewWidget(
                  imageUrl: imageUrl,
                  size: AppDimens.imageAvatarPSize,
                  defaultImage: AppImages.somethingWrongSvg,
                ),
              );
            }
          },
          child: ListItemAttachment(
            fileName: fileName ?? '-',
            fillColor: AppColors.labelSecondaryDark,
          ),
        ),
      ],
    );
  }
}
