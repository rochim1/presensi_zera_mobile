import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/presentation/pages/home/widgets/announcement_expiry_guard.dart';

Announcement item(String id, DateTime? end) => Announcement(
  id: id,
  judul: id,
  isi: '',
  kategori: 'umum',
  prioritas: AnnouncementPriority.sedang,
  tanggalBerakhir: end,
  isPinned: false,
  showPopup: true,
  bannerImage: '',
  linkUrl: '',
  lampiran: const [],
  createdBy: const User(id: 'creator', name: 'Creator'),
  status: 'active',
);

void main() {
  testWidgets(
    'expired items are removed and popup closes at the final expiry',
    (tester) async {
      var now = DateTime.utc(2026, 10, 10, 12);
      final firstEnd = now.add(const Duration(seconds: 2));
      final lastEnd = now.add(const Duration(seconds: 4));
      final shown = <String>[];
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (_) => AnnouncementExpiryGuard(
                      announcements: [
                        item('first', firstEnd),
                        item('last', lastEnd),
                      ],
                      now: () => now,
                      onShown: (items) => shown.addAll(items.map((e) => e.id)),
                      builder: (_, items) =>
                          Text(items.map((e) => e.id).join(',')),
                    ),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      expect(shown, isEmpty);
      await tester.pumpAndSettle();
      expect(shown, ['first', 'last']);
      now = firstEnd;
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();
      expect(find.text('last'), findsOneWidget);
      expect(find.text('first,last'), findsNothing);
      now = lastEnd;
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();
      expect(find.byType(AnnouncementExpiryGuard), findsNothing);
      expect(find.text('Open'), findsOneWidget);
      expect(shown, ['first', 'last']);
    },
  );

  testWidgets('already expired popup is never recorded as shown', (
    tester,
  ) async {
    final now = DateTime.utc(2026, 10, 10, 12);
    var recorded = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (_) => AnnouncementExpiryGuard(
                    announcements: [item('expired', now)],
                    now: () => now,
                    onShown: (_) => recorded = true,
                    builder: (_, items) => const Text('Should not appear'),
                  ),
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(recorded, isFalse);
    expect(find.text('Should not appear'), findsNothing);
    expect(find.byType(AnnouncementExpiryGuard), findsNothing);
  });

  testWidgets(
    'resume rechecks expiry without closing a route above the popup',
    (tester) async {
      var now = DateTime.utc(2026, 10, 10, 12);
      final end = now.add(const Duration(seconds: 2));
      final navigator = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigator,
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (_) => AnnouncementExpiryGuard(
                      announcements: [item('popup', end)],
                      now: () => now,
                      onShown: (_) {},
                      builder: (_, items) => const Text('Popup'),
                    ),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      navigator.currentState!.push(
        MaterialPageRoute<void>(
          builder: (_) => const Scaffold(body: Text('Other page')),
        ),
      );
      await tester.pumpAndSettle();
      now = end;
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();
      expect(find.text('Other page'), findsOneWidget);
      navigator.currentState!.pop();
      await tester.pumpAndSettle();
      expect(find.byType(AnnouncementExpiryGuard), findsNothing);
      expect(find.text('Open'), findsOneWidget);
    },
  );
}
