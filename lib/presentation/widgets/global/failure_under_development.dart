import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:presensi_mobile/core/_core.dart';

class FailureUnderDevelopment extends StatelessWidget {
  const FailureUnderDevelopment({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              AppUtility.handleEmptyState(EmptyState.somethingWrong),
              width: 200.0,
            ),
            AppDimens.size2M.hSpace,
            Text(
              'Maaf, Halaman ini dalam proses Pengembangan',
              textAlign: TextAlign.center,
              style: context.textStyle.titleMedium!.copyWith(
                color: AppColors.labelSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
