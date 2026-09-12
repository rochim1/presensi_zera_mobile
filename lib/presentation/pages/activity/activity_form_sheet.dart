import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

class ActivityFormSheet extends StatefulWidget {
  final KalenderEvent? initialEvent;
  final Future<String?> Function(Map<String, dynamic>) onSubmit;

  const ActivityFormSheet({
    super.key,
    this.initialEvent,
    required this.onSubmit,
  });

  static Future<void> show(
    BuildContext context, {
    KalenderEvent? initialEvent,
    required Future<String?> Function(Map<String, dynamic>) onSubmit,
  }) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) =>
        ActivityFormSheet(initialEvent: initialEvent, onSubmit: onSubmit),
  );

  @override
  State<ActivityFormSheet> createState() => _ActivityFormSheetState();
}

class _ActivityFormSheetState extends State<ActivityFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _locationName = TextEditingController();
  late DateTime _date;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  DateTime? _attendanceOpenAt;
  DateTime? _attendanceCloseAt;
  bool _attendanceEnabled = true;
  bool _locationEnabled = false;
  double? _latitude;
  double? _longitude;
  int _radius = 100;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final event = widget.initialEvent;
    _title.text = event?.title ?? '';
    _description.text = event?.description ?? '';
    _locationName.text = event?.attendanceLocationName ?? '';
    _date = DateTime.tryParse(event?.startDate ?? '') ?? DateTime.now();
    _startTime = _parseTime(event?.startTime);
    _endTime = _parseTime(event?.endTime);
    _attendanceEnabled = event?.attendanceEnabled ?? true;
    _attendanceOpenAt = DateTime.tryParse(event?.attendanceOpenAt ?? '');
    _attendanceCloseAt = DateTime.tryParse(event?.attendanceCloseAt ?? '');
    _latitude = event?.attendanceLatitude;
    _longitude = event?.attendanceLongitude;
    _radius = event?.attendanceRadiusMeters ?? 100;
    _locationEnabled = _latitude != null && _longitude != null;
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _locationName.dispose();
    super.dispose();
  }

  TimeOfDay? _parseTime(String? value) {
    final parts = value?.split(':') ?? const [];
    if (parts.length < 2) return null;
    return TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 0,
      minute: int.tryParse(parts[1]) ?? 0,
    );
  }

  String? _time(TimeOfDay? value) => value == null
      ? null
      : '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';

  String? _dateTimeWithOffset(DateTime? value) {
    if (value == null) return null;
    final local = value.toLocal();
    final offset = local.timeZoneOffset;
    final sign = offset.isNegative ? '-' : '+';
    final absolute = offset.abs();
    final hours = absolute.inHours.toString().padLeft(2, '0');
    final minutes = (absolute.inMinutes % 60).toString().padLeft(2, '0');
    return '${local.toIso8601String()}$sign$hours:$minutes';
  }

  Future<void> _pickDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (result != null) setState(() => _date = result);
  }

  Future<void> _pickTime(bool start) async {
    final result = await showTimePicker(
      context: context,
      initialTime: start
          ? (_startTime ?? TimeOfDay.now())
          : (_endTime ?? TimeOfDay.now()),
    );
    if (result != null) {
      setState(() => start ? _startTime = result : _endTime = result);
    }
  }

  Future<void> _pickAttendanceDateTime(bool opening) async {
    final current = opening
        ? (_attendanceOpenAt ?? _date)
        : (_attendanceCloseAt ?? _date);
    final date = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(current),
    );
    if (time == null) return;
    final result = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    setState(
      () => opening ? _attendanceOpenAt = result : _attendanceCloseAt = result,
    );
  }

  Future<void> _pickLocation() async {
    final result = await context.router.push<LocationPickerResult>(
      LocationPickerPageRoute(
        initialLat: _latitude ?? kDDefaultLat,
        initialLong: _longitude ?? kDDefaultLong,
      ),
    );
    if (result == null) return;
    setState(() {
      _latitude = result.position.latitude;
      _longitude = result.position.longitude;
      if (_locationName.text.trim().isEmpty) {
        _locationName.text = result.address.toString();
      }
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_startTime != null && _endTime != null) {
      final start = _startTime!.hour * 60 + _startTime!.minute;
      final end = _endTime!.hour * 60 + _endTime!.minute;
      if (end <= start) {
        AppBottomSheet.showError(
          context: context,
          message: 'Jam selesai harus setelah jam mulai.',
        );
        return;
      }
    }
    if (_attendanceEnabled &&
        _attendanceOpenAt != null &&
        _attendanceCloseAt != null &&
        !_attendanceCloseAt!.isAfter(_attendanceOpenAt!)) {
      AppBottomSheet.showError(
        context: context,
        message: 'Waktu tutup presensi harus setelah waktu buka.',
      );
      return;
    }
    if (_attendanceEnabled && _attendanceCloseAt != null && _endTime != null) {
      final eventEnd = DateTime(
        _date.year,
        _date.month,
        _date.day,
        _endTime!.hour,
        _endTime!.minute,
      );
      if (_attendanceCloseAt!.isBefore(eventEnd)) {
        AppBottomSheet.showError(
          context: context,
          message:
              'Waktu tutup presensi tidak boleh lebih awal dari waktu selesai kegiatan.',
        );
        return;
      }
    }
    if (_attendanceEnabled &&
        _locationEnabled &&
        (_latitude == null || _longitude == null)) {
      AppBottomSheet.showError(
        context: context,
        message: 'Pilih titik lokasi kegiatan terlebih dahulu.',
      );
      return;
    }

    setState(() => _submitting = true);
    final date = DateFormat('yyyy-MM-dd').format(_date);
    final error = await widget.onSubmit({
      'title': _title.text.trim(),
      'description': _description.text.trim().isEmpty
          ? null
          : _description.text.trim(),
      'start_date': date,
      'end_date': date,
      'start_time': _time(_startTime),
      'end_time': _time(_endTime),
      'all_day': _startTime == null && _endTime == null,
      'event_type': 'event_perusahaan',
      'color': '#087F75',
      'is_recurring': false,
      if (widget.initialEvent == null) ...{
        'delegated_to_all': true,
        'delegated_to_all_divisi': true,
        'delegated_to_all_cabang': true,
        'delegated_to_all_jabatan': true,
        'delegated_to_all_level': true,
        'selected_delegated_user_type': <String>[],
        'selected_delegated_divisi': <String>[],
        'selected_delegated_cabang': <String>[],
        'selected_delegated_jabatan': <String>[],
        'selected_delegated_level': <String>[],
        'selected_users': <String>[],
      },
      'status': 'active',
      'attendance_enabled': _attendanceEnabled,
      'attendance_open_at': _attendanceEnabled
          ? _dateTimeWithOffset(_attendanceOpenAt)
          : null,
      'attendance_close_at': _attendanceEnabled
          ? _dateTimeWithOffset(_attendanceCloseAt)
          : null,
      'attendance_location_name': _attendanceEnabled && _locationEnabled
          ? (_locationName.text.trim().isEmpty
                ? null
                : _locationName.text.trim())
          : null,
      'attendance_latitude': _attendanceEnabled && _locationEnabled
          ? _latitude
          : null,
      'attendance_longitude': _attendanceEnabled && _locationEnabled
          ? _longitude
          : null,
      'attendance_radius_meters': _attendanceEnabled && _locationEnabled
          ? _radius
          : null,
    });
    if (!mounted) return;
    setState(() => _submitting = false);
    if (error != null) {
      AppBottomSheet.showError(context: context, message: error);
      return;
    }
    Navigator.pop(context);
    AppSnackbar.showSuccess(
      context,
      widget.initialEvent == null
          ? 'Kegiatan berhasil ditambahkan'
          : 'Kegiatan berhasil diperbarui',
    );
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(
      left: 20,
      right: 20,
      top: 12,
      bottom: MediaQuery.viewInsetsOf(context).bottom + 20,
    ),
    child: Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.initialEvent == null
                      ? 'Tambah Kegiatan'
                      : 'Edit Kegiatan',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          TextFormField(
            controller: _title,
            decoration: const InputDecoration(labelText: 'Judul kegiatan *'),
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Judul wajib diisi'
                : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _description,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Keterangan'),
          ),
          const SizedBox(height: 12),
          _PickerTile(
            label: 'Tanggal kegiatan *',
            value: DateFormat('dd MMMM yyyy', 'id_ID').format(_date),
            onTap: _pickDate,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _PickerTile(
                  label: 'Jam mulai',
                  value: _time(_startTime) ?? 'Opsional',
                  onTap: () => _pickTime(true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PickerTile(
                  label: 'Jam selesai',
                  value: _time(_endTime) ?? 'Opsional',
                  onTap: () => _pickTime(false),
                ),
              ),
            ],
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _attendanceEnabled,
            onChanged: (value) => setState(() => _attendanceEnabled = value),
            title: const Text('Aktifkan presensi QR'),
            subtitle: const Text(
              'Kehadiran dicatat oleh petugas melalui QR karyawan.',
            ),
          ),
          if (_attendanceEnabled) ...[
            Row(
              children: [
                Expanded(
                  child: _PickerTile(
                    label: 'Buka presensi',
                    value: _attendanceOpenAt == null
                        ? 'Opsional'
                        : DateFormat(
                            'dd MMM, HH:mm',
                            'id_ID',
                          ).format(_attendanceOpenAt!),
                    onTap: () => _pickAttendanceDateTime(true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PickerTile(
                    label: 'Tutup presensi',
                    value: _attendanceCloseAt == null
                        ? 'Opsional'
                        : DateFormat(
                            'dd MMM, HH:mm',
                            'id_ID',
                          ).format(_attendanceCloseAt!),
                    onTap: () => _pickAttendanceDateTime(false),
                  ),
                ),
              ],
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _locationEnabled,
              onChanged: (value) => setState(() => _locationEnabled = value),
              title: const Text('Validasi lokasi petugas'),
            ),
            if (_locationEnabled) ...[
              TextFormField(
                controller: _locationName,
                decoration: const InputDecoration(labelText: 'Nama lokasi'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _pickLocation,
                icon: const Icon(Icons.location_on_outlined),
                label: Text(
                  _latitude == null
                      ? 'Pilih titik lokasi'
                      : '${_latitude!.toStringAsFixed(5)}, ${_longitude!.toStringAsFixed(5)}',
                ),
              ),
              DropdownButtonFormField<int>(
                initialValue: _radius,
                decoration: const InputDecoration(labelText: 'Radius validasi'),
                items: const [25, 50, 100, 200, 500]
                    .map(
                      (value) => DropdownMenuItem(
                        value: value,
                        child: Text('$value meter'),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _radius = value ?? 100),
              ),
            ],
          ],
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _submitting ? null : _submit,
            child: Text(_submitting ? 'Menyimpan...' : 'Simpan Kegiatan'),
          ),
        ],
      ),
    ),
  );
}

class _PickerTile extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _PickerTile({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: const Icon(Icons.chevron_right),
      ),
      child: Text(value, maxLines: 1, overflow: TextOverflow.ellipsis),
    ),
  );
}
