import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/presentation/pages/home/widgets/announcement_card.dart';

void main() {
  testWidgets('announcement title, metadata and tap fit a narrow card', (
    tester,
  ) async {
    await initializeDateFormatting('id_ID');
    var opened = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 280,
            height: 196,
            child: AnnouncementCard(
              item: Announcement(
                id: 'test',
                judul:
                    'Pengumuman kegiatan perusahaan dan jadwal kerja bersama',
                isi:
                    'Silakan periksa informasi terbaru mengenai kegiatan dan perubahan jadwal kerja bulan ini.',
                kategori: 'Informasi perusahaan dan karyawan',
                prioritas: AnnouncementPriority.tinggi,
                isPinned: true,
                showPopup: false,
                bannerImage: '',
                linkUrl: '',
                lampiran: [],
                createdBy: const User(id: 'author', name: 'Admin'),
                status: 'active',
                tanggalMulai: DateTime(2026, 10, 24),
                tanggalBerakhir: DateTime(2026, 10, 31),
              ),
              onTap: () => opened = true,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.tap(find.byType(AnnouncementCard));
    expect(opened, isTrue);
  });
}
