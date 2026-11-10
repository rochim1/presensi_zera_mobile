import 'package:intl/date_symbol_data_local.dart';
import 'package:presensi_mobile/presentation/pages/attendance/widgets/attendance_period_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presensi_mobile/presentation/pages/attendance/widgets/attendance_filter_bottom_sheet.dart';

void main() {
  testWidgets('reset restores this month and clears type and employee search', (
    tester,
  ) async {
    DateTime? start;
    DateTime? end;
    String? type = 'shift';
    String? name = 'old';
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, _) => MaterialApp(
          home: Scaffold(
            body: AttendanceFilterBottomSheet(
              initialStartDate: DateTime(2025, 1, 1),
              initialEndDate: DateTime(2025, 1, 31),
              initialTypePresensi: 'shift',
              initialSearchName: 'old',
              onApply: (s, e, t, n) {
                start = s;
                end = e;
                type = t;
                name = n;
              },
            ),
          ),
        ),
      ),
    );
    await tester.ensureVisible(find.text('Atur Ulang'));
    await tester.tap(find.text('Atur Ulang'));
    await tester.pump();
    await tester.tap(find.text('Terapkan'));
    final now = DateTime.now();
    expect(start, DateTime(now.year, now.month, 1));
    expect(end, DateTime(now.year, now.month + 1, 0));
    expect(type, isNull);
    expect(name, isNull);
  });

  testWidgets('narrow filter fits and does not apply hidden employee search', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    String? name = 'old';
    String? type;
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, _) => MaterialApp(
          home: Scaffold(
            body: AttendanceFilterBottomSheet(
              initialStartDate: DateTime(2026, 10, 1),
              initialEndDate: DateTime(2026, 10, 31),
              initialSearchName: 'old',
              showSearchName: false,
              onApply: (s, e, t, n) {
                type = t;
                name = n;
              },
            ),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('On Call'));
    await tester.ensureVisible(find.text('Terapkan'));
    await tester.tap(find.text('Terapkan'));
    expect(type, 'oncall');
    expect(name, isNull);
    expect(tester.takeException(), isNull);
  });
  testWidgets(
    'advanced attendance filter opens without an AutoTabsRouter context',
    (tester) async {
      await initializeDateFormatting('id_ID');
      for (final team in [false, true]) {
        await tester.pumpWidget(
          ScreenUtilInit(
            designSize: const Size(390, 844),
            builder: (_, _) => MaterialApp(
              home: Scaffold(
                body: AttendancePeriodFilter(
                  startDate: DateTime(2026, 10, 1),
                  endDate: DateTime(2026, 10, 31),
                  showSearchName: team,
                  onApply: (_, _, _, _) {},
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.byTooltip('Filter presensi lainnya'));
        await tester.pumpAndSettle();
        expect(find.text('Filter Presensi'), findsOneWidget);
        expect(
          find.text('Cari Nama Pegawai'),
          team ? findsOneWidget : findsNothing,
        );
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
      }
    },
  );

  testWidgets(
    'month-first attendance filter applies the full month and preserves type',
    (tester) async {
      await initializeDateFormatting('id_ID');
      DateTime? start;
      DateTime? end;
      String? type;
      String? name = 'hidden';
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (_, _) => MaterialApp(
            home: Scaffold(
              body: AttendancePeriodFilter(
                startDate: DateTime(2026, 10, 1),
                endDate: DateTime(2026, 10, 31),
                type: 'shift',
                searchName: 'hidden',
                showSearchName: false,
                onApply: (s, e, t, n) {
                  start = s;
                  end = e;
                  type = t;
                  name = n;
                },
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Oktober 2026 · Shift'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Februari'));
      await tester.pumpAndSettle();
      expect(start, DateTime(2026, 2, 1));
      expect(end, DateTime(2026, 2, 28));
      expect(type, 'shift');
      expect(name, isNull);
      expect(tester.takeException(), isNull);
    },
  );
}
