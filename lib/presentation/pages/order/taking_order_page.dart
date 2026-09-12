import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';
import 'package:presensi_mobile/presentation/widgets/apotek/apotek_item_card.dart';
import 'package:presensi_mobile/presentation/pages/delivery/widgets/product_selection_sheet.dart';
import 'package:flutter/services.dart';

@RoutePage()
class TakingOrderPage extends StatefulWidget {
  final ApotekEntity? initialApotek;

  const TakingOrderPage({super.key, this.initialApotek});

  @override
  State<TakingOrderPage> createState() => _TakingOrderPageState();
}

class _TakingOrderPageState extends State<TakingOrderPage> {
  late GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ApotekEntity? apotek;
  String? tipeOrder;
  String? metodePembayaran;
  int? jumlahTermin;

  TextEditingController diskonController = TextEditingController();
  TextEditingController catatanController = TextEditingController();

  List<SalesOrderItemParamsEntity> selectedProducts = [];
  List<JadwalPembayaranParamsEntity> jadwalPembayaran = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialApotek != null) {
      apotek = widget.initialApotek;
    }
  }

  @override
  void dispose() {
    diskonController.dispose();
    catatanController.dispose();
    super.dispose();
  }

  void generateJadwalPembayaran() {
    jadwalPembayaran.clear();

    if (metodePembayaran == 'kredit_7') {
      jadwalPembayaran.add(
        JadwalPembayaranParamsEntity(
          noTermin: 1,
          dueDate: DateTime.now()
              .add(const Duration(days: 7))
              .toIso8601String(),
          amount: _calculateTotalAmount(),
        ),
      );
    } else if (metodePembayaran == 'kredit_14') {
      jadwalPembayaran.add(
        JadwalPembayaranParamsEntity(
          noTermin: 1,
          dueDate: DateTime.now()
              .add(const Duration(days: 14))
              .toIso8601String(),
          amount: _calculateTotalAmount(),
        ),
      );
    } else if (metodePembayaran == 'kredit_30') {
      jadwalPembayaran.add(
        JadwalPembayaranParamsEntity(
          noTermin: 1,
          dueDate: DateTime.now()
              .add(const Duration(days: 30))
              .toIso8601String(),
          amount: _calculateTotalAmount(),
        ),
      );
    } else if (metodePembayaran == 'termin' && (jumlahTermin ?? 0) > 0) {
      final netSales = _calculateTotalAmount();
      final cicilan = netSales / jumlahTermin!;

      for (int i = 0; i < jumlahTermin!; i++) {
        final isLast = i == (jumlahTermin! - 1);
        final amount = isLast
            ? (netSales - (cicilan.floor() * (jumlahTermin! - 1)))
            : cicilan.floor().toDouble();

        jadwalPembayaran.add(
          JadwalPembayaranParamsEntity(
            noTermin: i + 1,
            dueDate: DateTime.now()
                .add(Duration(days: 30 * (i + 1)))
                .toIso8601String(),
            amount: amount,
          ),
        );
      }
    }
  }

  double _calculateGrossAmount() {
    return selectedProducts.fold(0, (sum, item) => sum + (item.subtotal ?? 0));
  }

  double _calculateTotalAmount() {
    final gross = _calculateGrossAmount();
    final diskon =
        double.tryParse(diskonController.text.replaceAll('.', '')) ?? 0;
    return (gross - diskon) < 0 ? 0 : (gross - diskon);
  }

  Future<void> _openProductSelection(BuildContext context) async {
    final result = await showModalBottomSheet<List<SalesOrderItemParamsEntity>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimens.radiusMediumX),
        ),
      ),
      builder: (context) => ProductSelectionSheet(
        initialItems: selectedProducts,
        priceLevel: apotek?.tipeOutlet,
        allowManualPrice: false,
      ),
    );

    if (result != null) {
      setState(() {
        selectedProducts = result;
        if (metodePembayaran != null) generateJadwalPembayaran();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<TasksGetAllApotikCubit>()..getAllDataSearch(),
        ),
        BlocProvider(create: (context) => sl<UserGetLocalCubit>()..getData()),
        BlocProvider(create: (context) => sl<OrderCreateCubit>()),
      ],
      child: UnfocuserForm(
        child: Scaffold(
          backgroundColor: AppColors.bgPrimary,
          body: Stack(
            children: [
              Container(
                height: 180,
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                  child: Image.asset(AppImages.geometricBg, fit: BoxFit.cover),
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    const AppTopBar(
                      title: 'Taking Order',
                      useGradient: false,
                      backgroundColor: Colors.transparent,
                      titleColor: AppColors.white,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(
                          AppDimens.paddingMediumX,
                          0,
                          AppDimens.paddingMediumX,
                          AppDimens.paddingMediumX,
                        ),
                        child: Form(
                          key: formKey,
                          child: BlocBuilder<UserGetLocalCubit, UserGetLocalState>(
                            builder: (_, usrState) {
                              return Container(
                                padding: const EdgeInsets.all(
                                  AppDimens.paddingMediumX,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(
                                    AppDimens.radiusLarge,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.05,
                                      ),
                                      blurRadius: 16,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // OUTLET SELECTION
                                    BlocConsumer<
                                      TasksGetAllApotikCubit,
                                      TasksGetAllApotikState
                                    >(
                                      listener: (_, state) async {
                                        if (state.status.isNotLoaded) {
                                          await Fluttertoast.showToast(
                                            msg: state.failure!.message,
                                          );
                                        }
                                      },
                                      builder: (context, state) {
                                        if (state.status.isLoaded) {
                                          return TextFieldDropdownSearch<
                                            ApotekEntity
                                          >(
                                            title: 'Outlet / Customer',
                                            hint: 'Pilih Outlet',
                                            items: state.lstApotik!,
                                            selectedItem: apotek,
                                            required: true,
                                            colorTitle:
                                                AppColors.labelSecondary,
                                            itemAsString: (element) =>
                                                '${element.namaApotik} ${element.kodeApotik == null ? '' : ' - ${element.kodeApotik}'}',
                                            compareFn: (selected, val) =>
                                                val == null
                                                ? false
                                                : selected == val,
                                            validator: (value) {
                                              if (value == null) {
                                                return kNotSelectedValidator
                                                    .rich(['Outlet']);
                                              }
                                              return null;
                                            },
                                            onChanged: (value) => setState(() {
                                              apotek = value;
                                              // Reset products if segment changed
                                              selectedProducts.clear();
                                            }),
                                          );
                                        } else {
                                          return const TextFieldShimmer(
                                            title: 'Outlet / Customer',
                                          );
                                        }
                                      },
                                    ),

                                    if (apotek?.namaApotik != null) ...[
                                      AppDimens.size2M.hSpace,
                                      ApotekItemCard(apotek: apotek!),
                                    ],
                                    AppDimens.size3M.hSpace,

                                    // ORDER DETAILS
                                    TextFieldDropdown<String>(
                                      title: 'Tipe Order',
                                      hint: 'Pilih Tipe Order',
                                      required: true,
                                      items: const ['indent', 'canvas'],
                                      itemAsString: (item) {
                                        if (item == 'indent') {
                                          return 'INDENT / PRE ORDER (PO)';
                                        }
                                        if (item == 'canvas') {
                                          return 'CANVAS (JUAL LANGSUNG)';
                                        }
                                        return item
                                            .replaceAll('_', ' ')
                                            .toUpperCase();
                                      },
                                      onChanged: (val) =>
                                          setState(() => tipeOrder = val),
                                      validator: (value) => value == null
                                          ? kNotSelectedValidator.rich([
                                              'Tipe Order',
                                            ])
                                          : null,
                                    ),
                                    AppDimens.size3M.hSpace,

                                    TextFieldDropdown<String>(
                                      title: 'Metode Pembayaran',
                                      hint: 'Pilih Metode',
                                      required: true,
                                      items: const [
                                        'cash',
                                        'cod',
                                        'kredit_7',
                                        'kredit_14',
                                        'kredit_30',
                                        'termin',
                                      ],
                                      itemAsString: (item) {
                                        final map = {
                                          'cash': 'Cash / Lunas',
                                          'cod': 'Cash On Delivery (COD)',
                                          'kredit_7': 'Tempo / Kredit 7 Hari',
                                          'kredit_14': 'Tempo / Kredit 14 Hari',
                                          'kredit_30': 'Tempo / Kredit 30 Hari',
                                          'termin':
                                              'Termin (Cicilan Berjangka)',
                                        };
                                        return map[item] ??
                                            item
                                                .replaceAll('_', ' ')
                                                .toUpperCase();
                                      },
                                      onChanged: (val) {
                                        setState(() {
                                          metodePembayaran = val;
                                          generateJadwalPembayaran();
                                        });
                                      },
                                      validator: (value) => value == null
                                          ? kNotSelectedValidator.rich([
                                              'Metode Pembayaran',
                                            ])
                                          : null,
                                    ),

                                    if (metodePembayaran == 'termin') ...[
                                      AppDimens.size3M.hSpace,
                                      TextFieldDropdown<int>(
                                        title: 'Jumlah Termin (Bulan)',
                                        hint: 'Pilih Jumlah Cicilan',
                                        items: const [2, 3, 4, 5, 6],
                                        itemAsString: (item) =>
                                            '$item Bulan / Termin',
                                        onChanged: (val) {
                                          setState(() {
                                            jumlahTermin = val;
                                            generateJadwalPembayaran();
                                          });
                                        },
                                        validator: (value) => value == null
                                            ? kNotSelectedValidator.rich([
                                                'Jumlah Termin',
                                              ])
                                            : null,
                                      ),
                                    ],
                                    AppDimens.size3M.hSpace,

                                    // PRODUCT SELECTION
                                    Container(
                                      padding: const EdgeInsets.all(
                                        AppDimens.paddingMediumX,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withValues(
                                          alpha: 0.05,
                                        ),
                                        border: Border.all(
                                          color: AppColors.primary.withValues(
                                            alpha: 0.2,
                                          ),
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          AppDimens.radiusMedium,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Daftar Produk',
                                                style: context
                                                    .textStyle
                                                    .titleMedium!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                              OutlinedButton.icon(
                                                onPressed: () =>
                                                    _openProductSelection(
                                                      context,
                                                    ),
                                                icon: const Icon(
                                                  Icons.add_shopping_cart,
                                                  size: 16,
                                                ),
                                                label: const Text(
                                                  'Pilih Produk',
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (selectedProducts.isNotEmpty) ...[
                                            AppDimens.size2X.hSpace,
                                            ListView.separated(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount:
                                                  selectedProducts.length,
                                              separatorBuilder: (_, _) =>
                                                  const Divider(),
                                              itemBuilder: (context, index) {
                                                final item =
                                                    selectedProducts[index];
                                                return Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            item.namaProduk ??
                                                                '-',
                                                            style:
                                                                const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                          ),
                                                          Text(
                                                            '${item.qty?.toInt()} ${item.satuan} x Rp ${(item.harga ?? 0).toInt().textDecimalDigit}',
                                                            style:
                                                                const TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Text(
                                                      'Rp ${(item.subtotal ?? 0).toInt().textDecimalDigit}',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ] else ...[
                                            AppDimens.size2X.hSpace,
                                            const Center(
                                              child: Text(
                                                'Belum ada produk yang dipilih',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    AppDimens.size3M.hSpace,

                                    TextFieldBasic(
                                      title: 'Diskon (Rp)',
                                      colorTitle: AppColors.labelSecondary,
                                      hint: '0',
                                      controller: diskonController,
                                      inputType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      onChanged: (val) {
                                        setState(() {
                                          if (metodePembayaran != null) {
                                            generateJadwalPembayaran();
                                          }
                                        });
                                      },
                                    ),
                                    AppDimens.size3M.hSpace,

                                    TextFieldBasic(
                                      title: 'Catatan Order',
                                      colorTitle: AppColors.labelSecondary,
                                      hint: 'Tulis Catatan (Optional)',
                                      controller: catatanController,
                                      multiline: true,
                                    ),
                                    AppDimens.size3M.hSpace,

                                    // SUMMARY
                                    Container(
                                      padding: const EdgeInsets.all(
                                        AppDimens.paddingMediumX,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          AppDimens.radiusMedium,
                                        ),
                                        border: Border.all(
                                          color: AppColors.divider,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('Total Produk'),
                                              Text(
                                                'Rp ${_calculateGrossAmount().toInt().textDecimalDigit}',
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Diskon',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                              Text(
                                                '- Rp ${((double.tryParse(diskonController.text.replaceAll('.', '')) ?? 0)).toInt().textDecimalDigit}',
                                                style: const TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Divider(height: 24),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Grand Total',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Text(
                                                'Rp ${_calculateTotalAmount().toInt().textDecimalDigit}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: Theme.of(
                                                    context,
                                                  ).primaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    AppDimens.size4M.hSpace,
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(AppDimens.paddingMediumX),
            child: BlocConsumer<OrderCreateCubit, OrderCreateState>(
              listener: (_, state) async {
                if (state.status.isLoaded) {
                  await AppModalBottom.showDefault(
                    context,
                    contentTitle: 'Order Berhasil Dibuat',
                    contentSubtitle:
                        'Sales Order untuk ${apotek?.namaApotik ?? ''} berhasil disimpan.',
                    hasActionPop: true,
                  );
                  if (!context.mounted) return;
                  context.router.pop();
                } else if (state.status.isNotLoaded) {
                  await AppModalBottom.handleError(context, state.failure);
                }
              },
              builder: (context, state) {
                return AppButton(
                  onPressed: () {
                    if (state.status.isLoading) return;

                    if (formKey.currentState!.validate()) {
                      if (selectedProducts.isEmpty) {
                        Fluttertoast.showToast(
                          msg: 'Pilih minimal satu produk',
                        );
                        return;
                      }

                      final user = context
                          .read<UserGetLocalCubit>()
                          .state
                          .data
                          ?.user;
                      final salesmanId = user?.id;
                      final salesmanNama = user?.name;

                      final params = SalesOrderParamsEntity(
                        outletId: apotek?.id,
                        outletNama: apotek?.namaApotik,
                        salesmanId: salesmanId,
                        salesmanNama: salesmanNama,
                        tipeOrder: tipeOrder,
                        tanggal: DateTime.now().toIso8601String(),
                        metodePembayaran: metodePembayaran,
                        diskon:
                            double.tryParse(
                              diskonController.text.replaceAll('.', ''),
                            ) ??
                            0,
                        catatan: catatanController.text,
                        items: selectedProducts,
                      );

                      context.read<OrderCreateCubit>().submit(params);
                    }
                  },
                  isLoading: state.status.isLoading,
                  text: 'Buat Order Sekarang',
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
