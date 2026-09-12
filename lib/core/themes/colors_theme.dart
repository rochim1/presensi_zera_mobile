import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // app color
  static const Color primary = Color(0xFF087F75);
  static const Color primaryDark = Color(0xFF06665F);
  static const Color primaryLight = Color(0xFFE6F4F2);
  static const Color primarySoft = Color(0xFFF1F8F7);
  static const Color secondary = primaryDark;

  // component color
  static const Color border = Color(0xFFE1E5E9);
  static const Color divider = Color(0xFFE8EBEE);
  static const Color dividerLight = Color(0xFFE8EBEE);
  static const Color danger = Color(0xFFB94A48);
  static const Color dangerBackground = Color(0xFFFBEDEC);
  static const Color dangerBorder = Color(0xFFEBCFCD);
  static const Color warning = Color(0xFFC88916);
  static const Color warningBackground = Color(0xFFFFF7E6);
  static const Color warningBorder = Color(0xFFF2DFB5);
  static const Color success = primary;
  static const Color successBackground = Color(0xFFE8F4F1);
  static const Color successBorder = Color(0xFFC8E4DF);
  static const Color info = Color(0xFF3E6F8E);
  static const Color infoBackground = Color(0xFFEDF4F8);
  static const Color infoBorder = Color(0xFFD2E1EA);
  static const Color neutral = Color(0xFF667085);
  static const Color neutralBackground = Color(0xFFF2F4F6);
  static const Color neutralBorder = Color(0xFFDDE1E6);
  static const Color white = Color(0xFFFFFFFF);
  static const Color transparent = Colors.transparent;
  static const Color modalBarrier = Color(0x8C000000);
  static const Color splash = Color(0x2AFFF8FF);
  static const Color listMenu = Color(0xFF1F3682);

  // border
  static const Color borderGrey = border;

  // label text light
  static const Color labelPrimary = Color(0xFF172033);
  static const Color bodyText = Color(0xFF3F4756);
  static const Color labelSecondary = Color(0xFF737B89);
  static const Color labelTertiary = Color(0xFF9AA1AC);
  static const Color labelQuarternary = Color(0xFFDDE1E6);

  // label text dark
  static Color labelPrimaryDark = const Color(0xFFFFFFFF);
  static Color labelSecondaryDark = const Color(0x99EBEBF5);
  static Color labelTertiaryDark = const Color(0x4CEBEBF5);
  static Color labelQuarternaryDark = const Color(0x2DEBEBF5);

  // fill color
  static Color fillPrimary = const Color(0xFF787880).withValues(alpha: 0.2);
  static Color fillSecondary = const Color(0xFF787880).withValues(alpha: 0.16);
  static Color fillTertiary = const Color(0xFF767680).withValues(alpha: 0.12);
  static Color fillQuarternary = const Color(
    0xFF747480,
  ).withValues(alpha: 0.08);

  // system fill color
  static const Color red = danger;
  static const Color orange = warning;
  static const Color yellow = warning;
  static const Color green = success;
  static const Color tial = info;
  static const Color blue = info;
  static const Color indigo = Color(0xFF5856D6);
  static const Color purple = Color(0xFF7569A6);
  static const Color pink = danger;

  // system light color
  static const Color lightRed = dangerBackground;
  static const Color lightOrange = warningBackground;
  static const Color lightYellow = warningBackground;
  static const Color lightGreen = successBackground;
  static const Color lightTial = infoBackground;
  static const Color lightBlue = infoBackground;
  static const Color lightIndigo = Color(0xFFF0EEF8);
  static const Color lightPurple = Color(0xFFF0EEF8);
  static const Color lightPink = dangerBackground;

  // backgroud color light
  static const Color bgPrimary = Color(0xFFF7F8FA);
  static const Color bgSecondary = Color(0xFFF3F5F6);

  // backgroud color dark
  static const Color bgPrimaryDark = Color(0xFF1C1C1E);
  static const Color bgSecondaryDark = Color(0xFF2C2C2E);

  // App Shimmer
  static const Color shimmerBaseColor = Color(0xFFCCCCCC);
  static const Color shimmerHighlightColor = Color(0xFFEFEFEF);

  /// [MaterialColor] theme map color
  static const MaterialColor grey = MaterialColor(0xFF8E8E93, <int, Color>{
    50: Color(0xFFF2F2F7), //10%
    100: Color(0xFFE5E5EA), //20%
    200: Color(0xFFD1D1D6), //30%
    300: Color(0xFFC7C7CC), //40%
    400: Color(0xFFAEAEB2), //50%
    500: Color(0xFF8E8E93), //60%
    600: Color(0xFF636366), //70%
    700: Color(0xFF48484A), //80%
    800: Color(0xFF3A3A3C), //90%
    850: Color(0xFF2C2C2E), //95%
    900: Color(0xFF1C1C1E), //100%
  });

  /// [MaterialColor] theme map color
  static const MaterialColor primaryTheme =
      MaterialColor(0xFF087F75, <int, Color>{
        50: Color(0xFFF1F8F7),
        100: Color(0xFFE6F4F2),
        200: Color(0xFFC8E4DF),
        300: Color(0xFF91C9C2),
        400: Color(0xFF4FA79E),
        500: Color(0xFF087F75),
        600: Color(0xFF077269),
        700: Color(0xFF06665F),
        800: Color(0xFF05544E),
        900: Color(0xFF043F3B),
      });
}
