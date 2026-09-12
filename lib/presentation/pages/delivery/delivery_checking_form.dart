import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_cubit.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_state.dart';
import 'package:presensi_mobile/presentation/pages/delivery/widgets/invoice_picker_sheet.dart';
import 'package:presensi_mobile/presentation/pages/delivery/widgets/product_selection_sheet.dart';
import 'package:presensi_mobile/presentation/pages/delivery/widgets/sales_order_detail_sheet.dart';
import 'package:presensi_mobile/presentation/pages/delivery/widgets/delivery_order_detail_sheet.dart';
import 'package:presensi_mobile/presentation/widgets/global/text_field_custom/text_formatter.dart';
import 'package:presensi_mobile/service/location_disclosure_service.dart';

@RoutePage()
class DeliveryCheckingForm extends StatefulWidget {
  final TasksEntity? tasks;
  const DeliveryCheckingForm({super.key, required this.tasks});

  @override
  State<DeliveryCheckingForm> createState() => _DeliveryCheckingFormState();
}

class _DeliveryCheckingFormState extends State<DeliveryCheckingForm> {
  late Completer<GoogleMapController> _controller = Completer();
  late Location location = Location();
  StreamSubscription<LocationData> streamLocation =
      const Stream<LocationData>.empty().listen((_) {});

  late TextEditingController catatan = TextEditingController();
  late TextEditingController diskonController = TextEditingController();

  String? tipeCall;
  String? tipeOrder;
  String? kategoriOrder;
  String? metodePembayaran;

  int jumlahTermin = 2;
  double diskon = 0;
  List<JadwalPembayaranParamsEntity> jadwalPembayaran = [];

  List<SalesOrderItemParamsEntity> selectedProducts = [];

  double get grossSales => selectedProducts.fold(
    0,
    (sum, item) =>
        sum + (item.subtotal ?? ((item.harga ?? 0) * (item.qty ?? 0))),
  );
  double get netSales => (grossSales - diskon) < 0 ? 0 : (grossSales - diskon);

  // Hybrid mode fields
  TextEditingController nominalManualController = TextEditingController();
  TextEditingController nominalPenagihanController = TextEditingController();
  TextEditingController noReferensiPenagihanController =
      TextEditingController();
  List<String> noReferensiPenagihanPills = [];
  TextEditingController noReferensiPengantaranController =
      TextEditingController();
  List<String> noReferensiPengantaranPills = [];
  double nominalManual = 0;
  double nominalPenagihan = 0;
  bool isHybridMode = false;

  late List<XFile>? fotoPrimary = [];
  late List<XFile>? fotoSecondary = [];

  void _takeFotoPrimary(bool isMarketing) async {
    final result = await context.router.push<XFile?>(
      AppCameraPageRoute(type: AppCameraType.selfie),
    );
    if (result != null) {
      setState(() {
        fotoPrimary = [result];
      });
    }
  }

  void _takeFotoSecondary() async {
    final result = await context.router.push<XFile?>(
      AppCameraPageRoute(type: AppCameraType.general),
    );
    if (result != null) {
      setState(() {
        fotoSecondary = [result];
      });
    }
  }

  void onMapCreate(BuildContext ctxMap, GoogleMapController ctrl) async {
    _controller.complete(ctrl);

    if (!await LocationDisclosureService.ensureAccepted()) return;

    final apotek = widget.tasks?.aktivitas?.apotikId;
    LatLng? outletPos;
    if (apotek?.latitude != null && apotek?.longitude != null) {
      final lat = double.tryParse(apotek!.latitude!);
      final lng = double.tryParse(apotek.longitude!);
      if (lat != null && lng != null) {
        outletPos = LatLng(lat, lng);
      }
    }

    bool isFirst = true;
    streamLocation = location.onLocationChanged.listen((l) {
      _controller.future.then((value) {
        if (isFirst) {
          isFirst = false;
          if (outletPos != null) {
            final bounds = LatLngBounds(
              southwest: LatLng(
                l.latitude! < outletPos.latitude
                    ? l.latitude!
                    : outletPos.latitude,
                l.longitude! < outletPos.longitude
                    ? l.longitude!
                    : outletPos.longitude,
              ),
              northeast: LatLng(
                l.latitude! > outletPos.latitude
                    ? l.latitude!
                    : outletPos.latitude,
                l.longitude! > outletPos.longitude
                    ? l.longitude!
                    : outletPos.longitude,
              ),
            );
            value.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
          } else {
            value.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: LatLng(l.latitude!, l.longitude!),
                  zoom: 15,
                ),
              ),
            );
          }
        }

        Throttle.throttle(kThrMap, kDurationMapLoad, () {
          if (!ctxMap.mounted) return;
          ctxMap.read<GlobalMapCubit>().updateTarget(
            LatLng(l.latitude!, l.longitude!),
          );
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = context.read<AppCubit>().state;
      setState(() {
        isHybridMode = appState.setting.data?.isHybridMode ?? false;
      });
    });
  }

  void _handleOutletCoordinateMismatch(LatLng? outletPos) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimens.radiusLarge),
        ),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppDimens.paddingLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Koordinat Outlet',
              style: context.textStyle.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppDimens.size1X.hSpace,
            const Text(
              'Apakah kamu sudah di lokasi outlet yang benar saat ini?',
            ),
            AppDimens.size3X.hSpace,
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(ctx);
                if (!await LocationDisclosureService.ensureAccepted()) return;
                final loc = await location.getLocation();
                if (loc.latitude != null && loc.longitude != null) {
                  _submitCoordinateRequest(loc.latitude!, loc.longitude!);
                }
              },
              child: const Text('Ya, saya sudah di lokasi'),
            ),
            AppDimens.size1X.hSpace,
            OutlinedButton(
              onPressed: () async {
                Navigator.pop(ctx);
                final result = await context.router.push<LocationPickerResult?>(
                  LocationPickerPageRoute(
                    initialLat: outletPos?.latitude ?? kDDefaultLat,
                    initialLong: outletPos?.longitude ?? kDDefaultLong,
                  ),
                );
                if (result != null) {
                  _submitCoordinateRequest(
                    result.position.latitude,
                    result.position.longitude,
                  );
                }
              },
              child: const Text('Tidak, pilih lewat peta'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitCoordinateRequest(double lat, double lng) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );
      final outletId =
          widget.tasks?.aktivitas?.apotikId?.id ??
          widget.tasks?.aktivitas?.outlet?.id;

      final String mutation = '''
        mutation requestUpdateOutletCoordinate(\$input: OutletCoordinateRequestInput!) {
          requestUpdateOutletCoordinate(input: \$input) {
            _id
            status
          }
        }
      ''';

      final variables = {
        'input': {
          'outlet_id': outletId,
          'proposed_latitude': lat.toString(),
          'proposed_longitude': lng.toString(),
        },
      };

      await sl<GraphQlService>().mutation(
        mutation: mutation,
        variables: variables,
      );
      Navigator.pop(context); // close loading
      Fluttertoast.showToast(
        msg: 'Pengajuan update koordinat berhasil dikirim.',
      );
    } catch (e) {
      Navigator.pop(context); // close loading
      Fluttertoast.showToast(msg: 'Gagal mengirim pengajuan');
    }
  }

  void generateJadwalPembayaran() {
    jadwalPembayaran.clear();
    if (metodePembayaran == null || grossSales == 0) return;

    final baseDate = DateTime.now();

    if (metodePembayaran == 'kredit_7') {
      jadwalPembayaran.add(
        JadwalPembayaranParamsEntity(
          noTermin: 1,
          dueDate: baseDate.add(const Duration(days: 7)).toIso8601String(),
          amount: netSales,
        ),
      );
    } else if (metodePembayaran == 'kredit_14') {
      jadwalPembayaran.add(
        JadwalPembayaranParamsEntity(
          noTermin: 1,
          dueDate: baseDate.add(const Duration(days: 14)).toIso8601String(),
          amount: netSales,
        ),
      );
    } else if (metodePembayaran == 'kredit_30') {
      jadwalPembayaran.add(
        JadwalPembayaranParamsEntity(
          noTermin: 1,
          dueDate: baseDate.add(const Duration(days: 30)).toIso8601String(),
          amount: netSales,
        ),
      );
    } else if (metodePembayaran == 'termin') {
      final cicilan = netSales / jumlahTermin;
      for (int i = 0; i < jumlahTermin; i++) {
        final isLast = i == jumlahTermin - 1;
        final amount = isLast
            ? (netSales - (cicilan.floor() * (jumlahTermin - 1)))
            : cicilan.floor().toDouble();
        jadwalPembayaran.add(
          JadwalPembayaranParamsEntity(
            noTermin: i + 1,
            dueDate: baseDate
                .add(Duration(days: 30 * (i + 1)))
                .toIso8601String(),
            amount: amount,
          ),
        );
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    catatan.dispose();
    diskonController.dispose();
    nominalManualController.dispose();
    nominalPenagihanController.dispose();
    noReferensiPenagihanController.dispose();
    noReferensiPengantaranController.dispose();
    _controller = Completer();
    streamLocation.cancel();
    Throttle.cancelAll();
    Debounce.cancelAll();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<GlobalMapCubit>()..getPermissionStatus(),
        ),
        BlocProvider(create: (context) => sl<UserGetLocalCubit>()..getData()),
        BlocProvider(create: (context) => sl<TasksPostCompletedCubit>()),
        BlocProvider(create: (context) => sl<OrderCreateCubit>()),
      ],
      child: BlocListener<AppCubit, AppState>(
        listener: (context, state) {
          if (state.setting.isSuccess) {
            final newHybrid = state.setting.data?.isHybridMode ?? false;
            if (newHybrid != isHybridMode) {
              setState(() {
                isHybridMode = newHybrid;
              });
            }
          }
        },
        child: BlocConsumer<GlobalMapCubit, GlobalMapState>(
          listener: (context, mapState) {
            if (mapState.typeState.isNotLoaded) {
              Fluttertoast.showToast(msg: mapState.message!);
            }
          },
          builder: (ctxMap, mapState) {
            final apotek = widget.tasks?.aktivitas?.apotikId;
            final destination = widget.tasks?.aktivitas?.destination;
            final outlet = widget.tasks?.aktivitas?.outlet;
            LatLng? outletPos;

            // Coba dari apotek
            if (apotek?.latitude != null &&
                apotek?.longitude != null &&
                apotek!.latitude!.isNotEmpty &&
                apotek.longitude!.isNotEmpty) {
              final lat = double.tryParse(apotek.latitude!);
              final lng = double.tryParse(apotek.longitude!);
              if (lat != null && lng != null) {
                outletPos = LatLng(lat, lng);
              }
            }

            // Jika apotek kosong, coba dari outlet
            if (outletPos == null &&
                outlet?.latitude != null &&
                outlet?.longitude != null &&
                outlet!.latitude!.isNotEmpty &&
                outlet.longitude!.isNotEmpty) {
              final lat = double.tryParse(outlet.latitude!);
              final lng = double.tryParse(outlet.longitude!);
              if (lat != null && lng != null) {
                outletPos = LatLng(lat, lng);
              }
            }

            // Jika outlet kosong, coba dari destination
            if (outletPos == null &&
                destination?.latitude != null &&
                destination?.longitude != null &&
                destination!.latitude!.isNotEmpty &&
                destination.longitude!.isNotEmpty) {
              final lat = double.tryParse(destination.latitude!);
              final lng = double.tryParse(destination.longitude!);
              if (lat != null && lng != null) {
                outletPos = LatLng(lat, lng);
              }
            }

            return UnfocuserForm(
              child: Scaffold(
                appBar: const AppTopBar(title: 'Pemeriksaan Kunjungan'),
                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppDimens.paddingMediumX),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                              AppDimens.radiusMedium,
                            ),
                            child: MapViewWidget(
                              initialCameraPosition: CameraPosition(
                                target: mapState.targetPosition!,
                              ),
                              onMapCreated: (controller) =>
                                  onMapCreate(ctxMap, controller),
                              position: mapState.targetPosition!,
                              outletPosition: outletPos,
                              onMyLocation: () {
                                ctxMap.read<GlobalMapCubit>().updateTarget(
                                  mapState.targetPosition!,
                                );
                                _controller.future.then((ctrl) {
                                  ctrl.animateCamera(
                                    CameraUpdate.newCameraPosition(
                                      CameraPosition(
                                        target: mapState.targetPosition!,
                                        zoom: 15,
                                      ),
                                    ),
                                  );
                                });
                              },
                            ),
                          ),
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Material(
                              color: Colors.white.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(20),
                              elevation: 2,
                              child: InkWell(
                                onTap: () =>
                                    _handleOutletCoordinateMismatch(outletPos),
                                borderRadius: BorderRadius.circular(20),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.report_problem_outlined,
                                        size: 14,
                                        color: Colors.blue.shade700,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Koordinat tidak sesuai?',
                                        style: TextStyle(
                                          color: Colors.blue.shade700,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      AppDimens.size3M.hSpace,
                      BlocBuilder<UserGetLocalCubit, UserGetLocalState>(
                        builder: (_, usrState) {
                          final task = widget.tasks;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              StreamBuilder(
                                stream: Stream.periodic(
                                  const Duration(seconds: 1),
                                  (i) => i,
                                ),
                                builder: (context, snapshot) {
                                  return DeliveryCardWidget(
                                    title: 'Tiba ditempat',
                                    titleTime: 'Waktu tiba',
                                    dateNow: DateTime.now().toEEEdMMMy,
                                    timeNow: DateTime.now().toHHmmss,
                                    isLoading: mapState.typeState.isLoading,
                                    addreass: mapState.address?.toString(),
                                  );
                                },
                              ),
                              if (task != null) ...[
                                AppDimens.size3M.hSpace,
                                DeliveryTaskItemCard(task: task),
                              ],

                              if (widget.tasks?.aktivitas?.tujuanPenawaran ==
                                  true) ...[
                                AppDimens.size3M.hSpace,
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      AppDimens.radiusMedium,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(
                                    AppDimens.paddingMedium,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        'Data Order',
                                        style: context.textStyle.titleMedium!
                                            .copyWith(
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      TextFieldDropdown<String>(
                                        title: 'Tipe Call',
                                        required:
                                            widget
                                                .tasks
                                                ?.aktivitas
                                                ?.tujuanPenawaran ==
                                            true,
                                        hint: 'Pilih Tipe Call',
                                        items: const [
                                          'effective_call',
                                          'noc',
                                          'productive_call',
                                        ],
                                        itemAsString: (item) => item
                                            .replaceAll('_', ' ')
                                            .toUpperCase(),
                                        onChanged: (val) => setState(() {
                                          tipeCall = val;
                                          if (val != 'effective_call') {
                                            tipeOrder = null;
                                            kategoriOrder = null;
                                            metodePembayaran = null;
                                            selectedProducts.clear();
                                            jadwalPembayaran.clear();
                                          }
                                        }),
                                      ),
                                      if (tipeCall == 'effective_call') ...[
                                        AppDimens.size3M.hSpace,
                                        if (isHybridMode) ...[
                                          TextFieldBasic(
                                            controller: nominalManualController,
                                            title: 'Nominal Transaksi (Rp)',
                                            hint:
                                                'Masukkan Nominal (Misal: 150000)',
                                            colorTitle:
                                                AppColors.labelSecondary,
                                            inputType: TextInputType.number,
                                            onChanged: (val) {
                                              setState(() {
                                                nominalManual =
                                                    double.tryParse(
                                                      val.replaceAll('.', ''),
                                                    ) ??
                                                    0;
                                              });
                                            },
                                            inputFormatters: [
                                              IdrTextInputFormatter(),
                                            ],
                                          ),
                                        ] else ...[
                                          TextFieldDropdown<String>(
                                            title: 'Tipe Order',
                                            hint: 'Pilih Tipe Order',
                                            items: const ['indent', 'canvas'],
                                            itemAsString: (item) {
                                              if (item == 'indent')
                                                return 'INDENT / PRE ORDER (PO)';
                                              if (item == 'canvas')
                                                return 'CANVAS (JUAL LANGSUNG)';
                                              return item
                                                  .replaceAll('_', ' ')
                                                  .toUpperCase();
                                            },
                                            onChanged: (val) =>
                                                setState(() => tipeOrder = val),
                                          ),
                                          AppDimens.size3M.hSpace,
                                          TextFieldDropdown<String>(
                                            title: 'Kategori Order',
                                            hint: 'Pilih Kategori',
                                            items: () {
                                              final outlet = widget
                                                  .tasks
                                                  ?.aktivitas
                                                  ?.apotikId;
                                              final totalValue =
                                                  outlet?.totalValue ?? 0;
                                              final lastOrderDate =
                                                  outlet?.lastOrderDate;

                                              if (totalValue > 0 ||
                                                  (lastOrderDate != null &&
                                                      lastOrderDate
                                                          .isNotEmpty)) {
                                                return [
                                                  'repeat_order',
                                                  'top_up',
                                                ];
                                              }
                                              return ['noo'];
                                            }(),
                                            itemAsString: (item) {
                                              if (item == 'noo')
                                                return 'NOO (NEW OPEN OUTLET)';
                                              return item
                                                  .replaceAll('_', ' ')
                                                  .toUpperCase();
                                            },
                                            onChanged: (val) => setState(
                                              () => kategoriOrder = val,
                                            ),
                                          ),
                                          if (kategoriOrder != null) ...[
                                            AppDimens.size1X.hSpace,
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal:
                                                        AppDimens.paddingSmall,
                                                  ),
                                              child: Text(
                                                kategoriOrder == 'noo'
                                                    ? '* NOO: Pemesanan pertama kali dari outlet yang belum pernah order sebelumnya.'
                                                    : kategoriOrder ==
                                                          'repeat_order'
                                                    ? '* Repeat Order: Pemesanan ulang rutin sesuai siklus belanja normal outlet.'
                                                    : '* Top Up: Pemesanan tambahan sisipan di luar jadwal rutin outlet (stok cepat habis).',
                                                style: context
                                                    .textStyle
                                                    .bodySmall
                                                    ?.copyWith(
                                                      color: AppColors
                                                          .labelSecondary,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                              ),
                                            ),
                                          ],
                                          AppDimens.size3M.hSpace,
                                          TextFieldDropdown<String>(
                                            title: 'Metode Pembayaran',
                                            hint: 'Pilih Metode',
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
                                                'kredit_7':
                                                    'Tempo / Kredit 7 Hari',
                                                'kredit_14':
                                                    'Tempo / Kredit 14 Hari',
                                                'kredit_30':
                                                    'Tempo / Kredit 30 Hari',
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
                                          ),
                                          if (metodePembayaran == 'termin') ...[
                                            AppDimens.size3M.hSpace,
                                            TextFieldDropdown<int>(
                                              title: 'Jumlah Termin',
                                              hint: 'Pilih Jumlah',
                                              items: const [2, 3, 4, 6],
                                              itemAsString: (item) =>
                                                  '$item x Cicilan',
                                              onChanged: (val) {
                                                setState(() {
                                                  jumlahTermin = val ?? 2;
                                                  generateJadwalPembayaran();
                                                });
                                              },
                                            ),
                                          ],
                                          AppDimens.size3M.hSpace,
                                          ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            title: const Text('Produk Pesanan'),
                                            subtitle: Text(
                                              '${selectedProducts.length} produk',
                                            ),
                                            trailing: SizedBox(
                                              width: 100,
                                              child: AppButton(
                                                text: 'Pilih',
                                                onPressed: () async {
                                                  final result =
                                                      await showModalBottomSheet<
                                                        List<
                                                          SalesOrderItemParamsEntity
                                                        >?
                                                      >(
                                                        context: context,
                                                        isScrollControlled:
                                                            true,
                                                        builder: (_) =>
                                                            ProductSelectionSheet(
                                                              initialItems:
                                                                  selectedProducts,
                                                              priceLevel: widget
                                                                  .tasks
                                                                  ?.aktivitas
                                                                  ?.outlet
                                                                  ?.priceLevel,
                                                            ),
                                                      );
                                                  if (result != null) {
                                                    setState(() {
                                                      selectedProducts = result;
                                                      generateJadwalPembayaran();
                                                    });
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                          if (selectedProducts.isNotEmpty) ...[
                                            AppDimens.size2X.hSpace,
                                            TextFieldBasic(
                                              controller: diskonController,
                                              title: 'Diskon (Rp)',
                                              hint: 'Masukkan Diskon',
                                              colorTitle:
                                                  AppColors.labelSecondary,
                                              inputType: TextInputType.number,
                                              onChanged: (val) {
                                                setState(() {
                                                  diskon =
                                                      double.tryParse(
                                                        val.replaceAll('.', ''),
                                                      ) ??
                                                      0;
                                                  generateJadwalPembayaran();
                                                });
                                              },
                                              inputFormatters: [
                                                IdrTextInputFormatter(),
                                              ],
                                            ),
                                            AppDimens.size2X.hSpace,
                                            Container(
                                              padding: const EdgeInsets.all(
                                                AppDimens.paddingMedium,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.blue.withValues(
                                                  alpha: 0.1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      AppDimens.radiusMedium,
                                                    ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text('Gross Sales'),
                                                      Text(
                                                        'Rp ${grossSales.toInt().textDecimalDigit}',
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text('Diskon'),
                                                      Text(
                                                        '- Rp ${diskon.toInt().textDecimalDigit}',
                                                        style: const TextStyle(
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const Divider(),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text(
                                                        'Net Sales',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Rp ${netSales.toInt().textDecimalDigit}',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if (jadwalPembayaran
                                                .isNotEmpty) ...[
                                              AppDimens.size3M.hSpace,
                                              Text(
                                                'Jadwal Pembayaran',
                                                style: context
                                                    .textStyle
                                                    .titleSmall!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                              AppDimens.size1X.hSpace,
                                              ...jadwalPembayaran.map((j) {
                                                final date = DateTime.tryParse(
                                                  j.dueDate ?? '',
                                                );
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        bottom: 8.0,
                                                      ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Termin ${j.noTermin} (${date?.toEEEdMMMy})',
                                                      ),
                                                      Text(
                                                        'Rp ${(j.amount ?? 0).toInt().textDecimalDigit}',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }),
                                            ],
                                          ],
                                        ],
                                      ],
                                    ],
                                  ),
                                ),
                              ],

                              if (widget.tasks?.aktivitas?.tujuanPenagihan ==
                                  true) ...[
                                AppDimens.size3M.hSpace,
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      AppDimens.radiusMedium,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(
                                    AppDimens.paddingMedium,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        'Data Penagihan',
                                        style: context.textStyle.titleMedium!
                                            .copyWith(
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      if (isHybridMode) ...[
                                        TextFieldBasic(
                                          controller:
                                              noReferensiPenagihanController,
                                          title: 'No Referensi / Faktur',
                                          hint: 'Ketik lalu Enter/Koma',
                                          colorTitle: AppColors.labelSecondary,
                                          onSubmitted: (val) {
                                            if (val.trim().isNotEmpty) {
                                              setState(() {
                                                noReferensiPenagihanPills.add(
                                                  val.trim(),
                                                );
                                                noReferensiPenagihanController
                                                    .clear();
                                              });
                                            }
                                          },
                                        ),
                                        if (noReferensiPenagihanPills
                                            .isNotEmpty) ...[
                                          const SizedBox(height: 8),
                                          Wrap(
                                            spacing: 8,
                                            runSpacing: 4,
                                            children: noReferensiPenagihanPills
                                                .asMap()
                                                .entries
                                                .map((entry) {
                                                  return InputChip(
                                                    label: Text(
                                                      entry.value,
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    onPressed: () =>
                                                        SalesOrderDetailSheet.show(
                                                          context,
                                                          entry.value,
                                                        ),
                                                    onDeleted: () {
                                                      setState(() {
                                                        noReferensiPenagihanPills
                                                            .removeAt(
                                                              entry.key,
                                                            );
                                                      });
                                                    },
                                                  );
                                                })
                                                .toList(),
                                          ),
                                        ],
                                      ] else ...[
                                        Builder(
                                          builder: (context) {
                                            final refs =
                                                widget
                                                    .tasks
                                                    ?.aktivitas
                                                    ?.noReferensi
                                                    ?.where(
                                                      (ref) =>
                                                          !ref
                                                              .toUpperCase()
                                                              .startsWith(
                                                                'DO-',
                                                              ) &&
                                                          !ref
                                                              .toUpperCase()
                                                              .startsWith(
                                                                'SJ-',
                                                              ),
                                                    )
                                                    .toList() ??
                                                [];
                                            if (refs.isNotEmpty) {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          bottom: 8,
                                                        ),
                                                    child: Text(
                                                      'No Referensi dari Admin:',
                                                      style: context
                                                          .textStyle
                                                          .bodySmall
                                                          ?.copyWith(
                                                            color: AppColors
                                                                .labelSecondary,
                                                          ),
                                                    ),
                                                  ),
                                                  Wrap(
                                                    spacing: 8,
                                                    runSpacing: 4,
                                                    children: refs
                                                        .map(
                                                          (ref) => ActionChip(
                                                            label: Text(
                                                              ref,
                                                              style:
                                                                  const TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                            ),
                                                            backgroundColor:
                                                                AppColors
                                                                    .primary
                                                                    .withValues(
                                                                      alpha:
                                                                          0.08,
                                                                    ),
                                                            onPressed: () =>
                                                                SalesOrderDetailSheet.show(
                                                                  context,
                                                                  ref,
                                                                ),
                                                          ),
                                                        )
                                                        .toList(),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    'Klik nomor referensi untuk melihat detail tagihan',
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color:
                                                          Colors.grey.shade500,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }
                                            return Container(
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: Colors.orange.withValues(
                                                  alpha: 0.08,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.info_outline,
                                                    color:
                                                        Colors.orange.shade700,
                                                    size: 18,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      'Belum ada referensi tagihan yang ditetapkan admin.',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors
                                                            .orange
                                                            .shade700,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                      AppDimens.size3M.hSpace,
                                      TextFieldBasic(
                                        controller: nominalPenagihanController,
                                        title: 'Nominal Berhasil Ditagih (Rp)',
                                        hint:
                                            'Masukkan Nominal (Misal: 150000)',
                                        colorTitle: AppColors.labelSecondary,
                                        inputType: TextInputType.number,
                                        onChanged: (val) {
                                          setState(() {
                                            nominalPenagihan =
                                                double.tryParse(
                                                  val.replaceAll('.', ''),
                                                ) ??
                                                0;
                                          });
                                        },
                                        inputFormatters: [
                                          IdrTextInputFormatter(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],

                              if (widget.tasks?.aktivitas?.tujuanPengantaran ==
                                  true) ...[
                                AppDimens.size3M.hSpace,
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      AppDimens.radiusMedium,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(
                                    AppDimens.paddingMedium,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        'Data Pengantaran',
                                        style: context.textStyle.titleMedium!
                                            .copyWith(
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      TextFieldDropdown<String>(
                                        title: 'Status Pengantaran',
                                        hint: 'Pilih Status',
                                        items: const ['none', 'noc'],
                                        selectedItem:
                                            tipeCall == 'none' ||
                                                tipeCall == null
                                            ? 'none'
                                            : tipeCall,
                                        itemAsString: (item) {
                                          if (item == 'none')
                                            return 'BERHASIL TERKIRIM';
                                          if (item == 'noc')
                                            return 'GAGAL (TOKO TUTUP / DITOLAK)';
                                          return item.toUpperCase();
                                        },
                                        onChanged: (val) =>
                                            setState(() => tipeCall = val),
                                      ),
                                      AppDimens.size3M.hSpace,
                                      if (isHybridMode) ...[
                                        TextFieldBasic(
                                          controller:
                                              noReferensiPengantaranController,
                                          title: 'No Referensi DO',
                                          hint: 'Ketik lalu Enter/Koma',
                                          colorTitle: AppColors.labelSecondary,
                                          onSubmitted: (val) {
                                            if (val.trim().isNotEmpty) {
                                              setState(() {
                                                noReferensiPengantaranPills.add(
                                                  val.trim(),
                                                );
                                                noReferensiPengantaranController
                                                    .clear();
                                              });
                                            }
                                          },
                                        ),
                                        if (noReferensiPengantaranPills
                                            .isNotEmpty) ...[
                                          const SizedBox(height: 8),
                                          Wrap(
                                            spacing: 8,
                                            runSpacing: 4,
                                            children: noReferensiPengantaranPills
                                                .asMap()
                                                .entries
                                                .map((entry) {
                                                  return InputChip(
                                                    label: Text(
                                                      entry.value,
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    onPressed: () =>
                                                        DeliveryOrderDetailSheet.show(
                                                          context,
                                                          entry.value,
                                                        ),
                                                    onDeleted: () {
                                                      setState(() {
                                                        noReferensiPengantaranPills
                                                            .removeAt(
                                                              entry.key,
                                                            );
                                                      });
                                                    },
                                                  );
                                                })
                                                .toList(),
                                          ),
                                        ],
                                      ] else ...[
                                        Builder(
                                          builder: (context) {
                                            final refs =
                                                widget
                                                    .tasks
                                                    ?.aktivitas
                                                    ?.noReferensi
                                                    ?.where(
                                                      (ref) =>
                                                          ref
                                                              .toUpperCase()
                                                              .startsWith(
                                                                'DO-',
                                                              ) ||
                                                          ref
                                                              .toUpperCase()
                                                              .startsWith(
                                                                'SJ-',
                                                              ),
                                                    )
                                                    .toList() ??
                                                [];
                                            if (refs.isNotEmpty) {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          bottom: 8,
                                                        ),
                                                    child: Text(
                                                      'No Referensi dari Admin:',
                                                      style: context
                                                          .textStyle
                                                          .bodySmall
                                                          ?.copyWith(
                                                            color: AppColors
                                                                .labelSecondary,
                                                          ),
                                                    ),
                                                  ),
                                                  Wrap(
                                                    spacing: 8,
                                                    runSpacing: 4,
                                                    children: refs
                                                        .map(
                                                          (ref) => ActionChip(
                                                            label: Text(
                                                              ref,
                                                              style:
                                                                  const TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                            ),
                                                            backgroundColor:
                                                                Colors.teal
                                                                    .withValues(
                                                                      alpha:
                                                                          0.08,
                                                                    ),
                                                            onPressed: () =>
                                                                DeliveryOrderDetailSheet.show(
                                                                  context,
                                                                  ref,
                                                                ),
                                                          ),
                                                        )
                                                        .toList(),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    'Klik nomor referensi untuk melihat detail DO',
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color:
                                                          Colors.grey.shade500,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }
                                            return Container(
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: Colors.orange.withValues(
                                                  alpha: 0.08,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.info_outline,
                                                    color:
                                                        Colors.orange.shade700,
                                                    size: 18,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      'Belum ada referensi pengantaran (DO) yang ditetapkan admin.',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors
                                                            .orange
                                                            .shade700,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                              AppDimens.size3M.hSpace,
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    AppDimens.radiusMedium,
                                  ),
                                ),
                                padding: const EdgeInsets.all(
                                  AppDimens.paddingMedium,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      'Bukti Kunjungan',
                                      style: context.textStyle.titleMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: FloatingPhotoInput(
                                            width: double.infinity,
                                            imagePath:
                                                (fotoPrimary?.isNotEmpty ??
                                                    false)
                                                ? fotoPrimary!.first.path
                                                : null,
                                            label: 'Foto Bukti',
                                            onTap: () => _takeFotoPrimary(
                                              usrState.isMarketing,
                                            ),
                                            onDelete: () => setState(
                                              () => fotoPrimary = [],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: FloatingPhotoInput(
                                            width: double.infinity,
                                            imagePath:
                                                (fotoSecondary?.isNotEmpty ??
                                                    false)
                                                ? fotoSecondary!.first.path
                                                : null,
                                            label: 'Foto Pendukung / Nota',
                                            onTap: _takeFotoSecondary,
                                            onDelete: () => setState(
                                              () => fotoSecondary = [],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    AppDimens.size3M.hSpace,
                                    TextFieldBasic(
                                      controller: catatan,
                                      title: 'Catatan',
                                      colorTitle: AppColors.labelSecondary,
                                      hint: 'Masukan Catatan (Optional)',
                                      multiline: true,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      AppDimens.size1X.hSpace,
                      _buildConfirmButton(mapState),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildConfirmButton(GlobalMapState mapState) {
    return BlocBuilder<UserGetLocalCubit, UserGetLocalState>(
      builder: (_, usrState) {
        return BlocConsumer<OrderCreateCubit, OrderCreateState>(
          listener: (context, orderState) async {
            if (orderState.status.isLoaded) {
              await AppModalBottom.showDefault(
                context,
                contentTitle: 'Pemeriksaan Kunjungan Berhasil',
                contentSubtitle:
                    'Anda berhasil melakukan kunjungan di ${widget.tasks?.aktivitas?.apotikId?.namaApotik ?? ''}',
                hasActionPop: true,
              );

              streamLocation.cancel();
              if (!context.mounted) return;
              context.router.pop<bool>(true);
            } else if (orderState.status.isNotLoaded) {
              await AppModalBottom.handleError(context, orderState.failure);
              streamLocation.resume();
            }
          },
          builder: (context, orderState) {
            return BlocConsumer<
              TasksPostCompletedCubit,
              TasksPostCompletedState
            >(
              listener: (context, state) async {
                if (state.status.isLoaded) {
                  // If we need to create an order, do it now
                  if (!isHybridMode &&
                      tipeCall == 'effective_call' &&
                      selectedProducts.isNotEmpty) {
                    final orderParams = SalesOrderParamsEntity(
                      outletId: widget.tasks?.aktivitas?.apotikId?.id,
                      outletNama: widget.tasks?.aktivitas?.apotikId?.namaApotik,
                      tipeOrder: tipeOrder ?? 'repeat_order',
                      tanggal: DateTime.now().toIso8601String(),
                      diskon: diskon,
                      catatan: catatan.text,
                      metodePembayaran: metodePembayaran,
                      items: selectedProducts,
                    );
                    context.read<OrderCreateCubit>().submit(orderParams);
                  } else {
                    await AppModalBottom.showDefault(
                      context,
                      contentTitle: 'Pemeriksaan Kunjungan Berhasil',
                      contentSubtitle:
                          'Anda berhasil melakukan kunjungan di ${widget.tasks?.aktivitas?.apotikId?.namaApotik ?? ''}',
                      hasActionPop: true,
                    );
                    streamLocation.cancel();
                    if (!context.mounted) return;
                    context.router.pop<bool>(true);
                  }
                } else if (state.status.isNotLoaded) {
                  await AppModalBottom.handleError(context, state.failure);
                  streamLocation.resume();
                } else {
                  streamLocation.pause();
                }
              },
              builder: (context, state) {
                return AppButton(
                  onPressed: () {
                    if (state.status.isLoading || orderState.status.isLoading)
                      return;

                    if (mapState.typeState.isLoading) {
                      Fluttertoast.showToast(msg: kMapWaiting);
                    } else if (mapState.typeState.isLoaded) {
                      if (widget.tasks?.aktivitas?.tujuanPenawaran == true &&
                          (tipeCall == null || tipeCall!.isEmpty)) {
                        Fluttertoast.showToast(
                          msg:
                              'Tipe Call wajib diisi untuk kunjungan penawaran',
                        );
                        return;
                      }

                      // Validasi foto dilakukan oleh backend berdasarkan setting

                      final params = TasksCompletedParamsEntity(
                        statusTask: StatusTask.done.toKey,
                        completedTime: DateTime.now().toIso8601String(),
                        isLembur: context
                            .read<AppCubit>()
                            .state
                            .isOvertimeActive,
                        note: catatan.text,
                        taskId: widget.tasks?.id,
                        aktivitasId: widget.tasks?.aktivitas?.id,
                        lokasi: LocationEntity(
                          longitude: mapState.targetPosition!.longitude
                              .toString(),
                          latitude: mapState.targetPosition!.latitude
                              .toString(),
                        ),
                        fotoBukti: AppUtility.fotoValueCondition(
                          fotoPrimary,
                          fotoSecondary,
                        ),
                        fotoIndexing: AppUtility.fotoIndexCondition(
                          fotoPrimary,
                          fotoSecondary,
                        ),
                        tipeCall: tipeCall,
                        kategoriOrder: isHybridMode ? null : kategoriOrder,
                        metodePembayaran: isHybridMode
                            ? null
                            : metodePembayaran,
                        orderValue:
                            (widget.tasks?.aktivitas?.tujuanPenagihan == true)
                            ? nominalPenagihan
                            : (isHybridMode ? nominalManual : netSales),
                        jadwalPembayaran: isHybridMode
                            ? null
                            : (jadwalPembayaran.isNotEmpty
                                  ? jadwalPembayaran
                                  : null),
                        noReferensi: () {
                          if (isHybridMode) {
                            final refs = [
                              ...noReferensiPenagihanPills,
                              ...noReferensiPengantaranPills,
                            ];
                            return refs.isNotEmpty ? refs : null;
                          } else {
                            // Full Mode: use noReferensi from task (admin-assigned)
                            return widget.tasks?.aktivitas?.noReferensi;
                          }
                        }(),
                      );

                      Debounce.debounce(kDebForm, kDurSubmit, () async {
                        context.read<TasksPostCompletedCubit>().postCompleted(
                          params,
                        );
                      });
                    }
                  },
                  text: 'Konfirmasi',
                  isLoading:
                      state.status.isLoading || orderState.status.isLoading,
                );
              },
            );
          },
        );
      },
    );
  }
}
