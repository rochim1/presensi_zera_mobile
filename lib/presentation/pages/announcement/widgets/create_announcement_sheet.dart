import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

class CreateAnnouncementSheet extends StatefulWidget {
  final Future<String?> Function(Map<String, dynamic>) onSubmit;
  final Announcement? initialAnnouncement;
  const CreateAnnouncementSheet({
    super.key,
    required this.onSubmit,
    this.initialAnnouncement,
  });

  static Future<void> show(
    BuildContext context, {
    required Future<String?> Function(Map<String, dynamic>) onSubmit,
    Announcement? initialAnnouncement,
  }) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => CreateAnnouncementSheet(
      onSubmit: onSubmit,
      initialAnnouncement: initialAnnouncement,
    ),
  );

  @override
  State<CreateAnnouncementSheet> createState() =>
      _CreateAnnouncementSheetState();
}

class _CreateAnnouncementSheetState extends State<CreateAnnouncementSheet> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _content = TextEditingController();
  final _link = TextEditingController();
  String _category = 'umum';
  String _priority = 'sedang';
  late DateTime _start;
  DateTime? _end;
  bool _pinned = false;
  bool _showPopup = false;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final item = widget.initialAnnouncement;
    _start = item?.tanggalMulai ?? DateTime.now();
    _end = item?.tanggalBerakhir;
    _title.text = item?.judul ?? '';
    _content.text = item?.isi ?? '';
    _link.text = item?.linkUrl ?? '';
    _category = item?.kategori ?? 'umum';
    _priority = item?.prioritas.name ?? 'sedang';
    _pinned = item?.isPinned ?? false;
    _showPopup = item?.showPopup ?? false;
  }

  @override
  void dispose() {
    _title.dispose();
    _content.dispose();
    _link.dispose();
    super.dispose();
  }

  Future<void> _pickDate(bool start) async {
    final current = start ? _start : (_end ?? _start);
    final date = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: start
          ? DateTime(2020)
          : DateTime(_start.year, _start.month, _start.day),
      lastDate: DateTime(2100),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(current),
    );
    if (time == null) return;
    final value = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    setState(() {
      if (start) {
        _start = value;
        if (_end != null && _end!.isBefore(value)) _end = null;
      } else {
        _end = value;
      }
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final link = _link.text.trim();
    final parsedLink = Uri.tryParse(link);
    if (link.isNotEmpty && (parsedLink == null || !parsedLink.isAbsolute)) {
      AppSnackbar.showError(context, 'Link harus berupa URL lengkap');
      return;
    }
    setState(() => _submitting = true);
    final error = await widget.onSubmit({
      'judul': _title.text.trim(),
      'isi': _content.text.trim(),
      'kategori': _category,
      'prioritas': _priority,
      'tanggal_mulai': _start.toIso8601String(),
      'tanggal_berakhir': _end?.toIso8601String(),
      'link_url': link.isEmpty ? null : link,
      'banner_image': null,
      'lampiran': <Map<String, dynamic>>[],
      'is_pinned': _pinned,
      'show_popup': _showPopup,
    });
    if (!mounted) return;
    setState(() => _submitting = false);
    if (error != null) {
      AppSnackbar.showError(context, 'Gagal menambahkan pengumuman: $error');
      return;
    }
    Navigator.pop(context);
    AppSnackbar.showSuccess(
      context,
      widget.initialAnnouncement == null
          ? 'Pengumuman berhasil ditambahkan'
          : 'Pengumuman berhasil diperbarui',
    );
  }

  String _format(DateTime value) =>
      DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(value);

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
                  widget.initialAnnouncement == null
                      ? 'Tambah Pengumuman'
                      : 'Edit Pengumuman',
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
            controller: _content,
            minLines: 4,
            maxLines: 7,
            decoration: const InputDecoration(
              labelText: 'Isi Pengumuman *',
              alignLabelWithHint: true,
            ),
            validator: (v) => v == null || v.trim().isEmpty
                ? 'Isi pengumuman wajib diisi'
                : null,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _category,
                  decoration: const InputDecoration(labelText: 'Kategori'),
                  items: const [
                    DropdownMenuItem(value: 'umum', child: Text('Umum')),
                    DropdownMenuItem(value: 'hr', child: Text('HR')),
                    DropdownMenuItem(
                      value: 'keuangan',
                      child: Text('Keuangan'),
                    ),
                    DropdownMenuItem(
                      value: 'operasional',
                      child: Text('Operasional'),
                    ),
                    DropdownMenuItem(value: 'lainnya', child: Text('Lainnya')),
                  ],
                  onChanged: (v) => setState(() => _category = v!),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _priority,
                  decoration: const InputDecoration(labelText: 'Prioritas'),
                  items: const [
                    DropdownMenuItem(value: 'rendah', child: Text('Rendah')),
                    DropdownMenuItem(value: 'sedang', child: Text('Sedang')),
                    DropdownMenuItem(value: 'tinggi', child: Text('Tinggi')),
                    DropdownMenuItem(value: 'urgent', child: Text('Urgent')),
                  ],
                  onChanged: (v) => setState(() => _priority = v!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _DateTimeTile(
            label: 'Mulai *',
            value: _format(_start),
            onTap: () => _pickDate(true),
          ),
          const SizedBox(height: 12),
          _DateTimeTile(
            label: 'Berakhir',
            value: _end == null ? 'Tidak ditentukan' : _format(_end!),
            onTap: () => _pickDate(false),
            onClear: _end == null ? null : () => setState(() => _end = null),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _link,
            keyboardType: TextInputType.url,
            decoration: const InputDecoration(
              labelText: 'Link Tujuan',
              hintText: 'https://...',
            ),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Sematkan Pengumuman'),
            subtitle: const Text('Tampilkan di bagian teratas'),
            value: _pinned,
            onChanged: (v) => setState(() => _pinned = v),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Tampilkan sebagai Popup'),
            value: _showPopup,
            onChanged: (v) => setState(() => _showPopup = v),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _submitting ? null : _submit,
            child: Text(
              _submitting
                  ? 'Menyimpan...'
                  : widget.initialAnnouncement == null
                  ? 'Simpan Pengumuman'
                  : 'Simpan Perubahan',
            ),
          ),
        ],
      ),
    ),
  );
}

class _DateTimeTile extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  final VoidCallback? onClear;
  const _DateTimeTile({
    required this.label,
    required this.value,
    required this.onTap,
    this.onClear,
  });
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: onClear == null
            ? const Icon(Icons.calendar_month)
            : IconButton(onPressed: onClear, icon: const Icon(Icons.close)),
      ),
      child: Text(value),
    ),
  );
}
