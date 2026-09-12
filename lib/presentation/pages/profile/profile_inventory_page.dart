import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';
import 'package:presensi_mobile/presentation/widgets/global/text_field_custom/text_formatter.dart';

@RoutePage()
class ProfileInventoryPage extends StatefulWidget {
  const ProfileInventoryPage({super.key});

  @override
  State<ProfileInventoryPage> createState() => _ProfileInventoryPageState();
}

class _ProfileInventoryPageState extends State<ProfileInventoryPage> {
  DateTime? _parseDate(String? value) {
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }

  Future<void> _pickDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _parseDate(controller.text) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 10),
    );
    if (selected != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(selected);
    }
  }

  Future<void> _showEditVehicle(
    BuildContext pageContext,
    InventarisEntity vehicle,
    UserGetDataCubit userCubit,
  ) async {
    final serviceDate = TextEditingController(
      text: vehicle.jadwalServisTerakhir ?? '',
    );
    final currentKm = TextEditingController(
      text: vehicle.kilometerTerakhir ?? '',
    );
    final nextServiceKm = TextEditingController(
      text: vehicle.kilometerKembaliServis ?? '',
    );
    final taxDate = TextEditingController(
      text: vehicle.tanggalPembayaranPajak ?? '',
    );
    final rawTaxCost = (vehicle.totalBiayaPajak ?? '').replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );
    final taxCost = TextEditingController(
      text: rawTaxCost.isEmpty
          ? ''
          : NumberFormat.decimalPattern(
              'id_ID',
            ).format(int.tryParse(rawTaxCost) ?? 0),
    );
    final formKey = GlobalKey<FormState>();
    var isSaving = false;

    await showModalBottomSheet<void>(
      context: pageContext,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) {
          InputDecoration decoration(String label, {IconData? icon}) {
            return InputDecoration(
              hintText: 'Masukkan $label',
              suffixIcon: icon == null ? null : Icon(icon),
              border: const OutlineInputBorder(),
            );
          }

          Widget labeledField(String label, Widget field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: context.textStyle.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                field,
              ],
            );
          }

          String? validateNumber(String? value) {
            if (value == null || value.trim().isEmpty) return null;
            final parsed = num.tryParse(value.replaceAll('.', '').trim());
            if (parsed == null || parsed < 0) {
              return 'Masukkan angka yang valid';
            }
            return null;
          }

          return Padding(
            padding: EdgeInsets.fromLTRB(
              AppDimens.w16,
              AppDimens.h16,
              AppDimens.w16,
              MediaQuery.viewInsetsOf(context).bottom + AppDimens.h16,
            ),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Perbarui Kendaraan',
                      style: context.textStyle.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${vehicle.merk ?? '-'} • ${vehicle.platNomer ?? '-'}',
                      style: context.textStyle.bodyMedium?.copyWith(
                        color: AppColors.labelSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    labeledField(
                      'Kilometer Saat Ini',
                      TextFormField(
                        controller: currentKm,
                        keyboardType: TextInputType.number,
                        validator: validateNumber,
                        decoration: decoration('kilometer saat ini'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    labeledField(
                      'Pengingat Servis pada Kilometer',
                      TextFormField(
                        controller: nextServiceKm,
                        keyboardType: TextInputType.number,
                        validator: validateNumber,
                        decoration: decoration('kilometer pengingat servis'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    labeledField(
                      'Tanggal Servis Terakhir',
                      TextFormField(
                        controller: serviceDate,
                        readOnly: true,
                        onTap: () => _pickDate(context, serviceDate),
                        decoration: decoration(
                          'tanggal servis terakhir',
                          icon: Icons.calendar_month,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    labeledField(
                      'Jatuh Tempo Pajak Tahunan',
                      TextFormField(
                        controller: taxDate,
                        readOnly: true,
                        onTap: () => _pickDate(context, taxDate),
                        decoration: decoration(
                          'tanggal jatuh tempo pajak',
                          icon: Icons.calendar_month,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    labeledField(
                      'Biaya Pajak',
                      TextFormField(
                        controller: taxCost,
                        keyboardType: TextInputType.number,
                        inputFormatters: [IdrTextInputFormatter()],
                        validator: validateNumber,
                        decoration: decoration(
                          'biaya pajak',
                        ).copyWith(prefixText: 'Rp '),
                      ),
                    ),
                    const SizedBox(height: 20),
                    AppButtonNew(
                      text: 'Simpan Perubahan',
                      isLoading: isSaving,
                      onPressed: () async {
                        if (isSaving ||
                            !(formKey.currentState?.validate() ?? false)) {
                          return;
                        }
                        setSheetState(() => isSaving = true);
                        final result = await sl<UserRepository>()
                            .updateVehicle(vehicle.id!, {
                              if (currentKm.text.trim().isNotEmpty)
                                'kilometer_terakhir': currentKm.text.trim(),
                              if (nextServiceKm.text.trim().isNotEmpty)
                                'kilometer_kembali_servis': nextServiceKm.text
                                    .trim(),
                              if (serviceDate.text.isNotEmpty)
                                'jadwal_servis_terakhir': serviceDate.text,
                              if (taxDate.text.isNotEmpty)
                                'tanggal_pembayaran_pajak': taxDate.text,
                              if (taxCost.text.trim().isNotEmpty)
                                'total_biaya_pajak': taxCost.text
                                    .replaceAll('.', '')
                                    .trim(),
                            });
                        if (!context.mounted) return;
                        await result.fold(
                          (failure) async {
                            setSheetState(() => isSaving = false);
                            AppSnackbar.showError(context, failure.message);
                          },
                          (_) async {
                            Navigator.pop(context);
                            await userCubit.getData(false);
                            if (pageContext.mounted) {
                              AppSnackbar.showSuccess(
                                pageContext,
                                'Data kendaraan berhasil diperbarui',
                              );
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );

    serviceDate.dispose();
    currentKm.dispose();
    nextServiceKm.dispose();
    taxDate.dispose();
    taxCost.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: const AppTopBar(title: 'Kendaraan'),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => sl<UserGetLocalCubit>()..getData()),
          BlocProvider(create: (context) => sl<UserGetDataCubit>()..getData()),
        ],
        child: BlocBuilder<UserGetDataCubit, UserGetDataState>(
          builder: (ctxUser, stateData) {
            return BlocBuilder<UserGetLocalCubit, UserGetLocalState>(
              builder: (context, stateLocal) {
                final userInventory =
                    stateData.data?.user?.inventaris ??
                    stateLocal.data?.user?.inventaris;
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimens.paddingMedium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppCard(
                          showHeaderDivider: true,
                          header: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Data Kendaraan',
                                  style: context.textStyle.titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                ),
                              ),
                              if (userInventory?.id != null)
                                IconButton(
                                  tooltip: 'Perbarui kendaraan',
                                  onPressed: () => _showEditVehicle(
                                    context,
                                    userInventory!,
                                    ctxUser.read<UserGetDataCubit>(),
                                  ),
                                  icon: const Icon(Icons.edit_outlined),
                                  color: AppColors.primary,
                                ),
                            ],
                          ),
                          content: Column(
                            children: [
                              ProfileFieldRow(
                                title: 'Jenis Kendaraan',
                                value: AppUtility.nullHandler(
                                  userInventory
                                      ?.jenisKendaraan
                                      ?.toJenisKendaraan
                                      ?.toName,
                                  fallback: '-',
                                ),
                              ),
                              ProfileFieldRow(
                                title: 'Merk/Plat Nomor',
                                value: AppUtility.nullHandler(
                                  '${userInventory?.merk ?? ''} ${userInventory?.platNomer ?? '-'}',
                                  fallback: '-',
                                ),
                              ),
                              ProfileFieldRow(
                                title: 'Kilomenter Terakhir',
                                value: AppUtility.nullHandler(
                                  userInventory?.kilometerTerakhir?.toKilometer,
                                  fallback: '-',
                                ),
                              ),
                              ProfileFieldRow(
                                title: 'Tanggal Pembayaran',
                                value: AppUtility.nullHandler(
                                  userInventory
                                      ?.tanggalPembayaranPajak
                                      ?.toDateTime
                                      ?.yMMMMd,
                                  fallback: '-',
                                ),
                              ),
                              ProfileFieldRow(
                                title: 'Jadwal Service',
                                value: AppUtility.nullHandler(
                                  userInventory
                                      ?.jadwalServisTerakhir
                                      ?.toDateTime
                                      ?.yMMMMd,
                                  fallback: '-',
                                ),
                              ),
                              ProfileFieldRow(
                                title: 'Biaya Pajak',
                                value: AppUtility.nullHandler(
                                  userInventory?.totalBiayaPajak?.toCurrency,
                                  fallback: '-',
                                ),
                              ),
                            ],
                          ),
                        ),
                        AppDimens.paddingLarge.hSpace,
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
