import 'package:presensi_mobile/l10n/hr_localization.dart';
import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

class FailureNotFound extends StatelessWidget {
  const FailureNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.size2L),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          HrText(
            'Belum ada Kunjungan hari ini',
            textAlign: TextAlign.center,
            style: context.textStyle.titleMedium!.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          AppDimens.size3S.hSpace,
          HrText(
            'Belum ada kunjungan untuk memulai produktivitas Anda',
            textAlign: TextAlign.center,
            style: context.textStyle.titleSmall!.copyWith(
              color: AppColors.labelSecondary,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
