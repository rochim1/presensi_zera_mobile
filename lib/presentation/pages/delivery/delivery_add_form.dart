import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_cubit.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_state.dart';
import 'package:presensi_mobile/presentation/bloc/delivery_order/delivery_order_get_all_cubit.dart';
import 'package:presensi_mobile/presentation/pages/delivery/widgets/do_picker_sheet.dart';
import 'package:presensi_mobile/presentation/pages/delivery/widgets/invoice_picker_sheet.dart';
import 'package:presensi_mobile/presentation/widgets/apotek/apotek_item_card.dart';

@RoutePage()
class DeliveryAddForm extends StatefulWidget {
  const DeliveryAddForm({super.key});

  @override
  State<DeliveryAddForm> createState() => _DeliveryAddFormState();
}

class _DeliveryAddFormState extends State<DeliveryAddForm> {
  late GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late ApotekEntity? apotek = const ApotekEntity();
  late InventarisEntity? inventaris = const InventarisEntity();
  late TextEditingController catatan;
  late TextEditingController tanggal;

  bool isHybridMode = false;
  bool allowMobileChangeVisitVehicle = false;

  bool tujuanPengantaran = false;
  bool tujuanPenawaran = false;
  bool tujuanPenagihan = false;

  // Full Mode: selected DOs and Invoices from pickers
  List<DeliveryOrderEntity> selectedDOs = [];
  List<SalesOrderEntity> selectedInvoices = [];

  @override
  void initState() {
    super.initState();
    catatan = TextEditingController();
    tanggal = TextEditingController(text: DateTime.now().toIso8601String());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = context.read<AppCubit>().state;
      setState(() {
        isHybridMode = appState.setting.data?.isHybridMode ?? false;
        allowMobileChangeVisitVehicle =
            appState.setting.data?.allowMobileChangeVisitVehicle ?? false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    Debounce.cancelAll();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<TasksGetAllApotikCubit>()..getAllDataSearch(),
        ),
        BlocProvider(
          create: (context) => sl<UserGetAllInventarisCubit>()..getAllData(),
        ),
        BlocProvider(create: (context) => sl<UserGetLocalCubit>()..getData()),
        BlocProvider(create: (context) => sl<TasksPostDataCubit>()),
        BlocProvider(create: (context) => sl<DeliveryOrderGetAllCubit>()),
        BlocProvider(create: (context) => sl<OrderGetAllSalesOrdersCubit>()),
      ],
      child: BlocListener<AppCubit, AppState>(
        listener: (context, state) {
          if (state.setting.isSuccess) {
            final newHybrid = state.setting.data?.isHybridMode ?? false;
            final newAllowVehicleChange =
                state.setting.data?.allowMobileChangeVisitVehicle ?? false;
            if (newHybrid != isHybridMode ||
                newAllowVehicleChange != allowMobileChangeVisitVehicle) {
              setState(() {
                isHybridMode = newHybrid;
                allowMobileChangeVisitVehicle = newAllowVehicleChange;
              });
            }
          }
        },
        child: Builder(
          builder: (context) {
            return UnfocuserForm(
              child: Scaffold(
                appBar: const AppTopBar(title: 'Tambah Kunjungan Baru'),
                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppDimens.paddingMediumX),
                  child: Form(
                    key: formKey,
                    child: BlocConsumer<UserGetAllInventarisCubit, UserGetAllInventarisState>(
                      listener: (_, state) async {
                        if (state.status.isNotLoaded &&
                            allowMobileChangeVisitVehicle) {
                          await Fluttertoast.showToast(
                            msg: state.failure!.message,
                          );

                          if (!context.mounted) return;
                          context.router.pop();
                        }
                      },
                      builder: (_, invState) {
                        return Column(
                          children: [
                            _buildCard(
                              context,
                              title: 'Data Kunjungan',
                              children: [
                                BlocConsumer<
                                  TasksGetAllApotikCubit,
                                  TasksGetAllApotikState
                                >(
                                  listener: (_, state) async {
                                    if (state.status.isNotLoaded) {
                                      await Fluttertoast.showToast(
                                        msg: state.failure!.message,
                                      );

                                      if (!context.mounted) return;
                                      context.router.pop();
                                    }
                                  },
                                  builder: (context, state) {
                                    if (state.status.isLoaded) {
                                      return TextFieldDropdownSearch<
                                        ApotekEntity
                                      >(
                                        title: 'Outlet',
                                        hint: 'Pilih Outlet',
                                        items: const [],
                                        asyncItems: (String filter) async {
                                          final usecase =
                                              sl<ApotekGetAllData>();
                                          final params = ApotekFilterEntity(
                                            namaApotek: filter,
                                            pagination:
                                                const GlobalPaginationEntity(
                                                  page: 0,
                                                  limit: 100,
                                                ),
                                          );
                                          final result = await usecase(params);
                                          return result.fold(
                                            (l) => <ApotekEntity>[],
                                            (r) => r,
                                          );
                                        },
                                        required: true,
                                        colorTitle: AppColors.labelSecondary,
                                        itemAsString: (element) =>
                                            '${element.namaApotik} ${element.kodeApotik == null ? '' : ' - ${element.kodeApotik}'}',
                                        compareFn: (selected, val) =>
                                            val == null
                                            ? false
                                            : selected == val,
                                        validator: (value) {
                                          if (value == null) {
                                            return kNotSelectedValidator.rich([
                                              'Outlet',
                                            ]);
                                          }
                                          return null;
                                        },
                                        onChanged: (value) =>
                                            setState(() => apotek = value),
                                        onAdd: () async {
                                          final result = await context.router
                                              .push<bool?>(
                                                const ApotekAddFormRoute(),
                                              );

                                          if (!context.mounted) return;
                                          if (result ?? false) {
                                            context
                                                .read<TasksGetAllApotikCubit>()
                                                .getAllDataSearch();
                                          }
                                        },
                                      );
                                    } else if (state.status.isNotLoaded) {
                                      return TextFieldDropdownSearch<String>(
                                        title: 'Outlet',
                                        hint: 'Pilih Outlet',
                                        required: true,
                                        colorTitle: AppColors.labelSecondary,
                                        items: const [],
                                        itemAsString: (element) => element,
                                        validator: (value) {
                                          if (value == null) {
                                            return kNotSelectedValidator.rich([
                                              'Outlet',
                                            ]);
                                          }
                                          return null;
                                        },
                                      );
                                    } else {
                                      return const TextFieldShimmer(
                                        title: 'Outlet',
                                      );
                                    }
                                  },
                                ),
                                if (apotek?.namaApotik != null) ...[
                                  AppDimens.size2M.hSpace,
                                  ApotekItemCard(apotek: apotek!),
                                ],
                                AppDimens.size3M.hSpace,
                                TextFieldDatePicker(
                                  controller: tanggal,
                                  title: 'Tanggal Kunjungan',
                                  hint: 'Pilih Tanggal',
                                  required: true,
                                ),
                                AppDimens.size3M.hSpace,
                                BlocConsumer<
                                  UserGetLocalCubit,
                                  UserGetLocalState
                                >(
                                  listener: (context, state) {
                                    if (state.status.isLoaded) {
                                      setState(
                                        () => inventaris =
                                            state.data?.user?.inventaris,
                                      );
                                    }
                                  },
                                  builder: (_, usrState) {
                                    if (usrState.status.isLoaded &&
                                        inventaris?.id == null &&
                                        usrState.data?.user?.inventaris !=
                                            null) {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                            if (mounted &&
                                                inventaris?.id == null) {
                                              setState(() {
                                                inventaris = usrState
                                                    .data!
                                                    .user!
                                                    .inventaris;
                                              });
                                            }
                                          });
                                    }

                                    if (usrState.status.isLoaded &&
                                        (invState.status.isLoaded ||
                                            !allowMobileChangeVisitVehicle)) {
                                      return TextFieldDropdown<
                                        InventarisEntity
                                      >(
                                        title: 'Jenis Kendaraan',
                                        hint: 'Pilih Jenis Transportasi',
                                        required: true,
                                        colorTitle: AppColors.labelSecondary,
                                        selectedItem: inventaris,
                                        items: allowMobileChangeVisitVehicle
                                            ? (invState.lstInventaris ?? [])
                                            : (inventaris == null ||
                                                  inventaris?.id == null)
                                            ? <InventarisEntity>[]
                                            : <InventarisEntity>[inventaris!],
                                        disable: !allowMobileChangeVisitVehicle,
                                        compareFn: (i, s) => i.id == s?.id,
                                        itemAsString: (element) =>
                                            '${element.jenisKendaraan?.toJenisKendaraan?.toName ?? '-'} - ${element.merk} (${element.platNomer})',
                                        onChanged: allowMobileChangeVisitVehicle
                                            ? (value) => setState(
                                                () => inventaris = value,
                                              )
                                            : null,
                                      );
                                    } else if (invState.status.isNotLoaded) {
                                      return TextFieldDropdown<String>(
                                        title: 'Jenis Kendaraan',
                                        hint: 'Pilih Jenis Transportasi',
                                        required: true,
                                        colorTitle: AppColors.labelSecondary,
                                        items: const [],
                                        itemAsString: (element) => element,
                                        validator: (value) {
                                          if (value == null) {
                                            return kNotSelectedValidator.rich([
                                              'Jenis Kendaraan',
                                            ]);
                                          }
                                          return null;
                                        },
                                      );
                                    } else {
                                      return const TextFieldShimmer(
                                        title: 'Jenis Kendaraan',
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                            AppDimens.size3M.hSpace,
                            _buildCard(
                              context,
                              title: 'Tujuan Kunjungan',
                              children: [
                                CheckboxListTile(
                                  title: const Text('Pengantaran (DO)'),
                                  value: tujuanPengantaran,
                                  onChanged: (val) => setState(
                                    () => tujuanPengantaran = val ?? false,
                                  ),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  contentPadding: EdgeInsets.zero,
                                  visualDensity: VisualDensity.compact,
                                ),
                                CheckboxListTile(
                                  title: const Text('Penawaran (SO)'),
                                  value: tujuanPenawaran,
                                  onChanged: (val) => setState(
                                    () => tujuanPenawaran = val ?? false,
                                  ),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  contentPadding: EdgeInsets.zero,
                                  visualDensity: VisualDensity.compact,
                                ),
                                CheckboxListTile(
                                  title: const Text('Penagihan'),
                                  value: tujuanPenagihan,
                                  onChanged: (val) => setState(
                                    () => tujuanPenagihan = val ?? false,
                                  ),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  contentPadding: EdgeInsets.zero,
                                  visualDensity: VisualDensity.compact,
                                ),
                                if (isHybridMode) ...[
                                  AppDimens.size2M.hSpace,
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withValues(
                                        alpha: 0.08,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.blue.withValues(
                                          alpha: 0.2,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.info_outline,
                                          color: Colors.blue,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Mode Hybrid: Nominal transaksi & no referensi akan diinput manual saat pemeriksaan kunjungan.',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.blue.shade700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                // Full Mode: Show Pickers when outlet is selected
                                if (!isHybridMode && apotek?.id != null) ...[
                                  if (tujuanPengantaran) ...[
                                    AppDimens.size2M.hSpace,
                                    _buildPickerTile(
                                      context,
                                      icon: Icons.local_shipping_outlined,
                                      title: 'Surat Jalan (DO)',
                                      count: selectedDOs.length,
                                      onTap: () => _openDoPicker(context),
                                    ),
                                    if (selectedDOs.isNotEmpty) ...[
                                      const SizedBox(height: 8),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 4,
                                        children: selectedDOs
                                            .map(
                                              (d) => Chip(
                                                label: Text(
                                                  d.noDo ?? '-',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                deleteIcon: const Icon(
                                                  Icons.close,
                                                  size: 16,
                                                ),
                                                onDeleted: () => setState(
                                                  () => selectedDOs.remove(d),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ],
                                  ],
                                  if (tujuanPenagihan) ...[
                                    AppDimens.size2M.hSpace,
                                    _buildPickerTile(
                                      context,
                                      icon: Icons.receipt_long_outlined,
                                      title: 'Tagihan / Invoice',
                                      count: selectedInvoices.length,
                                      onTap: () => _openInvoicePicker(context),
                                    ),
                                    if (selectedInvoices.isNotEmpty) ...[
                                      const SizedBox(height: 8),
                                      ...selectedInvoices.map(
                                        (inv) => Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 4,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                inv.noOrder ?? '-',
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                ),
                                              ),
                                              Text(
                                                'Rp ${inv.sisaTagihan?.toInt().textDecimalDigit ?? '0'}',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.red.shade600,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ],
                              ],
                            ),
                            AppDimens.size3M.hSpace,
                            _buildCard(
                              context,
                              title: 'Tambahan',
                              children: [
                                TextFieldBasic(
                                  title: 'Catatan',
                                  colorTitle: AppColors.labelSecondary,
                                  hint: 'Tulis Catatan (Optional)',
                                  controller: catatan,
                                  multiline: true,
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                bottomNavigationBar: SafeArea(
                  top: false,
                  minimum: const EdgeInsets.only(
                    bottom: AppDimens.paddingSmallX,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimens.paddingMediumX,
                      AppDimens.paddingSmallX,
                      AppDimens.paddingMediumX,
                      AppDimens.paddingMediumX,
                    ),
                    child: _buildSaveVisitButton(),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSaveVisitButton() {
    return BlocConsumer<TasksPostDataCubit, TasksPostDataState>(
      listener: (_, state) async {
        if (state.status.isLoaded) {
          await AppModalBottom.showDefault(
            context,
            contentTitle: 'Kunjungan berhasil ditambahkan',
            contentSubtitle:
                'Anda berhasil menambahkan kunjungan ke ${apotek?.namaApotik}.',
            hasActionPop: true,
          );
          if (!mounted) return;
          context.router.pop<bool>(true);
        } else if (state.status.isNotLoaded) {
          await AppModalBottom.handleError(context, state.failure);
        }
      },
      builder: (context, state) => AppButton(
        onPressed: () {
          if (state.status.isLoading) return;
          if (!tujuanPengantaran && !tujuanPenawaran && !tujuanPenagihan) {
            Fluttertoast.showToast(msg: 'Pilih minimal satu tujuan kunjungan.');
            return;
          }
          if (inventaris?.id == null) {
            Fluttertoast.showToast(
              msg: allowMobileChangeVisitVehicle
                  ? 'Pilih kendaraan untuk kunjungan.'
                  : 'Kendaraan utama belum ditetapkan. Hubungi admin.',
            );
            return;
          }
          if (!formKey.currentState!.validate()) return;
          formKey.currentState!.save();
          context.read<TasksPostDataCubit>().postData(
            TasksParamsEntity(
              inventarisId: inventaris?.id,
              taskDateAssigned: tanggal.text,
              aktivitas: AktivitasEntity(
                apotikId: apotek,
                noFaktur: [
                  ...selectedDOs.map((d) => d.noDo ?? ''),
                  ...selectedInvoices.map((inv) => inv.noOrder ?? ''),
                ].where((number) => number.isNotEmpty).toList(),
                note: catatan.text,
                tujuanPengantaran: tujuanPengantaran,
                tujuanPenawaran: tujuanPenawaran,
                tujuanPenagihan: tujuanPenagihan,
              ),
            ),
          );
        },
        isLoading: state.status.isLoading,
        text: 'Simpan Kunjungan',
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        border: Border.all(color: AppColors.dividerLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppDimens.paddingMediumX),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          AppDimens.size2M.hSpace,
          const Divider(color: AppColors.dividerLight),
          AppDimens.size2M.hSpace,
          ...children,
        ],
      ),
    );
  }

  Widget _buildPickerTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required int count,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                count > 0 ? '$title ($count dipilih)' : 'Pilih $title',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.primary.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }

  void _openDoPicker(BuildContext context) async {
    final outletId = apotek?.id;
    if (outletId == null) return;

    context.read<DeliveryOrderGetAllCubit>().loadDeliveryOrders(
      outletId: outletId,
      status: 'menunggu',
    );

    final cubitState = await context
        .read<DeliveryOrderGetAllCubit>()
        .stream
        .firstWhere(
          (s) =>
              s is DeliveryOrderGetAllLoaded || s is DeliveryOrderGetAllError,
        );

    if (!context.mounted) return;

    if (cubitState is DeliveryOrderGetAllLoaded) {
      final result = await showModalBottomSheet<List<DeliveryOrderEntity>?>(
        context: context,
        isScrollControlled: true,
        builder: (_) =>
            DoPickerSheet(deliveryOrders: cubitState.deliveryOrders),
      );
      if (result != null) {
        setState(() => selectedDOs = result);
      }
    } else if (cubitState is DeliveryOrderGetAllError) {
      Fluttertoast.showToast(msg: cubitState.message);
    }
  }

  void _openInvoicePicker(BuildContext context) async {
    final outletId = apotek?.id;
    if (outletId == null) return;

    context.read<OrderGetAllSalesOrdersCubit>().getAllSalesOrders(
      statusPembayaran: 'unpaid',
      outletId: outletId,
    );

    final cubitState = await context
        .read<OrderGetAllSalesOrdersCubit>()
        .stream
        .firstWhere((s) => s.status.isLoaded || s.status.isNotLoaded);

    if (!context.mounted) return;

    if (cubitState.status.isLoaded && cubitState.salesOrders != null) {
      final result = await showModalBottomSheet<List<SalesOrderEntity>?>(
        context: context,
        isScrollControlled: true,
        builder: (_) => InvoicePickerSheet(invoices: cubitState.salesOrders!),
      );
      if (result != null) {
        setState(() => selectedInvoices = result);
      }
    } else if (cubitState.status.isNotLoaded) {
      Fluttertoast.showToast(
        msg: cubitState.failure?.message ?? 'Gagal memuat tagihan',
      );
    }
  }
}
