import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/widgets/app_chip.dart';
import 'package:presensi_mobile/presentation/widgets/app_request_card.dart';
import 'package:presensi_mobile/presentation/widgets/app_top_bar.dart';

void main() {
  testWidgets('status remains explicit and neutral in shared request cards', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    var opened = false;
    await tester.pumpWidget(ScreenUtilInit(designSize: const Size(390, 844),
      builder: (_, _) => MaterialApp(home: Scaffold(body: Padding(
        padding: const EdgeInsets.all(16),
        child: AppRequestCard(user: null, showUser: false,
          title: 'Pengajuan reimbursement perjalanan dinas',
          statusLabel: 'Menunggu persetujuan', statusColor: AppColors.warning,
          middleContent: const [Text('Informasi pengajuan')], onTap: () => opened = true),
      ))),
    ));
    final label = tester.widget<Text>(find.text('Menunggu persetujuan'));
    expect(label.style?.color, AppColors.labelSecondary);
    expect(find.byType(AppChip), findsOneWidget);
    await tester.tap(find.text('Informasi pengajuan'));
    expect(opened, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('header title stays next to back button after resizing from desktop', (tester) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(ScreenUtilInit(designSize: const Size(390, 844),
      builder: (_, _) => const MaterialApp(home: Scaffold(
        appBar: AppTopBar(title: 'Pengajuan', subtitle: 'Kelola pengajuan Anda'),
      )),
    ));
    await tester.pumpAndSettle();
    tester.view.physicalSize = const Size(360, 800);
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.text('Pengajuan')).dx, closeTo(64, 1));
    expect(tester.takeException(), isNull);
  });
}
