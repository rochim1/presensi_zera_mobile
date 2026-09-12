import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_cubit.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'activity_form_sheet.dart';

@RoutePage()
class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  final _remote = sl<KalenderRemoteDatasource>();
  DateTime _month = DateTime.now();
  List<KalenderEvent> _events = const [];
  bool _loading = true;
  String? _error;
  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final start = DateTime(_month.year, _month.month, 1);
      final end = DateTime(_month.year, _month.month + 1, 0);
      final format = DateFormat('yyyy-MM-dd');
      final result = await _remote.getEventsByDateRange(
        format.format(start),
        format.format(end),
      );
      if (!mounted) return;
      setState(() {
        _events =
            result
                .where((event) => event.eventType == 'event_perusahaan')
                .toList()
              ..sort((a, b) => a.startDate.compareTo(b.startDate));
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = error.toString();
      });
    }
  }

  String _eventState(KalenderEvent event) {
    final now = DateTime.now();
    final startDate = DateTime.tryParse(event.startDate) ?? now;
    final endDate =
        DateTime.tryParse(event.endDate ?? event.startDate) ?? startDate;
    final startTime = _parseDateTime(
      startDate,
      event.startTime,
      endOfDay: false,
    );
    final endTime = _parseDateTime(endDate, event.endTime, endOfDay: true);
    if (now.isBefore(startTime)) return 'upcoming';
    if (now.isAfter(endTime)) return 'finished';
    return 'ongoing';
  }

  DateTime _parseDateTime(
    DateTime date,
    String? time, {
    required bool endOfDay,
  }) {
    final parts = time?.split(':') ?? const [];
    return DateTime(
      date.year,
      date.month,
      date.day,
      parts.length > 1 ? int.tryParse(parts[0]) ?? 0 : (endOfDay ? 23 : 0),
      parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : (endOfDay ? 59 : 0),
    );
  }

  List<KalenderEvent> get _visibleEvents => _filter == 'all'
      ? _events
      : _events.where((event) => _eventState(event) == _filter).toList();

  Future<String?> _create(Map<String, dynamic> input) async {
    try {
      await _remote.createEvent(input);
      await _fetch();
      return null;
    } catch (error) {
      return error.toString();
    }
  }

  Future<String?> _update(
    KalenderEvent event,
    Map<String, dynamic> input,
  ) async {
    try {
      await _remote.updateEvent(event.id, input);
      await _fetch();
      return null;
    } catch (error) {
      return error.toString();
    }
  }

  Future<void> _delete(KalenderEvent event) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus kegiatan?'),
        content: Text('Kegiatan “${event.title}” akan dihapus.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await _remote.deleteEvent(event.id);
      await _fetch();
      if (mounted) {
        AppSnackbar.showSuccess(context, 'Kegiatan berhasil dihapus');
      }
    } catch (error) {
      if (mounted) {
        AppBottomSheet.showError(context: context, message: error.toString());
      }
    }
  }

  Future<void> _changeMonth() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _month,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      helpText: 'Pilih bulan kegiatan',
    );
    if (selected == null) return;
    setState(() => _month = DateTime(selected.year, selected.month));
    await _fetch();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select<AppCubit, dynamic>(
      (cubit) => cubit.state.user.data,
    );
    final canCreate =
        user?.hasPermission('kalender', action: 'create') ?? false;
    final canUpdate =
        user?.hasPermission('kalender', action: 'update') ?? false;
    final canDelete =
        user?.hasPermission('kalender', action: 'delete') ?? false;
    final canViewAttendance =
        (user?.hasPermission('kalender', action: 'view') ?? false) || canUpdate;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: const AppTopBar(
        title: 'Kegiatan',
        subtitle: 'Kelola kegiatan dan kehadiran',
        backgroundColor: AppColors.transparent,
      ),
      floatingActionButton: canCreate
          ? FloatingActionButton(
              onPressed: () =>
                  ActivityFormSheet.show(context, onSubmit: _create),
              backgroundColor: AppColors.primary,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      body: RefreshIndicator(
        onRefresh: _fetch,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
          children: [
            InkWell(
              onTap: _changeMonth,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_outlined,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        DateFormat('MMMM yyyy', 'id_ID').format(_month),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    const {
                      'all': 'Semua',
                      'upcoming': 'Akan Datang',
                      'ongoing': 'Berlangsung',
                      'finished': 'Selesai',
                    }.entries.map((entry) {
                      final selected = _filter == entry.key;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          selected: selected,
                          label: Text(entry.value),
                          onSelected: (_) =>
                              setState(() => _filter = entry.key),
                          selectedColor: AppColors.primary,
                          backgroundColor: AppColors.white,
                          side: BorderSide(
                            color: selected
                                ? AppColors.primary
                                : AppColors.border,
                          ),
                          labelStyle: TextStyle(
                            color: selected
                                ? Colors.white
                                : AppColors.labelSecondary,
                          ),
                          showCheckmark: false,
                        ),
                      );
                    }).toList(),
              ),
            ),
            const SizedBox(height: 14),
            if (_loading)
              ...List.generate(4, (_) => const _ActivitySkeleton())
            else if (_error != null)
              _ErrorState(message: _error!, onRetry: _fetch)
            else if (_visibleEvents.isEmpty)
              const _EmptyState()
            else
              ..._visibleEvents.asMap().entries.map(
                (entry) => _ActivityCard(
                  number: entry.key + 1,
                  event: entry.value,
                  state: _eventState(entry.value),
                  onTap: () => _showDetail(
                    entry.value,
                    canUpdate: canUpdate,
                    canDelete: canDelete,
                    canViewAttendance: canViewAttendance,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDetail(
    KalenderEvent event, {
    required bool canUpdate,
    required bool canDelete,
    required bool canViewAttendance,
  }) async {
    await AppBottomSheet.show<void>(
      context: context,
      title: const AppBottomSheetTitle(title: 'Detail Kegiatan'),
      child: _ActivityDetail(
        event: event,
        remote: _remote,
        canViewAttendance: canViewAttendance,
        canScan: canUpdate,
      ),
      actionsBuilder: (sheetContext) => Row(
        children: [
          if (canDelete)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(sheetContext);
                  _delete(event);
                },
                icon: const Icon(Icons.delete_outline, color: AppColors.danger),
                label: const Text(
                  'Hapus',
                  style: TextStyle(color: AppColors.danger),
                ),
              ),
            ),
          if (canDelete && canUpdate) const SizedBox(width: 8),
          if (canUpdate)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(sheetContext);
                  ActivityFormSheet.show(
                    context,
                    initialEvent: event,
                    onSubmit: (input) => _update(event, input),
                  );
                },
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit'),
              ),
            ),
          if (canUpdate) const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => Navigator.pop(sheetContext),
              icon: const Icon(Icons.close),
              label: const Text('Tutup'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final int number;
  final KalenderEvent event;
  final String state;
  final VoidCallback onTap;

  const _ActivityCard({
    required this.number,
    required this.event,
    required this.state,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final date = DateTime.tryParse(event.startDate);
    final status = switch (state) {
      'upcoming' => ('Akan Datang', AppColors.info, AppColors.infoBackground),
      'ongoing' => (
        'Berlangsung',
        AppColors.success,
        AppColors.successBackground,
      ),
      _ => ('Selesai', AppColors.neutral, AppColors.neutralBackground),
    };
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppColors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$number',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        if ((event.description ?? '').isNotEmpty) ...[
                          const SizedBox(height: 3),
                          Text(
                            event.description!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.labelSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: status.$3,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status.$1,
                      style: TextStyle(
                        color: status.$2,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      date == null
                          ? event.startDate
                          : DateFormat('dd MMM yyyy', 'id_ID').format(date),
                    ),
                  ),
                  Icon(
                    event.attendanceEnabled
                        ? Icons.qr_code_scanner
                        : Icons.qr_code_2,
                    size: 18,
                    color: event.attendanceEnabled
                        ? AppColors.primary
                        : AppColors.labelTertiary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    event.attendanceEnabled ? 'QR aktif' : 'Tanpa presensi',
                    style: const TextStyle(color: AppColors.labelSecondary),
                  ),
                ],
              ),
              if (event.startTime != null ||
                  event.attendanceLocationName != null) ...[
                const SizedBox(height: 9),
                Row(
                  children: [
                    const Icon(
                      Icons.schedule,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        event.startTime == null
                            ? 'Seharian'
                            : '${event.startTime}${event.endTime == null ? '' : ' – ${event.endTime}'}',
                      ),
                    ),
                    if (event.attendanceLocationName != null) ...[
                      const Icon(
                        Icons.location_on_outlined,
                        size: 18,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          event.attendanceLocationName!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityDetail extends StatefulWidget {
  final KalenderEvent event;
  final KalenderRemoteDatasource remote;
  final bool canViewAttendance;
  final bool canScan;

  const _ActivityDetail({
    required this.event,
    required this.remote,
    required this.canViewAttendance,
    required this.canScan,
  });

  @override
  State<_ActivityDetail> createState() => _ActivityDetailState();
}

class _ActivityDetailState extends State<_ActivityDetail> {
  late Future<List<EventAttendance>>? _attendance;

  @override
  void initState() {
    super.initState();
    _attendance = widget.canViewAttendance && widget.event.attendanceEnabled
        ? widget.remote.getEventAttendance(widget.event.id)
        : null;
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;
    final date = DateTime.tryParse(event.startDate);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          event.title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        if ((event.description ?? '').isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            event.description!,
            style: const TextStyle(
              color: AppColors.labelSecondary,
              height: 1.5,
            ),
          ),
        ],
        const SizedBox(height: 16),
        _DetailRow(
          icon: Icons.calendar_today_outlined,
          label: 'Tanggal',
          value: date == null
              ? event.startDate
              : DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(date),
        ),
        _DetailRow(
          icon: Icons.schedule,
          label: 'Waktu',
          value: event.startTime == null
              ? 'Seharian'
              : '${event.startTime}${event.endTime == null ? '' : ' – ${event.endTime}'}',
        ),
        _DetailRow(
          icon: Icons.qr_code_scanner,
          label: 'Presensi',
          value: event.attendanceEnabled ? 'QR aktif' : 'Tidak diaktifkan',
        ),
        if (event.attendanceLocationName != null)
          _DetailRow(
            icon: Icons.location_on_outlined,
            label: 'Lokasi',
            value:
                '${event.attendanceLocationName}${event.attendanceRadiusMeters == null ? '' : ' · radius ${event.attendanceRadiusMeters} m'}',
          ),
        if (event.attendanceEnabled) ...[
          const SizedBox(height: 12),
          if (widget.canScan) ...[
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => ActivityScannerPage(
                            event: event,
                            remote: widget.remote,
                          ),
                        ),
                      );
                      if (mounted) {
                        setState(
                          () => _attendance = widget.remote.getEventAttendance(
                            event.id,
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('Scan Karyawan'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => ActivityQrDisplayPage(
                          event: event,
                          remote: widget.remote,
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.qr_code_2),
                    label: const Text('Tampilkan Code'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => ActivitySelfScannerPage(
                      event: event,
                      remote: widget.remote,
                    ),
                  ),
                );
                if (mounted && widget.canViewAttendance) {
                  setState(
                    () => _attendance = widget.remote.getEventAttendance(
                      event.id,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.document_scanner_outlined),
              label: const Text('Scan QR Kegiatan'),
            ),
          ),
          const SizedBox(height: 16),
          if (widget.canViewAttendance) ...[
            Text(
              'Kehadiran',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            FutureBuilder<List<EventAttendance>>(
              future: _attendance,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Text(
                    'Gagal memuat kehadiran: ${snapshot.error}',
                    style: const TextStyle(color: AppColors.danger),
                  );
                }
                final rows = snapshot.data ?? const [];
                if (rows.isEmpty) {
                  return const Text(
                    'Belum ada peserta yang tercatat hadir.',
                    style: TextStyle(color: AppColors.labelSecondary),
                  );
                }
                return Column(
                  children: rows.asMap().entries.map((entry) {
                    final row = entry.value;
                    final checkedAt = DateTime.tryParse(row.checkInAt ?? '');
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primaryLight,
                        child: Text(
                          '${entry.key + 1}',
                          style: const TextStyle(color: AppColors.primary),
                        ),
                      ),
                      title: Text(
                        row.userName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(row.employeeNumber ?? 'Karyawan'),
                      trailing: Text(
                        checkedAt == null
                            ? '-'
                            : DateFormat('HH:mm').format(checkedAt.toLocal()),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ],
      ],
    );
  }
}

class ActivityQrDisplayPage extends StatefulWidget {
  final KalenderEvent event;
  final KalenderRemoteDatasource remote;

  const ActivityQrDisplayPage({
    super.key,
    required this.event,
    required this.remote,
  });

  @override
  State<ActivityQrDisplayPage> createState() => _ActivityQrDisplayPageState();
}

class _ActivityQrDisplayPageState extends State<ActivityQrDisplayPage> {
  Timer? _timer;
  String? _token;
  String? _error;
  bool _loading = true;
  int _secondsLeft = 60;
  DateTime? _refreshAt;

  @override
  void initState() {
    super.initState();
    _loadQr();
  }

  Future<void> _loadQr() async {
    if (mounted) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }
    try {
      final result = await widget.remote.getEventAttendanceQr(widget.event.id);
      final refreshSeconds =
          int.tryParse('${result['refresh_in_seconds']}') ?? 60;
      if (!mounted) return;
      setState(() {
        _token = result['token']?.toString();
        _refreshAt = DateTime.now().add(Duration(seconds: refreshSeconds));
        _secondsLeft = refreshSeconds;
        _loading = false;
      });
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        final remaining = _refreshAt?.difference(DateTime.now()).inSeconds ?? 0;
        if (remaining <= 0) {
          _timer?.cancel();
          _loadQr();
        } else if (mounted) {
          setState(() => _secondsLeft = remaining);
        }
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = error.toString();
        });
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.bgPrimary,
    appBar: AppTopBar(
      title: 'QR ${widget.event.title}',
      backgroundColor: AppColors.white,
    ),
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 460),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.event.title,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              const Text(
                'Peserta memindai kode ini dari menu Kegiatan',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.labelSecondary),
              ),
              const SizedBox(height: 24),
              Container(
                width: 300,
                height: 300,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _token != null
                    ? QrImageView(data: _token!, backgroundColor: Colors.white)
                    : Center(
                        child: Text(
                          _error ?? 'QR tidak tersedia',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.danger),
                        ),
                      ),
              ),
              const SizedBox(height: 18),
              Text(
                'Diperbarui dalam $_secondsLeft detik',
                style: TextStyle(
                  color: _secondsLeft <= 10
                      ? Colors.orange.shade800
                      : AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (_error != null)
                TextButton.icon(
                  onPressed: _loadQr,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Coba lagi'),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}

class ActivitySelfScannerPage extends StatefulWidget {
  final KalenderEvent event;
  final KalenderRemoteDatasource remote;

  const ActivitySelfScannerPage({
    super.key,
    required this.event,
    required this.remote,
  });

  @override
  State<ActivitySelfScannerPage> createState() =>
      _ActivitySelfScannerPageState();
}

class _ActivitySelfScannerPageState extends State<ActivitySelfScannerPage> {
  final MobileScannerController _controller = MobileScannerController();
  bool _processing = false;

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_processing || capture.barcodes.isEmpty) return;
    final token = capture.barcodes.first.rawValue;
    if (token == null || token.isEmpty) return;
    setState(() => _processing = true);
    await _controller.stop();
    try {
      double? latitude;
      double? longitude;
      if ((widget.event.attendanceRadiusMeters ?? 0) > 0) {
        final location = Location();
        if (!await location.serviceEnabled() &&
            !await location.requestService()) {
          throw Exception(
            'Aktifkan layanan lokasi untuk presensi kegiatan ini.',
          );
        }
        var permission = await location.hasPermission();
        if (permission == PermissionStatus.denied) {
          permission = await location.requestPermission();
        }
        if (permission != PermissionStatus.granted &&
            permission != PermissionStatus.grantedLimited) {
          throw Exception(
            'Izin lokasi diperlukan untuk presensi kegiatan ini.',
          );
        }
        final position = await location.getLocation();
        latitude = position.latitude;
        longitude = position.longitude;
      }
      final message = await widget.remote.checkInEventByQr(
        qrToken: token,
        latitude: latitude,
        longitude: longitude,
      );
      if (!mounted) return;
      await AppBottomSheet.showSuccess(context: context, message: message);
      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      if (mounted) {
        await AppBottomSheet.showError(
          context: context,
          message: error.toString(),
        );
      }
      if (mounted) {
        setState(() => _processing = false);
        await _controller.start();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    appBar: AppTopBar(
      title: 'Scan QR Kegiatan',
      backgroundColor: AppColors.white,
    ),
    body: Stack(
      fit: StackFit.expand,
      children: [
        MobileScanner(controller: _controller, onDetect: _onDetect),
        Center(
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 3),
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
        Positioned(
          left: 24,
          right: 24,
          bottom: 36,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: .72),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              _processing
                  ? 'Memvalidasi kehadiran...'
                  : 'Arahkan kamera ke QR kegiatan',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class ActivityScannerPage extends StatefulWidget {
  final KalenderEvent event;
  final KalenderRemoteDatasource remote;

  const ActivityScannerPage({
    super.key,
    required this.event,
    required this.remote,
  });

  @override
  State<ActivityScannerPage> createState() => _ActivityScannerPageState();
}

class _ActivityScannerPageState extends State<ActivityScannerPage> {
  final MobileScannerController _controller = MobileScannerController();
  bool _processing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_processing || capture.barcodes.isEmpty) return;
    final token = capture.barcodes.first.rawValue;
    if (token == null || token.isEmpty) return;
    setState(() => _processing = true);
    await _controller.stop();
    try {
      double? latitude;
      double? longitude;
      if (widget.event.attendanceRadiusMeters != null &&
          widget.event.attendanceRadiusMeters! > 0) {
        final location = Location();
        if (!await location.serviceEnabled() &&
            !await location.requestService()) {
          throw Exception(
            'Aktifkan layanan lokasi untuk memindai kegiatan ini.',
          );
        }
        var permission = await location.hasPermission();
        if (permission == PermissionStatus.denied) {
          permission = await location.requestPermission();
        }
        if (permission != PermissionStatus.granted &&
            permission != PermissionStatus.grantedLimited) {
          throw Exception(
            'Izin lokasi diperlukan untuk memindai kegiatan ini.',
          );
        }
        final position = await location.getLocation();
        latitude = position.latitude;
        longitude = position.longitude;
      }
      final message = await widget.remote.scanEventAttendance(
        eventId: widget.event.id,
        qrToken: token,
        latitude: latitude,
        longitude: longitude,
      );
      if (!mounted) {
        return;
      }
      await AppBottomSheet.showSuccess(context: context, message: message);
    } catch (error) {
      if (mounted) {
        await AppBottomSheet.showError(
          context: context,
          message: error.toString(),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _processing = false);
        await _controller.start();
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    appBar: AppTopBar(
      title: 'Scan ${widget.event.title}',
      backgroundColor: AppColors.white,
    ),
    body: Stack(
      fit: StackFit.expand,
      children: [
        MobileScanner(controller: _controller, onDetect: _onDetect),
        Center(
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 3),
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
        Positioned(
          left: 24,
          right: 24,
          bottom: 36,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              _processing
                  ? 'Memvalidasi kehadiran...'
                  : 'Arahkan kamera ke QR karyawan',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 12),
        SizedBox(
          width: 72,
          child: Text(
            label,
            style: const TextStyle(color: AppColors.labelSecondary),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
  );
}

class _ActivitySkeleton extends StatelessWidget {
  const _ActivitySkeleton();
  @override
  Widget build(BuildContext context) => Container(
    height: 130,
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: AppColors.white,
      border: Border.all(color: AppColors.border),
      borderRadius: BorderRadius.circular(16),
    ),
  );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(vertical: 64),
    child: Column(
      children: [
        Icon(
          Icons.event_available_outlined,
          size: 52,
          color: AppColors.labelTertiary,
        ),
        SizedBox(height: 12),
        Text(
          'Belum ada kegiatan pada bulan ini.',
          style: TextStyle(color: AppColors.labelSecondary),
        ),
      ],
    ),
  );
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 48),
    child: Column(
      children: [
        const Icon(
          Icons.cloud_off_outlined,
          size: 48,
          color: AppColors.labelTertiary,
        ),
        const SizedBox(height: 12),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.labelSecondary),
        ),
        const SizedBox(height: 12),
        OutlinedButton(onPressed: onRetry, child: const Text('Coba lagi')),
      ],
    ),
  );
}
