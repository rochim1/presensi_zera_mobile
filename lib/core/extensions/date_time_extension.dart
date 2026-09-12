import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  /// Default date format pattern (e.g. 21 Januari 2026)
  static const String _defaultPattern = "dd MMMM yyyy";

  /// Default locale (Indonesian)
  static const String _defaultLocale = "id";

  /// Formats this [DateTime] into a readable string.
  ///
  /// Example:
  /// ```dart
  /// date.format() // 21 Januari 2026
  /// date.format(pattern: 'dd/MM/yyyy') // 21/01/2026
  /// ```
  String format({
    String pattern = _defaultPattern,
    String locale = _defaultLocale,
  }) {
    return DateFormat(pattern, locale).format(this);
  }

  /// Returns the start of the day (00:00:00.000)
  DateTime get startOfDay => DateTime(year, month, day);

  /// Returns the end of the day (23:59:59.999)
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  /// Returns the first day of the month (e.g. 2026-01-01)
  DateTime get startOfMonth => DateTime(year, month, 1);

  /// Returns the last moment of the month (handles month overflow safely)
  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59, 999);

  /// Returns the first day of the year (e.g. 2026-01-01)
  DateTime get startOfYear => DateTime(year, 1, 1);

  /// Returns the last moment of the year (e.g. 2026-12-31 23:59:59)
  DateTime get endOfYear => DateTime(year, 12, 31, 23, 59, 59, 999);

  // ========================
  // DATE ARITHMETIC
  // ========================

  /// Adds [days] to this date
  DateTime addDays(int days) => add(Duration(days: days));

  /// Adds [hours] to this date
  DateTime addHours(int hours) => add(Duration(hours: hours));

  /// Adds [minutes] to this date
  DateTime addMinutes(int minutes) => add(Duration(minutes: minutes));

  /// Adds [seconds] to this date
  DateTime addSeconds(int seconds) => add(Duration(seconds: seconds));

  /// Adds [months] while preserving day when possible.
  ///
  /// Handles overflow safely:
  /// - Jan 31 + 1 month → Feb 28/29
  DateTime addMonths(int months) {
    final tempDate = DateTime(year, month + months);
    final expectedYear = tempDate.year;
    final expectedMonth = tempDate.month;

    final lastDayOfExpectedMonth = DateTime(
      expectedYear,
      expectedMonth + 1,
      0,
    ).day;

    final targetDay = day > lastDayOfExpectedMonth
        ? lastDayOfExpectedMonth
        : day;

    return DateTime(
      expectedYear,
      expectedMonth,
      targetDay,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
    );
  }

  /// Adds [years] while handling leap year edge cases.
  ///
  /// Example:
  /// - Feb 29 → Feb 28 (if target year is not leap)
  DateTime addYears(int years) {
    final newYear = year + years;

    if (month == 2 && day == 29) {
      final isLeap = DateTime(newYear, 3, 0).day == 29;
      return DateTime(
        newYear,
        month,
        isLeap ? 29 : 28,
        hour,
        minute,
        second,
        millisecond,
        microsecond,
      );
    }

    return DateTime(
      newYear,
      month,
      day,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
    );
  }

  // ========================
  // DATE COMPARISON
  // ========================

  /// Returns true if this date is the same calendar day as [other]
  /// (ignores time: hour, minute, etc.)
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// Returns true if this date is today
  ///
  /// Note: Uses device local time
  bool get isToday => isSameDay(DateTime.now());

  // ========================
  // HUMAN READABLE
  // ========================

  /// Returns a human-readable relative time (Indonesian).
  ///
  /// Examples:
  /// - "baru saja"
  /// - "5 menit yang lalu"
  /// - "2 jam yang lalu"
  /// - "3 hari yang lalu"
  /// - fallback → formatted date
  String timeAgo({
    String pattern = _defaultPattern,
    String locale = _defaultLocale,
  }) {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inSeconds < 60) {
      return 'baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari yang lalu';
    } else {
      return format(pattern: pattern, locale: locale);
    }
  }
}
