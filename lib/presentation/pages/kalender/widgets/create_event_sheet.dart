import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

class CreateCalendarEventSheet extends StatefulWidget {
  final DateTime initialDate;
  final Future<String?> Function(Map<String, dynamic>) onSubmit;
  final KalenderEvent? initialEvent;

  const CreateCalendarEventSheet({
    super.key,
    required this.initialDate,
    required this.onSubmit,
    this.initialEvent,
  });

  static Future<void> show(
    BuildContext context, {
    required DateTime initialDate,
    required Future<String?> Function(Map<String, dynamic>) onSubmit,
    KalenderEvent? initialEvent,
  }) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => CreateCalendarEventSheet(
      initialDate: initialDate,
      onSubmit: onSubmit,
      initialEvent: initialEvent,
    ),
  );

  @override
  State<CreateCalendarEventSheet> createState() =>
      _CreateCalendarEventSheetState();
}

class _CreateCalendarEventSheetState extends State<CreateCalendarEventSheet> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  late DateTime _startDate;
  DateTime? _endDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String _eventType = 'lainnya';
  String _color = '#6c757d';
  bool _allDay = true;
  bool _recurring = false;
  String? _recurringType;
  bool _submitting = false;

  static const _types = {
    'hari_libur_nasional': 'Hari Libur Nasional',
    'hari_libur_perusahaan': 'Hari Libur Perusahaan',
    'cuti_bersama': 'Cuti Bersama',
    'lainnya': 'Lainnya',
  };
  static const _colors = [
    '#dc3545',
    '#fd7e14',
    '#ffc107',
    '#28a745',
    '#17a2b8',
    '#007bff',
    '#6610f2',
    '#6c757d',
  ];

  @override
  void initState() {
    super.initState();
    final event = widget.initialEvent;
    _startDate =
        DateTime.tryParse(event?.startDate ?? '') ?? widget.initialDate;
    _endDate = DateTime.tryParse(event?.endDate ?? '');
    _title.text = event?.title ?? '';
    _description.text = event?.description ?? '';
    _eventType = event?.eventType ?? 'lainnya';
    _color = event?.color ?? '#6c757d';
    _allDay = event?.allDay ?? true;
    _recurring = event?.isRecurring ?? false;
    _recurringType = event?.recurringType;
    _startTime = _parseTime(event?.startTime);
    _endTime = _parseTime(event?.endTime);
  }

  TimeOfDay? _parseTime(String? value) {
    if (value == null || value.isEmpty) return null;
    final parts = value.split(':');
    if (parts.length < 2) return null;
    return TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 0,
      minute: int.tryParse(parts[1]) ?? 0,
    );
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  String _date(DateTime value) => DateFormat('yyyy-MM-dd').format(value);
  String? _time(TimeOfDay? value) => value == null
      ? null
      : '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';

  Future<void> _pickDate(bool start) async {
    final value = await showDatePicker(
      context: context,
      initialDate: start ? _startDate : (_endDate ?? _startDate),
      firstDate: start ? DateTime(2020) : _startDate,
      lastDate: DateTime(2100),
    );
    if (value == null) return;
    setState(() {
      if (start) {
        _startDate = value;
        if (_endDate != null && _endDate!.isBefore(value)) _endDate = value;
      } else {
        _endDate = value;
      }
    });
  }

  Future<void> _pickTime(bool start) async {
    final value = await showTimePicker(
      context: context,
      initialTime: start
          ? (_startTime ?? TimeOfDay.now())
          : (_endTime ?? TimeOfDay.now()),
    );
    if (value == null) return;
    setState(() => start ? _startTime = value : _endTime = value);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_recurring && _recurringType == null) {
      AppSnackbar.showError(context, 'Pilih tipe pengulangan');
      return;
    }
    setState(() => _submitting = true);
    final error = await widget.onSubmit({
      'title': _title.text.trim(),
      'description': _description.text.trim().isEmpty
          ? null
          : _description.text.trim(),
      'event_type': _eventType,
      'color': _color,
      'all_day': _allDay,
      'start_date': _date(_startDate),
      'end_date': _date(_endDate ?? _startDate),
      'start_time': _allDay ? null : _time(_startTime),
      'end_time': _allDay ? null : _time(_endTime),
      'is_recurring': _recurring,
      'recurring_type': _recurring ? _recurringType : null,
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
      'status': 'active',
    });
    if (!mounted) return;
    setState(() => _submitting = false);
    if (error != null) {
      AppSnackbar.showError(context, 'Gagal menambahkan event: $error');
      return;
    }
    Navigator.pop(context);
    AppSnackbar.showSuccess(
      context,
      widget.initialEvent == null
          ? 'Event berhasil ditambahkan'
          : 'Event berhasil diperbarui',
    );
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(
      left: 20,
      right: 20,
      top: 16,
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
                  widget.initialEvent == null ? 'Tambah Event' : 'Edit Event',
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
            decoration: const InputDecoration(labelText: 'Judul *'),
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Judul wajib diisi' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _description,
            maxLines: 2,
            decoration: const InputDecoration(labelText: 'Deskripsi'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _eventType,
            decoration: const InputDecoration(labelText: 'Tipe Event *'),
            items: _types.entries
                .map(
                  (e) => DropdownMenuItem(value: e.key, child: Text(e.value)),
                )
                .toList(),
            onChanged: (v) => setState(() => _eventType = v!),
          ),
          const SizedBox(height: 12),
          Text('Warna', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            children: _colors.map((hex) {
              final color = Color(
                int.parse('FF${hex.substring(1)}', radix: 16),
              );
              return InkWell(
                onTap: () => setState(() => _color = hex),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: color,
                  child: _color == hex
                      ? const Icon(Icons.check, color: Colors.white, size: 18)
                      : null,
                ),
              );
            }).toList(),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Seharian'),
            value: _allDay,
            onChanged: (v) => setState(() => _allDay = v),
          ),
          Row(
            children: [
              Expanded(
                child: _PickerTile(
                  label: 'Tanggal Mulai *',
                  value: DateFormat('dd MMM yyyy', 'id_ID').format(_startDate),
                  onTap: () => _pickDate(true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PickerTile(
                  label: 'Tanggal Selesai',
                  value: DateFormat(
                    'dd MMM yyyy',
                    'id_ID',
                  ).format(_endDate ?? _startDate),
                  onTap: () => _pickDate(false),
                ),
              ),
            ],
          ),
          if (!_allDay) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _PickerTile(
                    label: 'Waktu Mulai',
                    value: _time(_startTime) ?? 'Pilih',
                    onTap: () => _pickTime(true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PickerTile(
                    label: 'Waktu Selesai',
                    value: _time(_endTime) ?? 'Pilih',
                    onTap: () => _pickTime(false),
                  ),
                ),
              ],
            ),
          ],
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Event Berulang'),
            value: _recurring,
            onChanged: (v) => setState(() {
              _recurring = v;
              if (!v) _recurringType = null;
            }),
          ),
          if (_recurring)
            DropdownButtonFormField<String>(
              initialValue: _recurringType,
              decoration: const InputDecoration(
                labelText: 'Tipe Pengulangan *',
              ),
              items: const [
                DropdownMenuItem(value: 'yearly', child: Text('Tahunan')),
                DropdownMenuItem(value: 'monthly', child: Text('Bulanan')),
                DropdownMenuItem(value: 'weekly', child: Text('Mingguan')),
              ],
              onChanged: (v) => setState(() => _recurringType = v),
            ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _submitting ? null : _submit,
            child: Text(
              _submitting
                  ? 'Menyimpan...'
                  : widget.initialEvent == null
                  ? 'Simpan Event'
                  : 'Simpan Perubahan',
            ),
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
    child: InputDecorator(
      decoration: InputDecoration(labelText: label),
      child: Text(value),
    ),
  );
}
