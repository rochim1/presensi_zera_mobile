import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:presensi_domain/presensi_domain.dart';

import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/bloc/order/product_get_all/product_get_all_cubit.dart';
import 'package:presensi_mobile/presentation/pages/inventory/incidental/bloc/incidental_report_form_cubit.dart';
import 'package:presensi_mobile/presentation/pages/inventory/incidental/bloc/incidental_report_form_state.dart';
import 'package:presensi_mobile/presentation/widgets/_widgets.dart';

@RoutePage()
class IncidentalReportFormPage extends StatefulWidget {
  const IncidentalReportFormPage({super.key});

  @override
  State<IncidentalReportFormPage> createState() =>
      _IncidentalReportFormPageState();
}

class _IncidentalReportFormPageState extends State<IncidentalReportFormPage> {
  final _cubit = sl<IncidentalReportFormCubit>();
  final _formKey = GlobalKey<FormState>();

  ProductEntity? _selectedItem;
  InventoryLocationBalance? _selectedLocation;
  List<InventoryLocationBalance> _locations = const [];
  bool _isLoadingLocations = false;
  String _jenisInsiden = 'kerusakan';
  String _tindakan = 'kurangi_stok';

  final _jumlahController = TextEditingController();
  final _jumlahRecycleController = TextEditingController();
  final _keteranganController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  Future<void> _selectProduct() async {
    final selected = await showModalBottomSheet<ProductEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _IncidentalProductSelectionSheet(),
    );

    if (selected == null || !mounted) return;
    setState(() {
      _selectedItem = selected;
      _selectedLocation = null;
      _locations = const [];
      _isLoadingLocations = true;
    });
    final result = await sl<GetInventoryLocationBalancesUseCase>()(
      selected.id!,
    );
    if (!mounted) return;
    result.fold(
      (failure) {
        setState(() => _isLoadingLocations = false);
        AppSnackbar.showError(context, failure.message);
      },
      (locations) => setState(() {
        _locations = locations.where((item) => item.quantity > 0).toList();
        _selectedLocation = _locations.length == 1 ? _locations.first : null;
        _isLoadingLocations = false;
      }),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _jumlahController.dispose();
    _jumlahRecycleController.dispose();
    _keteranganController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedItem == null) {
        AppSnackbar.showError(context, 'Pilih barang terlebih dahulu');
        return;
      }
      if (_selectedLocation == null) {
        AppSnackbar.showError(context, 'Pilih lokasi stok terlebih dahulu');
        return;
      }

      final jumlah = int.tryParse(_jumlahController.text) ?? 0;
      final jumlahRecycle = int.tryParse(_jumlahRecycleController.text) ?? 0;

      if (jumlah <= 0) {
        AppSnackbar.showError(context, 'Jumlah terdampak harus lebih dari 0');
        return;
      }

      if (_tindakan == 'recycle' && jumlahRecycle > jumlah) {
        AppSnackbar.showError(
          context,
          'Hasil recycle tidak boleh melebihi jumlah terdampak',
        );
        return;
      }

      final input = {
        'tanggal_scrap': DateFormat('yyyy-MM-dd').format(_selectedDate),
        'alasan': _jenisInsiden == 'kehilangan'
            ? 'hilang'
            : _jenisInsiden == 'kadaluarsa'
            ? 'kadaluarsa'
            : _jenisInsiden == 'lainnya'
            ? 'lainnya'
            : 'rusak',
        'alasan_detail': _keteranganController.text,
        'jenis_insiden': _jenisInsiden,
        'lokasi_kejadian': _selectedLocation!.label,
        'items': [
          {
            'inventaris_id': _selectedItem!.id,
            'stock_balance_id': _selectedLocation!.id,
            'qty': jumlah,
            'tindakan': _tindakan,
            'jumlah_hasil_recycle': _tindakan == 'recycle' ? jumlahRecycle : 0,
            'catatan_item': _keteranganController.text,
          },
        ],
        'catatan': _keteranganController.text,
      };

      _cubit.submitReport(input);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<IncidentalReportFormCubit, IncidentalReportFormState>(
        listener: (context, state) {
          if (state.failure != null) {
            AppSnackbar.showError(context, state.failure!.message);
          }
          if (state.isSuccess) {
            AppSnackbar.showSuccess(context, 'Laporan insiden berhasil dibuat');
            context.router.maybePop(true);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: const AppBarWidget(titleText: 'Buat Laporan Insiden'),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pilih Barang',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: _selectProduct,
                      borderRadius: BorderRadius.circular(12),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          suffixIcon: const Icon(Icons.search),
                        ),
                        child: _selectedItem == null
                            ? const Text(
                                'Pilih produk',
                                style: TextStyle(color: Colors.grey),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _selectedItem!.namaInventaris ?? '-',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${_selectedItem!.sku ?? _selectedItem!.kodeInventaris ?? '-'} • Stok: ${_selectedItem!.stok ?? 0} ${_selectedItem!.unit ?? _selectedItem!.baseUnit ?? ''}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Jenis Insiden',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                isExpanded: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                                initialValue: _jenisInsiden,
                                items: const [
                                  DropdownMenuItem(
                                    value: 'kerusakan',
                                    child: Text('Kerusakan'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'kecelakaan',
                                    child: Text('Kecelakaan'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'mencair',
                                    child: Text('Mencair/Rusak'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'kehilangan',
                                    child: Text('Kehilangan'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'kadaluarsa',
                                    child: Text('Kadaluarsa'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'tumpah',
                                    child: Text('Tumpah/Bocor'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'lainnya',
                                    child: Text('Lainnya'),
                                  ),
                                ],
                                onChanged: (val) =>
                                    setState(() => _jenisInsiden = val!),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Lokasi Kejadian',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<InventoryLocationBalance>(
                                isExpanded: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                                hint: Text(
                                  _selectedItem == null
                                      ? 'Pilih produk dulu'
                                      : _isLoadingLocations
                                      ? 'Memuat lokasi...'
                                      : 'Pilih lokasi',
                                ),
                                initialValue: _selectedLocation,
                                items: _locations
                                    .map(
                                      (location) => DropdownMenuItem(
                                        value: location,
                                        child: Text(
                                          '${location.label.isEmpty ? 'Lokasi stok' : location.label} (${location.quantity})',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: _isLoadingLocations
                                    ? null
                                    : (val) => setState(
                                        () => _selectedLocation = val,
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Tindakan',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      initialValue: _tindakan,
                      items: const [
                        DropdownMenuItem(
                          value: 'kurangi_stok',
                          child: Text('Kurangi Stok (Net Lost)'),
                        ),
                        DropdownMenuItem(
                          value: 'recycle',
                          child: Text('Recycle (Sebagian/Semua)'),
                        ),
                      ],
                      onChanged: (val) => setState(() => _tindakan = val!),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Jumlah Terdampak',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _jumlahController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  hintText: 'Mis: 10',
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                                validator: (val) =>
                                    val == null || val.isEmpty ? 'Wajib' : null,
                              ),
                            ],
                          ),
                        ),
                        if (_tindakan == 'recycle') ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Hasil Recycle',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _jumlahRecycleController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    hintText: 'Mis: 8',
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                  ),
                                  validator: (val) => val == null || val.isEmpty
                                      ? 'Wajib'
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Waktu Kejadian',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          if (!context.mounted) return;
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(_selectedDate),
                          );
                          if (time != null) {
                            setState(() {
                              _selectedDate = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                time.hour,
                                time.minute,
                              );
                            });
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat(
                                'dd MMM yyyy, HH:mm',
                              ).format(_selectedDate),
                            ),
                            const Icon(
                              Icons.calendar_today,
                              size: 20,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Keterangan',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _keteranganController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'Catatan tambahan...',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: AppButton(
                onPressed: state.isSubmitting ? () {} : _submit,
                text: 'Simpan Laporan',
                isLoading: state.isSubmitting,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _IncidentalProductSelectionSheet extends StatefulWidget {
  const _IncidentalProductSelectionSheet();

  @override
  State<_IncidentalProductSelectionSheet> createState() =>
      _IncidentalProductSelectionSheetState();
}

class _IncidentalProductSelectionSheetState
    extends State<_IncidentalProductSelectionSheet> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProductGetAllCubit>()..fetch(),
      child: SafeArea(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.82,
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Pilih Produk',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Cari produk atau SKU...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) =>
                      setState(() => _search = value.trim().toLowerCase()),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: BlocBuilder<ProductGetAllCubit, ProductGetAllState>(
                    builder: (context, state) {
                      if (state.status.isInitial || state.status.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state.status.isNotLoaded) {
                        return Center(
                          child: Text(
                            state.failure?.message ?? 'Gagal memuat produk',
                            textAlign: TextAlign.center,
                          ),
                        );
                      }

                      final products = state.data.where((product) {
                        if (_search.isEmpty) return true;
                        return (product.namaInventaris ?? '')
                                .toLowerCase()
                                .contains(_search) ||
                            (product.sku ?? '').toLowerCase().contains(
                              _search,
                            ) ||
                            (product.kodeInventaris ?? '')
                                .toLowerCase()
                                .contains(_search);
                      }).toList();

                      if (products.isEmpty) {
                        return const Center(
                          child: Text('Produk tidak ditemukan'),
                        );
                      }

                      return ListView.separated(
                        itemCount: products.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 6,
                            ),
                            title: Text(
                              product.namaInventaris ?? '-',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              'SKU: ${product.sku ?? product.kodeInventaris ?? '-'}',
                            ),
                            trailing: Text(
                              'Stok: ${product.stok ?? 0}\n${product.unit ?? product.baseUnit ?? ''}',
                              textAlign: TextAlign.right,
                              style: const TextStyle(fontSize: 12),
                            ),
                            onTap: product.id == null
                                ? null
                                : () => Navigator.pop(context, product),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
