import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

class AttendanceBottomSheet extends StatelessWidget {
  final BaseState<AppAddress> addressState;
  final ScrollController? scrollController;
  final Widget? child;
  final Widget? actionButton;
  final String? locationError;

  const AttendanceBottomSheet({
    super.key,
    required this.addressState,
    this.child,
    this.scrollController,
    this.actionButton,
    this.locationError,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimens.radiusLarge),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Scrollable Content
          Expanded(
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: const {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.trackpad,
                  PointerDeviceKind.stylus,
                },
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Keep the handle inside the controller's scrollable area
                    // so dragging it also resizes DraggableScrollableSheet.
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.dividerLight,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.paddingMediumX,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lokasi Anda Saat Ini',
                            style: context.textStyle.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.labelPrimary,
                            ),
                          ),
                          AppDimens.h6.hSpace,
                          addressState.maybeWhen(
                            loading: () => _buildLoadingIndicator(context),
                            success: (data) => Text(
                              data.address,
                              style: context.textStyle.bodyMedium?.copyWith(
                                color: AppColors.labelSecondary,
                                height: 1.4,
                              ),
                            ),
                            failure: (failure) => Text(
                              failure.message.isNotEmpty
                                  ? failure.message
                                  : 'Tidak dapat mengambil lokasi. Pastikan izin lokasi aktif lalu coba lagi.',
                              style: context.textStyle.bodyMedium?.copyWith(
                                color: AppColors.red,
                              ),
                            ),
                            orElse: () => Text(
                              'Lokasi belum tersedia.',
                              style: context.textStyle.bodyMedium?.copyWith(
                                color: AppColors.labelSecondary,
                              ),
                            ),
                          ),
                          if (locationError != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              locationError!,
                              style: context.textStyle.labelSmall?.copyWith(
                                color: AppColors.danger,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Divider(
                              height: 1,
                              color: AppColors.dividerLight,
                            ),
                          ),
                          if (child != null) ...[child!],
                          AppDimens.paddingLarge.hSpace,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Action Button
          if (actionButton != null) SafeArea(top: false, child: actionButton!),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    return Row(
      children: [
        const SpinKitThreeBounce(
          color: AppColors.primary,
          size: AppDimens.sizeM,
        ),
        SizedBox(width: AppDimens.w8),
        Expanded(
          child: Text(
            'Mencari lokasi anda...',
            style: context.theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.labelSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
