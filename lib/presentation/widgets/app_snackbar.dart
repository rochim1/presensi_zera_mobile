import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

enum SnackbarType { success, error, info, warning }

class AppSnackbar {
  static void showSuccess(BuildContext context, String message) {
    _show(context, message, SnackbarType.success);
  }

  static void showError(BuildContext context, String message) {
    _show(context, message, SnackbarType.error);
  }

  static void showInfo(BuildContext context, String message) {
    _show(context, message, SnackbarType.info);
  }

  static void showWarning(BuildContext context, String message) {
    _show(context, message, SnackbarType.warning);
  }

  static void _show(BuildContext context, String message, SnackbarType type) {
    final (backgroundColor, icon) = switch (type) {
      SnackbarType.success => (AppColors.success, Icons.check_circle),
      SnackbarType.error => (
        AppColors.danger,
        Icons.report_gmailerrorred_sharp,
      ),
      SnackbarType.info => (AppColors.blue, Icons.info_rounded),
      SnackbarType.warning => (AppColors.warning, Icons.warning_rounded),
    };

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: AppDimens.w20),
            SizedBox(width: AppDimens.w12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.r12),
        ),
        margin: EdgeInsets.all(AppDimens.w16),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
