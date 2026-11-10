import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:presensi_mobile/l10n/app_language_controller.dart';
import 'package:presensi_mobile/l10n/generated/app_localizations.dart';
import 'package:presensi_mobile/l10n/hr_localization.dart';
import 'package:presensi_mobile/l10n/hr_translation_lookup.dart';
import 'package:presensi_mobile/l10n/language_picker.dart';
import 'package:presensi_mobile/core/extensions/app_extension.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppLanguageController.instance.load();
  });

  test(
    'language survives reload and system clears only its own preference',
    () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('session_token', 'keep-session');
      final controller = AppLanguageController();
      await controller.select('en');
      final reloaded = AppLanguageController();
      await reloaded.load();
      expect(reloaded.value, const Locale('en'));
      await reloaded.select('id');
      expect(prefs.getString(AppLanguageController.preferenceKey), 'id');
      await reloaded.select('system');
      expect(reloaded.value, isNull);
      expect(prefs.getString('session_token'), 'keep-session');
      await expectLater(reloaded.select('invalid'), throwsArgumentError);
      expect(
        AppLanguageController.resolve(const Locale('ja')),
        const Locale('id'),
      );
      controller.dispose();
      reloaded.dispose();
    },
  );

  test('unknown text remains intact and dynamic values are preserved', () {
    final english = lookupAppLocalizations(const Locale('en'));
    expect(
      translateHrText('Nama Organisasi Saya', english),
      'Nama Organisasi Saya',
    );
    expect(translateHrText('Simpan', english), 'Save');
    expect(translateHrText('Masuk', english), 'Check In');
    expect(english.signInAction, 'Sign In');
  });

  testWidgets('picker updates const UI text immediately and keeps user data', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await AppLanguageController.instance.select('id');
    await tester.pumpWidget(
      ValueListenableBuilder<Locale?>(
        valueListenable: AppLanguageController.instance,
        builder: (_, locale, __) => MaterialApp(
          locale: locale,
          supportedLocales: const [Locale('id'), Locale('en')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const Scaffold(
            body: Column(
              children: [
                LanguagePicker(),
                HrText('Simpan'),
                HrText('Masuk', signIn: true),
                Text('Nama Organisasi Saya'),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Simpan'), findsOneWidget);
    expect(DateTime(2026, 10, 9).yMMMMd, '09 Oktober 2026');
    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English').last);
    await tester.pumpAndSettle();
    expect(find.text('Save'), findsOneWidget);
    expect(DateTime(2026, 10, 9).yMMMMd, '09 October 2026');
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Simpan'), findsNothing);
    expect(find.text('Nama Organisasi Saya'), findsOneWidget);
    expect(
      (await SharedPreferences.getInstance()).getString('app_locale'),
      'en',
    );
    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bahasa Indonesia').last);
    await tester.pumpAndSettle();
    expect(find.text('Simpan'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
