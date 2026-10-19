import 'package:equatable/equatable.dart';
import 'package:presensi_data/presensi_data.dart';

/// A visible occurrence retains its source series for update/delete operations.
class KalenderOccurrence extends Equatable {
  final KalenderEvent series;
  final String startDate;
  final String? endDate;

  const KalenderOccurrence({
    required this.series,
    required this.startDate,
    this.endDate,
  });
  String get occurrenceId => '${series.id}:$startDate';
  String get id => series.id;
  String get title => series.title;
  String? get description => series.description;
  String? get color => series.color;
  String? get eventType => series.eventType;
  bool get isRecurring => series.isRecurring;
  String? get recurringType => series.recurringType;
  @override
  List<Object?> get props => [series, startDate, endDate];
}

String calendarDateString(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

DateTime? _calendarDate(String? value) {
  if (value == null || !RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value))
    return null;
  final parsed = DateTime.tryParse('${value}T00:00:00Z');
  return parsed != null && calendarDateString(parsed) == value ? parsed : null;
}

/// Expands only the visible range. Missing month/year dates are skipped,
/// matching the web calendar. The end date is exclusive.
List<KalenderOccurrence> expandKalenderEvents(
  List<KalenderEvent> definitions,
  DateTime rangeStart,
  DateTime endExclusive,
) {
  final from = DateTime.utc(rangeStart.year, rangeStart.month, rangeStart.day);
  final until = DateTime.utc(
    endExclusive.year,
    endExclusive.month,
    endExclusive.day,
  );
  if (!until.isAfter(from)) return const [];
  final result = <KalenderOccurrence>[];
  for (final series in definitions) {
    final anchor = _calendarDate(series.startDate);
    final last = _calendarDate(
      series.endDate?.isNotEmpty == true ? series.endDate : series.startDate,
    );
    if (anchor == null || last == null || last.isBefore(anchor)) continue;
    final duration = last.difference(anchor).inDays;
    final repeats =
        series.isRecurring &&
        const ['weekly', 'monthly', 'yearly'].contains(series.recurringType);
    final earliest = from.subtract(Duration(days: duration));
    var index = 0;
    if (repeats) {
      final distance = switch (series.recurringType) {
        'weekly' => earliest.difference(anchor).inDays ~/ 7,
        'monthly' =>
          (earliest.year - anchor.year) * 12 + earliest.month - anchor.month,
        _ => earliest.year - anchor.year,
      };
      index = distance > 1 ? distance - 1 : 0;
    }
    while (true) {
      var date = anchor;
      if (repeats) {
        if (series.recurringType == 'weekly') {
          date = anchor.add(Duration(days: index * 7));
        } else {
          final period = series.recurringType == 'monthly'
              ? DateTime.utc(anchor.year, anchor.month + index, 1)
              : DateTime.utc(anchor.year + index, anchor.month, 1);
          if (!period.isBefore(until)) break;
          final daysInMonth = DateTime.utc(
            period.year,
            period.month + 1,
            0,
          ).day;
          if (anchor.day > daysInMonth) {
            index++;
            continue;
          }
          date = DateTime.utc(period.year, period.month, anchor.day);
        }
      }
      if (!date.isBefore(until)) break;
      final finish = date.add(Duration(days: duration));
      if (!finish.isBefore(from)) {
        result.add(
          KalenderOccurrence(
            series: series,
            startDate: calendarDateString(date),
            endDate: series.endDate?.isNotEmpty == true
                ? calendarDateString(finish)
                : null,
          ),
        );
      }
      if (!repeats) break;
      index++;
    }
  }
  result.sort((a, b) {
    final byDate = a.startDate.compareTo(b.startDate);
    return byDate != 0 ? byDate : a.occurrenceId.compareTo(b.occurrenceId);
  });
  return List.unmodifiable(result);
}
