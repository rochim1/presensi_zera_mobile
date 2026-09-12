import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:presensi_domain/presensi_domain.dart';

extension DateTimeExtension on DateTime {
  /// e.g [DateTime] convert to `12:20, Kam, 21 Sep 2023`
  String get toHhmmEEEdMMMy =>
      DateFormat('HH:mm, dd MMM yyyy', 'id').format(this);

  /// e.g [DateTime] convert to `2000-12-02`
  String get yMMdMin => DateFormat('yyyy-MM-dd', 'id').format(this);

  /// e.g [DateTime] convert to `2000/12/02`
  String get yMMdOr => DateFormat('yyyy/MM/dd', 'id').format(this);

  /// e.g [DateTime] convert to `12/12/2020`
  String get dMMyOr => DateFormat('dd/MM/yyyy', 'id').format(this);

  /// e.g [DateTime] convert to `12-12-2020`
  String get dMMyMin => DateFormat('dd-MM-yyyy', 'id').format(this);

  /// e.g [DateTime] convert to `12 Agu 2022`
  String get yMMMd => DateFormat('dd MMM yyyy', 'id').format(this);

  /// e.g [DateTime] convert to `12 January 2022`
  String get yMMMMd => DateFormat('dd MMMM yyyy', 'id').format(this);

  /// e.g [DateTime] convert to `January`
  String get toMMMM => DateFormat('MMMM', 'id').format(this);

  /// e.g [DateTime] convert to `Kam, 21 Sep 2023`
  String get toEEEdMMMy => DateFormat('EEE, dd MMM yyy', 'id').format(this);

  /// e.g [DateTime] convert to `23:10`
  String get toHHmm => DateFormat('HH:mm', 'id').format(this);

  /// e.g [DateTime] convert to `23:10:38`
  String get toHHmmss => DateFormat('HH:mm:ss', 'id').format(this);

  /// e.g [DateTime] convert to `2000-02`
  /// for sample you can use for the class [CutiFilterEntity]
  String get yM => DateFormat('yyyy-MM', 'id').format(this);

  /// For "Unix epoch"
  /// e.g `1640979000000`
  int get toMillisecondsSinceEpoch => millisecondsSinceEpoch;

  /// Date time now and remove character
  /// e.g [DateTime] convert to `20230126`
  String get textDateWhitoutStrips => DateFormat('yyyyMMdd').format(this);

  /// get first datetime of this year
  DateTime get thisFirstYear => DateTime(year, 1, 1);

  /// get last datetime of this year
  DateTime get thisLastYear => DateTime(year, 12, 31);
}

extension DateTimeRangeExtension on DateTimeRange {
  String get fromDateTimeRange => '${start.yMMMd} - ${end.yMMMd}';
}

extension IntExtension on int {
  /// Date formatting and return as [String]
  /// e.g `12 Agustus 2022 4:23 PM`
  String get formMillisecondsSinceEpoch {
    final date = DateTime.fromMillisecondsSinceEpoch(this);
    return DateFormat.yMMMd('id').add_jm().format(date);
  }

  /// converter int number to decimal `000`.
  /// e,g `20000` convert to `20.000`
  String get textDecimalDigit =>
      (NumberFormat.decimalPattern('id').format(this));
}

extension DoubleExtension on double {
  String? get langLatSubString {
    if (toString().length > 9) {
      return toString().substring(0, 9);
    } else {
      return toString();
    }
  }
}

extension PlatformFileExtension on Uint8List {
  String formatBytes(int decimals) {
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];

    if (isEmpty) return "0 B";
    var i = (log(lengthInBytes) / log(1024)).floor();
    return '${(lengthInBytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }
}

extension ContextExtensionss on BuildContext {
  //! Styleing
  TextTheme get textStyle => Theme.of(this).textTheme;

  //! SIZEING
  /// The same of [MediaQuery.of(context).size]
  Size get mediaQuerySize => MediaQuery.of(this).size;

  //! Padding
  /// The same of [MediaQuery.of(context).size]
  EdgeInsets get paddingSize => MediaQuery.of(this).padding;

  double get height => mediaQuerySize.height;

  double get width => mediaQuerySize.width;

  /// Gives you the power to get a portion of the height.
  /// Useful for responsive applications.
  double heightTransformer({double dividedBy = 1, double reducedBy = 0.0}) {
    return (mediaQuerySize.height -
            ((mediaQuerySize.height / 100) * reducedBy)) /
        dividedBy;
  }

  /// Gives you the power to get a portion of the width.
  /// Useful for responsive applications.
  double widthTransformer({double dividedBy = 1, double reducedBy = 0.0}) {
    return (mediaQuerySize.width - ((mediaQuerySize.width / 100) * reducedBy)) /
        dividedBy;
  }

  /// Divide the height proportionally by the given value
  double ratio({
    double dividedBy = 1,
    double reducedByW = 0.0,
    double reducedByH = 0.0,
  }) {
    return heightTransformer(dividedBy: dividedBy, reducedBy: reducedByH) /
        widthTransformer(dividedBy: dividedBy, reducedBy: reducedByW);
  }

  /// similar to [MediaQuery.of(context).padding]
  ThemeData get theme => Theme.of(this);

  /// Check if dark mode theme is enable
  bool get isDarkMode => (theme.brightness == Brightness.dark);

  /// give access to Theme.of(context).iconTheme.color
  Color? get iconColor => theme.iconTheme.color;

  /// similar to [MediaQuery.of(context).padding]
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// similar to [MediaQuery.of(context).padding]
  EdgeInsets get mediaQueryPadding => MediaQuery.of(this).padding;

  /// similar to [MediaQuery.of(context).padding]
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// similar to [MediaQuery.of(context).viewPadding]
  EdgeInsets get mediaQueryViewPadding => MediaQuery.of(this).viewPadding;

  /// similar to [MediaQuery.of(context).viewInsets]
  EdgeInsets get mediaQueryViewInsets => MediaQuery.of(this).viewInsets;

  /// similar to [MediaQuery.of(context).orientation]
  Orientation get orientation => MediaQuery.of(this).orientation;

  /// check if device is on landscape mode
  bool get isLandscape => orientation == Orientation.landscape;

  /// check if device is on portrait mode
  bool get isPortrait => orientation == Orientation.portrait;

  /// similar to [MediaQuery.of(this).devicePixelRatio]
  double get devicePixelRatio => MediaQuery.of(this).devicePixelRatio;

  /// Similar to the legacy text scale factor using the active text scaler.
  double get textScaleFactor => MediaQuery.of(this).textScaler.scale(1);

  /// get the shortestSide from screen
  double get mediaQueryShortestSide => mediaQuerySize.shortestSide;

  /// True if width be larger than 800
  bool get showNavbar => (width > 800);

  /// True if the shortestSide is smaller than 600p
  bool get isPhone => (mediaQueryShortestSide < 600);

  /// True if the shortestSide is largest than 600p
  bool get isSmallTablet => (mediaQueryShortestSide >= 600);

  /// True if the shortestSide is largest than 720p
  bool get isLargeTablet => (mediaQueryShortestSide >= 720);

  /// True if the current device is Tablet
  bool get isTablet => isSmallTablet || isLargeTablet;

  /// Returns a specific value according to the screen size
  T responsiveValue<T>({T? mobile, T? tablet, T? desktop, T? watch}) {
    var deviceWidth = mediaQuerySize.shortestSide;
    if (!kIsWeb &&
        (Platform.isMacOS || Platform.isWindows || Platform.isLinux)) {
      deviceWidth = mediaQuerySize.width;
    }
    if (deviceWidth >= 1200 && desktop != null) {
      return desktop;
    } else if (deviceWidth >= 600 && tablet != null) {
      return tablet;
    } else if (deviceWidth < 300 && watch != null) {
      return watch;
    } else {
      return mobile!;
    }
  }
}

extension EmptySpace on num {
  SizedBox get hSpace => SizedBox(height: toDouble());
  SizedBox get wSpace => SizedBox(width: toDouble());
  Divider get hDiv => Divider(height: toDouble());
  VerticalDivider get wDiv => VerticalDivider(width: toDouble());
  EdgeInsetsGeometry get allPadding => EdgeInsets.all(toDouble());
}
