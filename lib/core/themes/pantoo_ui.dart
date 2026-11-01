import 'package:flutter/material.dart';
import 'colors_theme.dart';

/// Shared Pantoo mobile presentation values. Keep touch/layout units unscaled.
abstract final class PantooUi {
  static const double pagePadding = 16;
  static const double cardRadius = 16;
  static const double sectionGap = 16;
  static const double touchTarget = 48;
  static const TextStyle metadata = TextStyle(
    fontSize: 11,
    height: 1.4,
    fontWeight: FontWeight.w500,
    color: AppColors.labelSecondary,
  );
  static const BorderSide border = BorderSide(color: AppColors.border);
}
