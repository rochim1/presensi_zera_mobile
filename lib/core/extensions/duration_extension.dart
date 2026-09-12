extension DurationExt on Duration {
  /// Example:
  /// 1h 30m -> "1 jam 30 menit"
  /// 45m    -> "45 menit"
  /// 0      -> "0 menit"
  String timeDuration({bool short = false}) {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);

    final parts = <String>[];

    if (hours > 0) {
      parts.add(short ? '${hours}j' : '$hours jam');
    }

    if (minutes > 0) {
      parts.add(short ? '${minutes}m' : '$minutes menit');
    }

    if (parts.isEmpty) {
      return short ? '0m' : '0 menit';
    }

    return parts.join(' ');
  }
}
