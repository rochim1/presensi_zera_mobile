import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

class AppErrorView extends StatelessWidget {
  final VoidCallback? onRetry;
  final String retryText;
  final Failure failure;

  const AppErrorView({
    super.key,
    this.onRetry,
    this.retryText = 'Coba Lagi',
    this.failure = const UnknownFailure(),
  });

  String _getImageAssetPath(Failure failure) {
    if (failure is NotFoundFailure) {
      return 'assets/common/empty_list.svg';
    }

    return 'assets/common/something_wrong.svg';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppDimens.w16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: AppDimens.h16,
          children: [
            SvgPicture.asset(
              _getImageAssetPath(failure),
              height: AppDimens.h160,
            ),

            Text(
              failure.message,
              style: context.textStyle.titleMedium!.copyWith(
                color: AppColors.labelSecondary,
              ),
              textAlign: TextAlign.center,
            ),

            if (onRetry != null)
              SizedBox(
                width: AppDimens.w160,
                child: AppButtonNew(
                  radius: AppDimens.r64,
                  text: retryText,
                  variant: AppButtonNewVariant.tertiary,
                  style: AppButtonNewStyle.text,
                  onPressed: onRetry,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
