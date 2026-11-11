import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presensi_mobile/l10n/app_language_controller.dart';
import 'package:presensi_mobile/l10n/generated/app_localizations.dart';
import 'package:presensi_mobile/presentation/pages/home/widgets/home_feature_grid.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  for (final language in ['id', 'en']) {
    for (final width in [390.0, 1200.0]) {
      testWidgets('menu illustrations load in $language at width $width', (
        tester,
      ) async {
        SharedPreferences.setMockInitialValues({});
        await AppLanguageController.instance.select(language);
        addTearDown(() => AppLanguageController.instance.select('id'));
        tester.view.physicalSize = Size(width, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          MaterialApp(
            locale: Locale(language),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: const Scaffold(body: HomeFeatureGrid()),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          find.text(language == 'en' ? 'Attendance' : 'Presensi'),
          findsOneWidget,
        );

        final illustrations = <String>{};
        final pageCount = width >= 1024 ? 2 : 3;
        for (var page = 0; page < pageCount; page++) {
          for (final image in tester.widgetList<Image>(find.byType(Image))) {
            final provider = image.image;
            final asset =
                (provider is ResizeImage ? provider.imageProvider : provider)
                    as AssetImage;
            expect(
              File(asset.assetName).existsSync(),
              isTrue,
              reason: 'Missing illustration: ${asset.assetName}',
            );
            illustrations.add(asset.assetName);
          }
          if (page < pageCount - 1) {
            await tester.drag(find.byType(PageView), Offset(-width, 0));
            await tester.pumpAndSettle();
          }
        }
        expect(illustrations.length, 21);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
