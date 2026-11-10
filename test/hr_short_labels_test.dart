import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:presensi_mobile/l10n/app_language_controller.dart';
import 'package:presensi_mobile/l10n/generated/app_localizations.dart';
import 'package:presensi_mobile/l10n/hr_localization.dart';
import 'package:presensi_mobile/l10n/hr_translation_lookup.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_cubit.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_state.dart';
import 'package:presensi_mobile/presentation/pages/home/widgets/attendance_card.dart';
import 'package:presensi_mobile/presentation/pages/home/widgets/home_requests_section.dart';
import 'package:presensi_mobile/presentation/pages/leave/request/formz/inputs/mode_input.dart';
import 'package:presensi_mobile/presentation/widgets/global/text_field_custom/text_field_date_picker.dart';

class _App extends Cubit<AppState> implements AppCubit {
  _App() : super(const AppState());
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppLanguageController.instance.select('en');
    await initializeDateFormatting('en');
    await initializeDateFormatting('id');
  });
  tearDown(() async => AppLanguageController.instance.select('id'));

  test('period labels translate across all existing clock boundaries', () {
    final id = lookupAppLocalizations(const Locale('id'));
    final en = lookupAppLocalizations(const Locale('en'));
    for (final row in [
      (0, 'Malam', 'Night'),
      (4, 'Malam', 'Night'),
      (5, 'Pagi', 'Morning'),
      (9, 'Pagi', 'Morning'),
      (10, 'Siang', 'Afternoon'),
      (14, 'Siang', 'Afternoon'),
      (15, 'Sore', 'Late afternoon'),
      (17, 'Sore', 'Late afternoon'),
      (18, 'Malam', 'Night'),
      (23, 'Malam', 'Night'),
    ]) {
      final time = DateTime(2026, 11, 10, row.$1);
      expect(hrAttendanceClockLabel(time, id), '${row.$2}, Waktu Saat Ini');
      expect(hrAttendanceClockLabel(time, en), '${row.$3}, Current Time');
    }
    // Language changes presentation, never the leave API contract.
    expect(LeaveMode.halfDayPagi.toHalfDayType(), 'pagi');
    expect(LeaveMode.halfDaySiang.toHalfDayType(), 'siang');
  });

  test('reviewed short labels and parameters render in both languages', () {
    final rows =
        jsonDecode(File('lib/l10n/rescan_short_ui.json').readAsStringSync())
            as List;
    for (final code in ['id', 'en']) {
      final locale = lookupAppLocalizations(Locale(code));
      for (final row in rows) {
        String fill(String value) =>
            value.replaceAllMapped(RegExp(r'\{(\w+)\}'), (m) => 'USER_${m[1]}');
        expect(
          translateHrText(fill(row['source'] as String), locale),
          fill(row[code] as String),
          reason: '$code ${row['source']}',
        );
      }
    }
  });

  testWidgets('rich form label changes language while the value stays intact', (
    tester,
  ) async {
    final input = TextEditingController(text: 'Ringkasan');
    addTearDown(input.dispose);
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, child) => ValueListenableBuilder<Locale?>(
          valueListenable: AppLanguageController.instance,
          builder: (_, locale, child) => MaterialApp(
            locale: locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: Scaffold(
              body: TextFieldDatePicker(
                title: 'Tujuan',
                hint: 'Pilih Tanggal',
                controller: input,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Purpose', findRichText: true), findsOneWidget);
    expect(input.text, 'Ringkasan');
    await AppLanguageController.instance.select('id');
    await tester.pump();
    expect(find.text('Tujuan', findRichText: true), findsOneWidget);
    expect(input.text, 'Ringkasan');
    await tester.pumpWidget(const SizedBox.shrink());
  });

  for (final width in [320.0, 360.0]) {
    testWidgets('home clock and summary switch EN to ID at $width dp', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 1100);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final app = _App();
      addTearDown(app.close);
      await tester.pumpWidget(
        BlocProvider<AppCubit>.value(
          value: app,
          child: ScreenUtilInit(
            designSize: const Size(390, 844),
            builder: (_, child) => ValueListenableBuilder<Locale?>(
              valueListenable: AppLanguageController.instance,
              builder: (_, locale, child) => MaterialApp(
                locale: locale,
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                home: const Scaffold(
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          HomeAttendanceCard(),
                          HomeRequestsSection(),
                          Text('Ringkasan'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(
        find.text(
          'Summary for ${DateFormat('MMMM yyyy', 'en').format(DateTime.now())}',
        ),
        findsOneWidget,
      );
      expect(find.textContaining('Current Time'), findsOneWidget);
      expect(find.textContaining('Waktu Saat Ini'), findsNothing);
      expect(
        find.text('Ringkasan'),
        findsOneWidget,
      ); // User content stays verbatim.
      expect(tester.takeException(), isNull);
      await AppLanguageController.instance.select('id');
      await tester.pump(const Duration(milliseconds: 100));
      expect(
        find.text(
          'Ringkasan ${DateFormat('MMMM yyyy', 'id').format(DateTime.now())}',
        ),
        findsOneWidget,
      );
      expect(find.textContaining('Waktu Saat Ini'), findsOneWidget);
      expect(find.textContaining('Current Time'), findsNothing);
      expect(identical(app.state, const AppState()), isTrue);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }
}
