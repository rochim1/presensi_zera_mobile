import 'package:presensi_mobile/presentation/widgets/profile/item_list_profile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:presensi_mobile/presentation/widgets/app_bottom_navigation_bar.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presensi_mobile/presentation/pages/home/widgets/home_feature_grid.dart';

void main() {
  test(
    'every generated menu icon decodes with a transparent background',
    () async {
      final files = Directory('assets/icons/menu')
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.png'))
          .toList();
      expect(files.length, greaterThanOrEqualTo(24));
      for (final file in files) {
        final codec = await ui.instantiateImageCodec(
          file.readAsBytesSync(),
          targetWidth: 156,
          targetHeight: 156,
        );
        final frame = await codec.getNextFrame();
        expect(frame.image.width, 156, reason: file.path);
        final rgba = await frame.image.toByteData(
          format: ui.ImageByteFormat.rawRgba,
        );
        expect(
          rgba!.getUint8(3),
          0,
          reason: '${file.path} must have transparent corners',
        );
        frame.image.dispose();
        codec.dispose();
      }
    },
  );

  testWidgets(
    'generated menu pages load without layout or image errors on mobile',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: HomeFeatureGrid())),
      );
      await tester.pumpAndSettle();
      expect(find.text('Presensi'), findsWidgets);
      expect(tester.takeException(), isNull);
      await tester.drag(find.byType(PageView), const Offset(-350, 0));
      await tester.pumpAndSettle();
      expect(find.text('KPI'), findsWidgets);
      expect(tester.takeException(), isNull);
      await tester.drag(find.byType(PageView), const Offset(-350, 0));
      await tester.pumpAndSettle();
      expect(find.text('Van Stock'), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'bottom navigation icons fit mobile and retain tab destinations',
    (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      int? selected;
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (_, _) => MaterialApp(
            home: Scaffold(
              bottomNavigationBar: AppBottomNavigationBar(
                currentIndex: 0,
                onTap: (index) => selected = index,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(Image), findsNWidgets(4));
      expect(
        tester.getSize(find.byType(AppBottomNavigationBar)).height,
        lessThanOrEqualTo(64),
      );
      expect(tester.widget<Image>(find.byType(Image).first).width, 38);
      await tester.tap(find.text('Presensi'));
      expect(selected, 1);
      await tester.tap(find.text('Kunjungan'));
      expect(selected, 2);
      await tester.tap(find.text('Profile'));
      expect(selected, 3);
      await tester.tap(find.text('Home'));
      expect(selected, 0);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('profile menu icons use images and keep tap actions', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    const options = [
      Icons.person_rounded,
      Icons.qr_code_2_rounded,
      Icons.account_circle_rounded,
      Icons.delete_forever_rounded,
      Icons.business_rounded,
      Icons.directions_bike_rounded,
      Icons.sync_rounded,
      Icons.phone_rounded,
      Icons.help_rounded,
      Icons.security_rounded,
      Icons.info_rounded,
      Icons.logout_rounded,
    ];
    for (final icon in options) {
      var tapped = false;
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (_, _) => MaterialApp(
            home: Scaffold(
              body: ItemListProfile(
                icon: icon,
                title: 'Menu profil',
                description: 'Informasi dan pengaturan akun',
                onTap: () => tapped = true,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(Image), findsOneWidget);
      await tester.tap(find.text('Menu profil'));
      expect(tapped, isTrue);
      expect(tester.takeException(), isNull);
    }
  });
}
