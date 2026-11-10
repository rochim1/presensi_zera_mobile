import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:presensi_mobile/core/extensions/date_time_extension.dart';
import 'package:presensi_mobile/l10n/app_language_controller.dart';
import 'package:presensi_mobile/l10n/generated/app_localizations.dart';
import 'package:presensi_mobile/l10n/hr_translation_lookup.dart';
import 'package:presensi_mobile/presentation/widgets/app_dropdown_field.dart';
import 'package:presensi_mobile/presentation/widgets/app_request_card.dart';
import 'package:presensi_mobile/presentation/widgets/common/month_picker_bottom_sheet.dart';

enum _Choice { save }

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppLanguageController.instance.select('en');
  });

  test(
    'relative timestamps follow language with singular and plural forms',
    () async {
      final now = DateTime.now();
      expect(now.subtract(const Duration(seconds: 5)).timeAgo(), 'just now');
      expect(
        now.subtract(const Duration(minutes: 1)).timeAgo(),
        '1 minute ago',
      );
      expect(
        now.subtract(const Duration(minutes: 2)).timeAgo(),
        '2 minutes ago',
      );
      expect(now.subtract(const Duration(hours: 1)).timeAgo(), '1 hour ago');
      expect(now.subtract(const Duration(days: 2)).timeAgo(), '2 days ago');
      await AppLanguageController.instance.select('id');
      expect(
        now.subtract(const Duration(minutes: 2)).timeAgo(),
        '2 menit yang lalu',
      );
    },
  );

  test('new UI copy keeps dynamic names and notes intact', () {
    final l = lookupAppLocalizations(const Locale('en'));
    expect(translateHrText('Halo, Simpan!', l), 'Hello, Simpan!');
    expect(translateHrText('Catatan: Simpan', l), 'Notes: Simpan');
    expect(translateHrText('Buruk', l), 'Poor');
    expect(translateHrText('Berulang mingguan', l), 'Repeats weekly');
    expect(translateHrText('2 balasan', l), '2 replies');
  });

  test(
    'every follow-up label renders in both languages with intact parameters',
    () {
      final fixtures =
          jsonDecode(
                File(
                  'test/fixtures/hr_rescan_translation.json',
                ).readAsStringSync(),
              )
              as List;
      for (final code in ['id', 'en']) {
        final locale = lookupAppLocalizations(Locale(code));
        for (final row in fixtures) {
          String fill(String text) => text.replaceAllMapped(
            RegExp(r'\{(\w+)\}'),
            (m) => 'USER_${m[1]}',
          );
          expect(
            translateHrText(fill(row['source'] as String), locale),
            fill(row[code] as String),
            reason: '$code: ${row['source']}',
          );
        }
      }
    },
  );

  testWidgets('English month picker and enum options preserve free text data', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, _) => MaterialApp(
          locale: const Locale('en'),
          supportedLocales: const [Locale('id'), Locale('en')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  AppDropdownField<_Choice>(
                    selectedItem: _Choice.save,
                    items: const [_Choice.save],
                    itemAsString: (_) => 'Simpan',
                    compareFn: (a, b) => a == b,
                  ),
                  AppDropdownField<String>(
                    selectedItem: 'Simpan',
                    items: const ['Simpan'],
                    itemAsString: (value) => value,
                    compareFn: (a, b) => a == b,
                  ),
                  const AppRequestCard(
                    user: null,
                    showUser: false,
                    statusColor: Colors.grey,
                    statusLabel: 'Menunggu',
                    title: 'Simpan',
                    subtitle: 'Simpan',
                    middleContent: [],
                  ),
                  MonthPickerBottomSheet(
                    initialDate: DateTime(2026, 10, 1),
                    onMonthSelected: (_) {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Save'), findsOneWidget);
    expect(find.text('Simpan'), findsNWidgets(3));
    expect(find.text('October'), findsOneWidget);
    expect(find.text('Oktober'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
