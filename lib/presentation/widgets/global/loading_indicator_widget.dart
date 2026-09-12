import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

class LoadingIndicatorWidget extends StatelessWidget {
  const LoadingIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRect(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(AppDimens.radiusLarge),
            ),
            color: AppColors.grey.shade800,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.sizeXL,
            vertical: AppDimens.size4L,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Theme(
                data: ThemeData(
                  primaryColor: AppColors.white,
                  cupertinoOverrideTheme: const CupertinoThemeData(
                    brightness: Brightness.dark,
                  ),
                ),
                child: const CupertinoActivityIndicator(
                  radius: AppDimens.radiusLarge,
                ),
              ),
              const SizedBox(height: AppDimens.sizeM),
              Text('Memuat', style: AppTextStyle.titleLoading),
            ],
          ),
        ),
      ),
    );
  }
}
