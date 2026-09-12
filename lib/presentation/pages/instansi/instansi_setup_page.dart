import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

import '../../../service/location_service.dart';
import '../../bloc/app/app_cubit.dart';

@RoutePage()
class InstansiSetupPage extends StatefulWidget {
  const InstansiSetupPage({super.key, this.initialEmail});

  final String? initialEmail;

  @override
  State<InstansiSetupPage> createState() => _InstansiSetupPageState();
}

class _InstansiSetupPageState extends State<InstansiSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _businessController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  String _timezone = 'Asia/Jakarta';
  String _currency = 'IDR';
  XFile? _logo;
  bool _isSubmitting = false;
  bool _isLocating = false;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.initialEmail ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _businessController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'Wajib diisi' : null;

  String? _emailValidator(String? value) {
    final required = _required(value);
    if (required != null) return required;
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value!.trim())
        ? null
        : 'Format email tidak valid';
  }

  String? _coordinateValidator(String? value) {
    final required = _required(value);
    if (required != null) return required;
    return double.tryParse(value!.trim()) == null
        ? 'Masukkan angka koordinat yang valid'
        : null;
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _isLocating = true);
    try {
      final location = await sl<LocationService>().getCurrentLocation();
      if (!mounted) return;
      _latitudeController.text = location.lat.toString();
      _longitudeController.text = location.long.toString();
    } catch (error) {
      if (mounted) {
        AppSnackbar.showError(context, 'Lokasi tidak dapat diambil: $error');
      }
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  Future<void> _pickLogo() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Pilih dari galeri'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Ambil dengan kamera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    try {
      final logo = await AppUtility.pickerImage(source);
      if (mounted) setState(() => _logo = logo);
    } catch (_) {
      // Pemilih gambar dapat dibatalkan tanpa menampilkan error.
    }
  }

  Future<void> _pickLocationOnMap() async {
    final initialLat =
        double.tryParse(_latitudeController.text) ?? kDDefaultLat;
    final initialLong =
        double.tryParse(_longitudeController.text) ?? kDDefaultLong;
    final result = await context.router.push<LocationPickerResult?>(
      LocationPickerPageRoute(initialLat: initialLat, initialLong: initialLong),
    );
    if (result == null || !mounted) return;
    setState(() {
      _latitudeController.text = result.position.latitude.toString();
      _longitudeController.text = result.position.longitude.toString();
    });
  }

  Future<void> _pickOption({
    required String title,
    required List<InstansiSelectOption> options,
    required ValueChanged<String> onSelected,
  }) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => _OptionPickerSheet(
        title: title,
        options: options,
        selectedValue: title.startsWith('Zona') ? _timezone : _currency,
      ),
    );
    if (selected != null && mounted) onSelected(selected);
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSubmitting = true);
    try {
      await sl<GraphQlService>().mutation(
        mutation:
            r'''mutation CreateInstansi($input: InstansiInput, $logo: Upload) {
          CreateInstansi(input: $input, logo_perusahaan: $logo) { _id nama_instansi }
        }''',
        variables: {
          'logo': _logo == null
              ? null
              : await _logo!.toCompressedMultipart(fieldName: 'logo'),
          'input': {
            'nama_instansi': _nameController.text.trim(),
            'email': _emailController.text.trim(),
            'telpon_number': _phoneController.text.trim(),
            'kegiatan_usaha': _businessController.text.trim(),
            'timezone_operational': _timezone,
            'currency': _currency,
            'lokasi': {
              'latitude': _latitudeController.text.trim(),
              'longitude': _longitudeController.text.trim(),
            },
          },
        },
      );
      if (!mounted) return;
      await AppModalBottom.showDefault(
        context,
        title: 'Instansi berhasil dibuat',
        contentTitle: 'Ruang kerja Anda siap',
        contentSubtitle: 'Instansi berhasil dibuat dan siap digunakan.',
        hasActionPop: true,
        yesOkLabel: 'Lanjutkan',
      );
      if (!mounted) return;
      context.read<AppCubit>().onRefresh();
      context.router.pushAndPopUntil(
        const MainPageRoute(),
        predicate: (route) => true,
      );
    } catch (error) {
      if (mounted) {
        AppSnackbar.showError(context, 'Gagal membuat instansi: $error');
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.bgPrimary,
        appBar: const AppTopBar(title: 'Lengkapi Instansi'),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimens.paddingMedium),
            child: Form(
              key: _formKey,
              child: AppCard(
                enableScaleAnimation: false,
                header: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Buat instansi untuk melanjutkan',
                      style: context.textStyle.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AppDimens.h8.hSpace,
                    Text(
                      'Isi data wajib berikut. Data lain dapat dilengkapi nanti melalui web.',
                      style: context.textStyle.bodyMedium,
                    ),
                  ],
                ),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          InkWell(
                            onTap: _pickLogo,
                            borderRadius: BorderRadius.circular(52),
                            child: CircleAvatar(
                              radius: 48,
                              backgroundColor: AppColors.grey.shade100,
                              backgroundImage: _logo == null
                                  ? null
                                  : FileImage(File(_logo!.path)),
                              child: _logo == null
                                  ? const Icon(
                                      Icons.add_a_photo_outlined,
                                      size: 30,
                                    )
                                  : null,
                            ),
                          ),
                          TextButton(
                            onPressed: _pickLogo,
                            child: Text(
                              _logo == null
                                  ? 'Unggah Logo (opsional)'
                                  : 'Ganti Logo',
                            ),
                          ),
                        ],
                      ),
                    ),
                    _field(
                      controller: _nameController,
                      label: 'Nama Instansi',
                      validator: _required,
                      textCapitalization: TextCapitalization.words,
                    ),
                    _field(
                      controller: _emailController,
                      label: 'Email',
                      validator: _emailValidator,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    _field(
                      controller: _phoneController,
                      label: 'Telepon',
                      validator: _required,
                      keyboardType: TextInputType.phone,
                    ),
                    _field(
                      controller: _businessController,
                      label: 'Kegiatan Usaha',
                      validator: _required,
                      maxLines: 3,
                    ),
                    _selectionField(
                      label: 'Zona Waktu Operasional',
                      value: _timezone,
                      onTap: () => _pickOption(
                        title: 'Zona Waktu Operasional',
                        options: InstansiOptionCatalog.timezones,
                        onSelected: (value) =>
                            setState(() => _timezone = value),
                      ),
                    ),
                    _selectionField(
                      label: 'Mata Uang',
                      value: InstansiOptionCatalog.currencies
                          .firstWhere((item) => item.value == _currency)
                          .label,
                      onTap: () => _pickOption(
                        title: 'Mata Uang',
                        options: InstansiOptionCatalog.currencies,
                        onSelected: (value) =>
                            setState(() => _currency = value),
                      ),
                    ),
                    AppDimens.h16.hSpace,
                    Text(
                      'Lokasi Instansi *',
                      style: context.textStyle.titleSmall,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        spacing: AppDimens.w8,
                        children: [
                          TextButton.icon(
                            onPressed: _isLocating ? null : _useCurrentLocation,
                            icon: _isLocating
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.my_location),
                            label: const Text('Gunakan GPS'),
                          ),
                          TextButton.icon(
                            onPressed: _pickLocationOnMap,
                            icon: const Icon(Icons.map_outlined),
                            label: const Text('Pilih Peta'),
                          ),
                        ],
                      ),
                    ),
                    _field(
                      controller: _latitudeController,
                      label: 'Latitude',
                      validator: _coordinateValidator,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                    ),
                    _field(
                      controller: _longitudeController,
                      label: 'Longitude',
                      validator: _coordinateValidator,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                    ),
                    AppDimens.h16.hSpace,
                    ElevatedButton(
                      onPressed: _isSubmitting ? null : _submit,
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Simpan dan Lanjutkan'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    int maxLines = 1,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: AppDimens.paddingMedium),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: '$label *'),
      validator: validator,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      maxLines: maxLines,
    ),
  );

  Widget _selectionField({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: AppDimens.paddingMedium),
    child: InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(labelText: '$label *'),
        child: Row(
          children: [
            Expanded(child: Text(value)),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    ),
  );
}

class _OptionPickerSheet extends StatefulWidget {
  const _OptionPickerSheet({
    required this.title,
    required this.options,
    required this.selectedValue,
  });

  final String title;
  final List<InstansiSelectOption> options;
  final String selectedValue;

  @override
  State<_OptionPickerSheet> createState() => _OptionPickerSheetState();
}

class _OptionPickerSheetState extends State<_OptionPickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final query = _query.toLowerCase();
    final options = widget.options
        .where((item) => item.label.toLowerCase().contains(query))
        .toList();
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * .78,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppDimens.paddingMedium),
                child: Text(
                  widget.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingMedium,
                ),
                child: TextField(
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Cari pilihan...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) => setState(() => _query = value),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    return ListTile(
                      title: Text(option.label),
                      trailing: option.value == widget.selectedValue
                          ? const Icon(Icons.check)
                          : null,
                      onTap: () => Navigator.of(context).pop(option.value),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
