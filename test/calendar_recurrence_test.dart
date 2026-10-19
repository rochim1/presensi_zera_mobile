import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_mobile/presentation/pages/kalender/calendar_recurrence.dart';
import 'package:presensi_mobile/presentation/pages/kalender/bloc/kalender_cubit.dart';

KalenderEvent series(String type, String date, {String? end, bool allDay = true}) => KalenderEvent(
  id: type, title: type, startDate: date, endDate: end,
  isRecurring: true, recurringType: type, allDay: allDay, startTime: '09:00', endTime: '10:00');
List<String> dates(List<KalenderOccurrence> rows) => rows.map((e) => e.startDate).toList();

class DelayedCalendar implements KalenderRemoteDatasource {
  final pending = <Completer<List<KalenderEvent>>>[];
  @override
  Future<List<KalenderEvent>> getEventsByDateRange(String start, String end) {
    final request = Completer<List<KalenderEvent>>(); pending.add(request); return request.future;
  }
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('weekly spans December/January and retains source ID, date and clock', () {
    final source = series('weekly', '2026-12-28', allDay: false);
    final rows = expandKalenderEvents([source], DateTime(2027,1,1), DateTime(2027,2,1));
    expect(dates(rows), ['2027-01-04','2027-01-11','2027-01-18','2027-01-25']);
    expect(rows.map((e) => e.occurrenceId).toSet(), hasLength(4));
    expect(rows.every((e) => identical(e.series, source)), true);
    expect(rows.first.id, 'weekly'); expect(rows.first.series.startTime, '09:00');
    expect(source.startDate, '2026-12-28');
  });
  test('monthly day 31 skips February and returns on March 31 without drift', () {
    final source = series('monthly','2026-12-31');
    expect(dates(expandKalenderEvents([source],DateTime(2027,1,1),DateTime(2027,4,1))), ['2027-01-31','2027-03-31']);
  });
  test('yearly crosses years and leap day skips ordinary years and century 2100', () {
    expect(dates(expandKalenderEvents([series('yearly','2025-12-31')], DateTime(2027,12,1),DateTime(2028,1,1))),['2027-12-31']);
    final leap = series('yearly','2024-02-29');
    expect(expandKalenderEvents([leap],DateTime(2027,2,1),DateTime(2027,3,1)),isEmpty);
    expect(dates(expandKalenderEvents([leap],DateTime(2028,2,1),DateTime(2028,3,1))),['2028-02-29']);
    expect(expandKalenderEvents([leap],DateTime(2100,2,1),DateTime(2100,3,1)),isEmpty);
  });
  test('multi-day occurrence overlaps boundary without changing source duration', () {
    final source = series('monthly','2026-01-30',end:'2026-02-02');
    final rows = expandKalenderEvents([source],DateTime(2026,4,1),DateTime(2026,5,1));
    expect(dates(rows),['2026-03-30','2026-04-30']); expect(rows.first.endDate,'2026-04-02');
    expect(rows.first.series.endDate,'2026-02-02');
  });
  test('no occurrences before anchor, exclusive end, one-off and invalid dates', () {
    final source = series('weekly','2026-12-28');
    expect(expandKalenderEvents([source],DateTime(2026,1,1),DateTime(2026,2,1)),isEmpty);
    expect(dates(expandKalenderEvents([source],DateTime(2026,12,28),DateTime(2027,1,4))),['2026-12-28']);
    expect(expandKalenderEvents([series('monthly','2026-02-30')],DateTime(2026,2,1),DateTime(2026,4,1)),isEmpty);
    expect(expandKalenderEvents([const KalenderEvent(id:'once',title:'once',startDate:'2026-10-19')],DateTime(2026,11,1),DateTime(2026,12,1)),isEmpty);
  });
  test('old series expands only current range and recurrence changes affect equality', () {
    expect(expandKalenderEvents([series('weekly','1900-01-01')],DateTime(2026,10,1),DateTime(2026,11,1)),hasLength(4));
    const a = KalenderEvent(id:'x',title:'x',startDate:'2026-10-19');
    const b = KalenderEvent(id:'x',title:'x',startDate:'2026-10-19',isRecurring:true,recurringType:'weekly');
    expect(a,isNot(b));
  });
  test('late response and late error cannot overwrite a newer month', () async {
    final remote = DelayedCalendar(); final cubit = KalenderCubit(remoteDatasource:remote,initialMonth:DateTime(2027,1));
    final first = cubit.fetchEvents(); final second = cubit.onMonthChanged(DateTime(2027,2));
    remote.pending[1].complete([series('weekly','2026-12-28')]); await second;
    final result = cubit.state.events;
    remote.pending[0].completeError(Exception('old request')); await first;
    expect(cubit.state.focusedMonth.month,2); expect(cubit.state.events,result); expect(cubit.state.errorMessage,isNull);
    await cubit.close();
  });
  test('request completion after closing Cubit does not emit', () async {
    final remote = DelayedCalendar();final cubit = KalenderCubit(remoteDatasource:remote);
    final request = cubit.fetchEvents(); await cubit.close();remote.pending.single.complete([]);await request;
  });
}
