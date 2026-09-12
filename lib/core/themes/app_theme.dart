import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    late ThemeData base = ThemeData.light();

    return base.copyWith(
      primaryColor: AppColors.primaryTheme,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        error: AppColors.danger,
        surface: AppColors.white,
        onSurface: AppColors.labelPrimary,
      ),
      splashColor: AppColors.splash,
      primaryColorLight: AppColors.primaryTheme,
      scaffoldBackgroundColor: AppColors.bgPrimary,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 3,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        iconTheme: base.iconTheme.copyWith(color: AppColors.white),
        elevation: AppDimens.sizeZero,
        titleTextStyle: base.textTheme.titleLarge!.copyWith(
          color: AppColors.white,
          fontSize: AppDimens.size4M,
          fontWeight: FontWeight.w500,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.grey.shade900,
        behavior: SnackBarBehavior.floating,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusMediumX),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingLarge,
          ),
          foregroundColor: AppColors.primary,
          minimumSize: const Size(AppDimens.size8X, AppDimens.size3XL),
          elevation: 0,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusMediumX),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingLarge,
          ),
          foregroundColor: AppColors.white,
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.fillTertiary,
          disabledForegroundColor: AppColors.labelSecondary,
          minimumSize: const Size(AppDimens.size8X, AppDimens.size3XL),
          shadowColor: AppColors.transparent,
          elevation: 0,
        ).copyWith(elevation: WidgetStateProperty.all<double>(0)),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(width: 1.0, color: AppColors.successBorder),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusMediumX),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingLarge,
          ),
          minimumSize: const Size(AppDimens.size8X, AppDimens.size3XL),
          shadowColor: AppColors.transparent,
          elevation: 0,
        ),
      ),
      iconTheme: const IconThemeData(color: AppColors.neutral),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          } else if (states.contains(WidgetState.hovered)) {
            return AppColors.splash;
          }
          return AppColors.fillPrimary;
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          } else if (states.contains(WidgetState.hovered)) {
            return AppColors.splash;
          }
          return AppColors.fillPrimary;
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.grey.shade200, width: 1),
          borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
          borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
          borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.grey.shade200, width: 1),
          borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        ),
        alignLabelWithHint: true,
        filled: true,
        fillColor: AppColors.white,
        hintStyle: const TextStyle(color: AppColors.labelTertiary),
        labelStyle: const TextStyle(color: AppColors.bodyText),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        contentPadding: const EdgeInsets.all(AppDimens.paddingMedium),
        errorStyle: const TextStyle(color: AppColors.danger),
      ),
    );
  }
}
