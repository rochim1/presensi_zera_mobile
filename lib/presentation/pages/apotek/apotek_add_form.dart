import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';
import 'package:presensi_data/presensi_data.dart';

@RoutePage()
class ApotekAddForm extends StatefulWidget {
  const ApotekAddForm({super.key});

  @override
  State<ApotekAddForm> createState() => _ApotekAddFormState();
}

class _ApotekAddFormState extends State<ApotekAddForm> {
  late Completer<GoogleMapController> mapController = Completer();
  late Location location = Location();
  late GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController alamatController = TextEditingController();
  late TextEditingController provinsiController = TextEditingController();
  late TextEditingController kabupatenController = TextEditingController();
  late TextEditingController namaApotekController = TextEditingController();
  late TextEditingController noTelpController = TextEditingController();
  late TextEditingController kodeOutletController = TextEditingController();

  bool _isLoadingCode = false;
  bool _isLoadingProvinsi = false;
  bool _isLoadingKabupaten = false;
  bool _hasFetchedLocation = false;
  String? _lastAutoAddress;
  List<Map<String, dynamic>> _listProvinsi = [];
  List<Map<String, dynamic>> _listKabupaten = [];

  List<String> get _provinsiOptions =>
      _listProvinsi.map((e) => (e['KOTA'] ?? '').toString()).toList();
  List<String> get _kabupatenOptions =>
      _listKabupaten.map((e) => (e['KABUPATEN'] ?? '').toString()).toList();

  String? _findMatchingItem(List<String> items, String text) {
    if (text.isEmpty) return null;
    final lower = text.toLowerCase();
    for (final item in items) {
      if (item.toLowerCase() == lower) return item;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _fetchOutletCode();
    _fetchProvinsi();
  }

  Future<void> _fetchOutletCode() async {
    setState(() => _isLoadingCode = true);
    try {
      final graphQlService = sl<GraphQlService>();
      final res = await graphQlService.query(
        query: '''
        query getAvailableCodeOutlet(\$tipe_outlet: String) {
          getAvailableCodeOutlet(tipe_outlet: \$tipe_outlet) {
            kode_outlet
          }
        }
      ''',
        variables: {'tipe_outlet': 'outlet'},
      );
      if (mounted) {
        kodeOutletController.text =
            res['getAvailableCodeOutlet']?['kode_outlet'] ?? '';
      }
    } catch (e) {
      log.e(e.toString());
    }
    if (mounted) {
      setState(() => _isLoadingCode = false);
    }
  }

  Future<void> _fetchProvinsi() async {
    setState(() => _isLoadingProvinsi = true);
    try {
      final graphQlService = sl<GraphQlService>();
      final res = await graphQlService.query(
        query: '''
        query GetListKota {
          GetListKota {
            KOTA
            ID
          }
        }
        ''',
      );
      if (mounted) {
        setState(() {
          if (res['GetListKota'] != null) {
            _listProvinsi = List<Map<String, dynamic>>.from(res['GetListKota']);
          }
        });
      }
    } catch (e) {
      log.e(e.toString());
    }
    if (mounted) setState(() => _isLoadingProvinsi = false);
  }

  Future<void> _fetchKabupaten(String? namaProvinsi) async {
    if (namaProvinsi == null || namaProvinsi.isEmpty) return;
    setState(() {
      _isLoadingKabupaten = true;
      _listKabupaten = [];
      kabupatenController.text = '';
    });
    try {
      final graphQlService = sl<GraphQlService>();
      final res = await graphQlService.query(
        query: '''
        query GetListKabupaten(\$namaKota: String) {
          GetListKabupaten(nama_kota: \$namaKota) {
            KABUPATEN
            ID
          }
        }
        ''',
        variables: {'namaKota': namaProvinsi},
      );
      if (mounted) {
        setState(() {
          if (res['GetListKabupaten'] != null) {
            _listKabupaten = List<Map<String, dynamic>>.from(
              res['GetListKabupaten'],
            );
          }
        });
      }
    } catch (e) {
      log.e(e.toString());
    }
    if (mounted) setState(() => _isLoadingKabupaten = false);
  }

  void onMapCreate(
    BuildContext ctxMap,
    GoogleMapController ctrl,
    GlobalMapState mapState,
  ) {
    if (!mapController.isCompleted) {
      mapController.complete(ctrl);
    }
    if (mapState.typeState.isLoaded && mapState.targetPosition != null) {
      ctrl.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: mapState.targetPosition!, zoom: 16),
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    mapController = Completer();
    alamatController.dispose();
    provinsiController.dispose();
    kabupatenController.dispose();
    namaApotekController.dispose();
    noTelpController.dispose();
    kodeOutletController.dispose();
    Debounce.cancelAll();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<GlobalMapCubit>()..getPermissionStatus(),
        ),
        BlocProvider(create: (context) => sl<ApotekPostDataCubit>()),
      ],
      child: BlocConsumer<GlobalMapCubit, GlobalMapState>(
        listener: (context, mapState) {
          if (mapState.isLocationGranted && !_hasFetchedLocation) {
            _hasFetchedLocation = true;
            context.read<GlobalMapCubit>().updateToCurrentLocation();
          }

          if (mapState.typeState.isLoaded) {
            if (mapState.targetPosition != null && mapController.isCompleted) {
              mapController.future.then((ctrl) {
                ctrl.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(target: mapState.targetPosition!, zoom: 16),
                  ),
                );
              });
            }

            if (mapState.isLocationGranted) {
              if (mapState.address?.isEmpty ?? false) {
                Fluttertoast.showToast(msg: kAddressNotFound);
              } else if (mapState.address != null) {
                final newAddress = mapState.address!.toString();
                if (newAddress != '-' && _lastAutoAddress != newAddress) {
                  alamatController.text = newAddress;
                  if (mapState.address?.province != null) {
                    provinsiController.text = mapState.address!.province!;
                    _fetchKabupaten(provinsiController.text).then((_) {
                      if (mounted && mapState.address?.regency != null) {
                        setState(
                          () => kabupatenController.text =
                              mapState.address!.regency!,
                        );
                      }
                    });
                  } else {
                    provinsiController.text = '';
                    kabupatenController.text = '';
                  }
                  _lastAutoAddress = newAddress;
                }
              }
            }
          }
          if (mapState.typeState.isNotLoaded) {
            Fluttertoast.showToast(msg: mapState.message!);
            if (!mapState.isLocationGranted) {
              context.router.pop();
            }
          }
        },
        builder: (ctxMap, mapState) {
          return UnfocuserForm(
            child: Scaffold(
              backgroundColor: const Color(0xFFF5F7F9),
              body: Stack(
                children: [
                  Container(
                    height: 220,
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
                      child: Image.asset(
                        AppImages.geometricBg,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Column(
                      children: [
                        const AppTopBar(
                          title: 'Tambah Outlet Baru',
                          useGradient: false,
                          backgroundColor: Colors.transparent,
                          titleColor: AppColors.white,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.fromLTRB(
                              AppDimens.w16,
                              0,
                              AppDimens.w16,
                              AppDimens.w16,
                            ),
                            child: Container(
                              padding: EdgeInsets.all(AppDimens.w16),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(
                                  AppDimens.radiusLarge,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      AppDimens.radiusMedium,
                                    ),
                                    child: MapViewDraggable(
                                      initialCameraPosition: CameraPosition(
                                        target: mapState.targetPosition!,
                                        zoom: 16,
                                      ),
                                      onMapCreated: (controller) => onMapCreate(
                                        ctxMap,
                                        controller,
                                        mapState,
                                      ),
                                      position: mapState.targetPosition!,
                                      address: mapState.address?.toMakerTitle(),
                                      onTap: (value) => ctxMap
                                          .read<GlobalMapCubit>()
                                          .updateTarget(value),
                                      onMyLocation: () {
                                        ctxMap
                                            .read<GlobalMapCubit>()
                                            .updateToCurrentLocation();
                                      },
                                      gestureRecognizers: MapViewDraggable
                                          .eagerGestureRecognizer,
                                    ),
                                  ),
                                  Form(
                                    key: formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppDimens.size3M.hSpace,
                                        ApotekMapCardWidget(
                                          target: mapState.targetPosition,
                                          isLoading:
                                              mapState.typeState.isLoading,
                                          addreass: mapState.address!,
                                        ),
                                        AppDimens.size3M.hSpace,
                                        Visibility(
                                          visible:
                                              mapState.address?.isNotEmpty ??
                                              false,
                                          child: TextFieldBasic(
                                            controller: alamatController,
                                            title: 'Detail Alamat',
                                            hint: 'Masukan detail alamat',
                                            multiline: true,
                                            required: true,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return kEmptyValidator.rich([
                                                  'Detail Alamat',
                                                ]);
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        AppDimens.size3M.hSpace,
                                        Visibility(
                                          visible:
                                              mapState.address?.isNotEmpty ??
                                              false,
                                          child:
                                              TextFieldDropdownSearch<String>(
                                                title: 'Provinsi',
                                                hintSearch: 'Cari provinsi...',
                                                hint: _isLoadingProvinsi
                                                    ? 'Memuat provinsi...'
                                                    : 'Pilih provinsi',
                                                items: _provinsiOptions,
                                                itemAsString: (item) => item,
                                                compareFn: (a, b) =>
                                                    a.toLowerCase() ==
                                                    b?.toLowerCase(),
                                                selectedItem: _findMatchingItem(
                                                  _provinsiOptions,
                                                  provinsiController.text,
                                                ),
                                                onChanged: (val) {
                                                  if (val != null) {
                                                    setState(() {
                                                      provinsiController.text =
                                                          val;
                                                      _fetchKabupaten(val);
                                                    });
                                                  }
                                                },
                                                required: true,
                                                validator: (value) {
                                                  if (provinsiController
                                                      .text
                                                      .isEmpty) {
                                                    return kEmptyValidator.rich(
                                                      ['Provinsi'],
                                                    );
                                                  }
                                                  return null;
                                                },
                                              ),
                                        ),
                                        AppDimens.size3M.hSpace,
                                        Visibility(
                                          visible:
                                              mapState.address?.isNotEmpty ??
                                              false,
                                          child:
                                              TextFieldDropdownSearch<String>(
                                                title: 'Kabupaten/Kota',
                                                hintSearch:
                                                    'Cari kabupaten/kota...',
                                                hint: _isLoadingKabupaten
                                                    ? 'Memuat kabupaten/kota...'
                                                    : 'Pilih kabupaten/kota',
                                                items: _kabupatenOptions,
                                                itemAsString: (item) => item,
                                                compareFn: (a, b) =>
                                                    a.toLowerCase() ==
                                                    b?.toLowerCase(),
                                                selectedItem: _findMatchingItem(
                                                  _kabupatenOptions,
                                                  kabupatenController.text,
                                                ),
                                                onChanged: (val) {
                                                  if (val != null) {
                                                    setState(() {
                                                      kabupatenController.text =
                                                          val;
                                                    });
                                                  }
                                                },
                                                required: true,
                                                validator: (value) {
                                                  if (kabupatenController
                                                      .text
                                                      .isEmpty) {
                                                    return kEmptyValidator.rich(
                                                      ['Kabupaten/Kota'],
                                                    );
                                                  }
                                                  return null;
                                                },
                                              ),
                                        ),
                                        AppDimens.size2L.hSpace,
                                        Text(
                                          'Data Outlet',
                                          style: context.textStyle.titleMedium!
                                              .copyWith(
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                        AppDimens.size3M.hSpace,
                                        TextFieldBasic(
                                          controller: kodeOutletController,
                                          title: 'Kode Outlet',
                                          hint: _isLoadingCode
                                              ? 'Memuat kode...'
                                              : 'Kode outlet',
                                          enabled: !_isLoadingCode,
                                          required: true,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return kEmptyValidator.rich([
                                                'Kode Outlet',
                                              ]);
                                            }
                                            return null;
                                          },
                                        ),
                                        AppDimens.size3M.hSpace,
                                        TextFieldBasic(
                                          controller: namaApotekController,
                                          title: 'Nama Outlet',
                                          hint: 'Masukan nama outlet',
                                          maxLength: 40,
                                          required: true,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return kEmptyValidator.rich([
                                                'Nama Outlet',
                                              ]);
                                            }
                                            return null;
                                          },
                                        ),
                                        AppDimens.size3M.hSpace,
                                        TextFieldBasic(
                                          controller: noTelpController,
                                          title: 'Nomor Telepon',
                                          hint: 'Masukan Nomor Telepon',
                                          required: true,
                                          inputType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          maxLength: 13,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return kEmptyValidator.rich([
                                                'Nomor Telepon',
                                              ]);
                                            }
                                            if (!value.regexPhoneNumber) {
                                              return kNotWrongValidatior.rich([
                                                'Nomor Telepon',
                                              ]);
                                            }

                                            return null;
                                          },
                                        ),
                                        AppDimens.size1X.hSpace,
                                        BlocConsumer<
                                          ApotekPostDataCubit,
                                          ApotekPostDataState
                                        >(
                                          listener: (_, state) async {
                                            if (state.status.isLoaded) {
                                              await AppModalBottom.showDefault(
                                                context,
                                                contentTitle:
                                                    'Outlet Baru berhasil dibuat',
                                                contentSubtitle:
                                                    'Anda berhasil membuat Outlet ${namaApotekController.text}.',
                                                hasActionPop: true,
                                              );

                                              if (!context.mounted) return;
                                              context.router.pop<bool>(true);
                                            } else if (state
                                                .status
                                                .isNotLoaded) {
                                              await AppModalBottom.handleError(
                                                context,
                                                state.failure,
                                              );
                                            }
                                          },
                                          builder: (context, state) {
                                            return AppButton(
                                              onPressed: () {
                                                if (state.status.isLoading) {
                                                  return;
                                                }

                                                if (mapState.address?.isEmpty ??
                                                    false) {
                                                  return;
                                                }

                                                if (mapState
                                                    .typeState
                                                    .isLoading) {
                                                  Fluttertoast.showToast(
                                                    msg: kMapWaiting,
                                                  );
                                                  return;
                                                }

                                                if (formKey.currentState!
                                                    .validate()) {
                                                  formKey.currentState?.save();

                                                  final params =
                                                      ApotekParamsEntity(
                                                        namaApotik:
                                                            namaApotekController
                                                                .text,
                                                        kodePetugas: 'NONE-0',
                                                        noIjin: '',
                                                        namaAPJ: 'NONE-0',
                                                        telponNumber:
                                                            noTelpController
                                                                .text,
                                                        latitude: mapState
                                                            .targetPosition!
                                                            .latitude
                                                            .toString(),
                                                        longitude: mapState
                                                            .targetPosition!
                                                            .longitude
                                                            .toString(),
                                                        provinsi:
                                                            provinsiController
                                                                .text
                                                                .isNotEmpty
                                                            ? provinsiController
                                                                  .text
                                                            : mapState
                                                                  .address
                                                                  ?.province,
                                                        kabupaten:
                                                            kabupatenController
                                                                .text
                                                                .isNotEmpty
                                                            ? kabupatenController
                                                                  .text
                                                            : mapState
                                                                  .address
                                                                  ?.regency,
                                                        kecamatan: mapState
                                                            .address
                                                            ?.district,
                                                        kelurahan: mapState
                                                            .address
                                                            ?.subDistrict,
                                                        kodePos: mapState
                                                            .address
                                                            ?.postal,
                                                        alamat: alamatController
                                                            .text,
                                                        kodeOutlet:
                                                            kodeOutletController
                                                                .text,
                                                      );
                                                  Debounce.debounce(
                                                    kDebForm,
                                                    kDurSubmit,
                                                    () async {
                                                      context
                                                          .read<
                                                            ApotekPostDataCubit
                                                          >()
                                                          .postData(params);
                                                    },
                                                  );
                                                }
                                              },
                                              text: 'Simpan',
                                              isLoading: state.status.isLoading,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
