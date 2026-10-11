import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_data/src/models/announcement/announcement_response.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/presentation/pages/announcement/bloc/announcement_cubit.dart';

class _FakeAnnouncementRepository implements AnnouncementRepository {
  final requestedPages = <int>[];

  @override
  Future<Either<Failure, List<Announcement>>> getAnnouncements(
    GetAnnouncementsParams params,
  ) async {
    requestedPages.add(params.page);
    return Right(
      List.generate(10, (index) => _announcement('${params.page}-$index')),
    );
  }
}

Announcement _announcement(
  String id, {
  DateTime? start,
  DateTime? end,
  String linkUrl = '',
}) => Announcement(
  id: id,
  judul: 'Judul $id',
  isi: 'Isi',
  kategori: 'umum',
  prioritas: AnnouncementPriority.sedang,
  tanggalMulai: start,
  tanggalBerakhir: end,
  isPinned: false,
  showPopup: true,
  bannerImage: '',
  linkUrl: linkUrl,
  lampiran: const [],
  createdBy: const User(id: 'creator', name: 'Pembuat'),
  status: 'active',
);

void main() {
  test('pagination pengumuman dimulai dari halaman 1 lalu halaman 2', () async {
    final repository = _FakeAnnouncementRepository();
    final cubit = AnnouncementCubit(
      logger: Logger(),
      getAnnouncementsUseCase: GetAnnouncements(repository: repository),
    );

    await cubit.getAnnouncements();
    await cubit.fetchNextPage();

    expect(repository.requestedPages, [1, 2]);
    expect(cubit.state.announcements.currentPage, 2);
    expect(
      cubit.state.announcements.data.map((item) => item.id).toSet(),
      hasLength(20),
    );
    await cubit.close();
  });

  test('status waktu menggunakan timestamp tepat, bukan akhir hari', () {
    final now = DateTime(2026, 10, 9, 12);
    final upcoming = _announcement(
      'future',
      start: now.add(const Duration(minutes: 1)),
    );
    final ended = _announcement(
      'ended',
      end: now.subtract(const Duration(minutes: 1)),
    );
    final active = _announcement(
      'active',
      start: now.subtract(const Duration(minutes: 1)),
      end: now.add(const Duration(minutes: 1)),
    );

    expect(upcoming.isUpcomingAt(now), isTrue);
    expect(upcoming.isActiveAt(now), isFalse);
    expect(ended.isEndedAt(now), isTrue);
    expect(ended.isActiveAt(now), isFalse);
    expect(active.isActiveAt(now), isTrue);
  });

  test('link pengumuman hanya menerima http dan https', () {
    expect(
      _announcement('safe', linkUrl: 'https://example.com').safeLinkUrl,
      'https://example.com',
    );
    expect(
      _announcement('unsafe', linkUrl: 'javascript:alert(1)').safeLinkUrl,
      isEmpty,
    );
  });

  test('expiry is exclusive and a null expiry remains active', () {
    final now = DateTime.utc(2026, 10, 10, 12);
    expect(_announcement('exact', end: now).isActiveAt(now), isFalse);
    expect(_announcement('exact', end: now).isEndedAt(now), isTrue);
    expect(_announcement('unlimited', start: now).isActiveAt(now), isTrue);
  });

  test('announcement dates accept ISO, milliseconds and seconds', () {
    const converter = AnnouncementDateConverter();
    final expected = DateTime.utc(2026, 10, 10, 12);
    for (final value in [
      '2026-10-10T19:00:00+07:00',
      '2026-10-10T12:00:00Z',
      expected.millisecondsSinceEpoch.toString(),
      (expected.millisecondsSinceEpoch ~/ 1000).toString(),
    ]) {
      final end = converter.fromJson(value);
      expect(end!.isAtSameMomentAs(expected), isTrue);
      expect(_announcement('expired', end: end).isActiveAt(expected), isFalse);
    }
    expect(converter.fromJson(null), isNull);
    expect(converter.fromJson(''), isNull);
    expect(() => converter.fromJson('invalid-date'), throwsFormatException);
  });
}
