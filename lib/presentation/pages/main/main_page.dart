import 'package:auto_route/auto_route.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_cubit.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_state.dart';
import 'package:presensi_mobile/service/websocket_service.dart';
import 'package:presensi_mobile/service/location_service.dart';
import 'package:presensi_mobile/service/background_location_service.dart';
import 'package:presensi_mobile/service/location_disclosure_service.dart';
import 'package:presensi_data/presensi_data.dart';

@RoutePage()
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  bool _trackingDisclosureHandledForSession = false;
  bool _waitingForLocationSettings = false;
  bool _checkingLocationPermission = false;
  bool _refreshingSettingFromSocket = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    //! setup remote config
    rc.setConfigSettings();

    _initWebSocket();
    WebSocketService.instance.addMessageListener(_onWebSocketMessage);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _hasActiveTrackingSession) {
        _startBackgroundTrackingWithConsent();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    WebSocketService.instance.removeMessageListener(_onWebSocketMessage);
    super.dispose();
  }

  Future<void> _onWebSocketMessage(Map<String, dynamic> message) async {
    if (message['type'] != 'setting_updated' ||
        _refreshingSettingFromSocket ||
        !mounted) {
      return;
    }
    _refreshingSettingFromSocket = true;
    try {
      await context.read<AppCubit>().getSetting();
    } finally {
      _refreshingSettingFromSocket = false;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _waitingForLocationSettings) {
      _waitingForLocationSettings = false;
      if (_hasActiveTrackingSession) {
        _startTrackingAfterPermissionCheck();
      }
    }
  }

  bool get _hasActiveTrackingSession {
    final appState = context.read<AppCubit>().state;
    return _hasTrackingSession(appState);
  }

  bool _hasTrackingSession(AppState appState) {
    final attendance = appState.activeAttendance.data;
    return (attendance != null && attendance.jamPulang == null) ||
        appState.isOvertimeActive;
  }

  Future<void> _startBackgroundTrackingWithConsent() async {
    if (kIsWeb ||
        !mounted ||
        _trackingDisclosureHandledForSession ||
        !_hasActiveTrackingSession) {
      return;
    }
    _trackingDisclosureHandledForSession = true;

    final accepted = await LocationDisclosureService.ensureAccepted();
    if (!accepted || !mounted) return;

    await _startTrackingAfterPermissionCheck();
  }

  Future<void> _startTrackingAfterPermissionCheck() async {
    if (kIsWeb ||
        !mounted ||
        _checkingLocationPermission ||
        !_hasActiveTrackingSession) {
      return;
    }
    _checkingLocationPermission = true;

    final hasPermission =
        await BackgroundLocationService.ensureTrackingPermission();
    _checkingLocationPermission = false;
    if (!mounted) return;

    if (!hasPermission) {
      final openSettings = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Aktifkan lokasi latar belakang'),
          content: const Text(
            'Agar live tracking tetap berjalan selama sesi kerja, buka pengaturan '
            'Pantoo lalu pilih Izin > Lokasi > Izinkan sepanjang waktu.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Nanti'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Buka Pengaturan'),
            ),
          ],
        ),
      );
      if (openSettings == true && mounted) {
        _waitingForLocationSettings = true;
        final opened = await openAppSettings();
        if (!opened) {
          _waitingForLocationSettings = false;
          Fluttertoast.showToast(
            msg: 'Pengaturan aplikasi tidak dapat dibuka.',
          );
        }
      }
      return;
    }

    final token = sl<FlavorConfig>().token ?? '';
    final baseUrl =
        sl<FlavorConfig>().baseApi ?? sl<FlavorConfig>().values?.baseApi ?? '';
    if (token.isNotEmpty && baseUrl.isNotEmpty) {
      await BackgroundLocationService.start(baseUrl: baseUrl, token: token);
    }
  }

  void _initWebSocket() {
    final token = sl<FlavorConfig>().token ?? '';
    final baseUrl =
        sl<FlavorConfig>().baseApi ?? sl<FlavorConfig>().values?.baseApi ?? '';

    if (token.isNotEmpty && baseUrl.isNotEmpty) {
      WebSocketService.instance.connect(baseUrl: baseUrl, token: token);

      final locService = sl<LocationService>();
      WebSocketService.instance.onGetCurrentLocation = () async {
        final loc = await locService.getCurrentLocation();
        return {'latitude': loc.lat, 'longitude': loc.long};
      };

      WebSocketService.instance.onCheckIsWorking = () async {
        try {
          return _hasActiveTrackingSession;
        } catch (e) {
          debugPrint('[WS] onCheckIsWorking error: $e');
          return false;
        }
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<GlobalMapCubit>()),
        BlocProvider(
          create: (context) => sl<GlobalPostFcmCubit>()..initialFCM(context),
        ),
        BlocProvider(
          create: (context) => sl<GlobalInAppUpgradeCubit>()..checkForUpdate(),
        ),
        BlocProvider(create: (context) => sl<UserGetDataCubit>()..getData()),
        BlocProvider(create: (context) => sl<UserGetLocalCubit>()..getData()),
        BlocProvider(
          create: (context) => sl<PresensiGetAllDataCubit>()..getAllData(),
        ),
        BlocProvider(
          create: (context) => sl<TasksGetAllPendingCubit>()..getAllData(),
        ),
        BlocProvider(
          create: (context) => sl<TasksGetAllSuccessCubit>()..getAllData(),
        ),
        BlocProvider(
          create: (context) => sl<TasksGetAllCanceledCubit>()..getAllData(),
        ),
        BlocProvider(
          create: (context) => sl<TasksGetAllPerjalananCubit>()..getAllData(),
        ),
        BlocProvider(
          create: (context) => sl<ApotekGetAllDataCubit>()..getAllData(),
        ),
      ],
      child: AutoTabsRouter(
        routes: [
          const HomePageRoute(),
          const AttendancePageRoute(),
          const DeliveryPageRoute(),
          ProfilePageRoute(),
        ],
        builder: (context, child) {
          var tabsRouter = context.tabsRouter;

          return BlocListener<GlobalMapCubit, GlobalMapState>(
            listener: (context, state) {
              if (state.typeState.isNotLoaded) {
                if (!state.isLocationGranted) {
                  Fluttertoast.showToast(msg: state.message!);
                }
              }
            },
            child: BlocListener<GlobalPostFcmCubit, GlobalPostFcmState>(
              listener: (context, state) {
                if (state.authorizationStatus !=
                    AuthorizationStatus.authorized) {
                  if (state.message != null) {
                    Fluttertoast.showToast(msg: state.message!);
                  } else {
                    Fluttertoast.showToast(
                      msg: 'Maaf, Notifikasi Anda tidak aktif',
                    );
                  }
                }
              },
              child: BlocListener<GlobalInAppUpgradeCubit, GlobalInAppUpgradeState>(
                listener: (_, state) async {
                  if (state.status.isLoaded) {
                    Fluttertoast.showToast(msg: state.message!);
                  } else if (state.status.isNotLoaded) {
                    final answer = await AppModalBottom.handleError(
                      context,
                      state.failure,
                    );
                    if (state.result == AppUpdateResult.userDeniedUpdate ||
                        state.result == AppUpdateResult.inAppUpdateFailed) {
                      if (answer?.isYesOk ?? false) SystemNavigator.pop();
                    }
                  }
                },
                child: BlocListener<AppCubit, AppState>(
                  listenWhen: (p, c) =>
                      p.activeAttendance.data != c.activeAttendance.data ||
                      p.overtimeStartTime != c.overtimeStartTime,
                  listener: (context, state) {
                    if (!_hasTrackingSession(state)) {
                      WebSocketService.instance.stopLiveTracking();
                      _trackingDisclosureHandledForSession = false;
                      BackgroundLocationService.stop();
                    } else {
                      _startBackgroundTrackingWithConsent();
                    }
                  },
                  child: BlocListener<UserGetDataCubit, UserGetDataState>(
                    listener: (context, state) {
                      if (state.status.isNotLoaded) {
                        Fluttertoast.showToast(msg: state.failure!.message);
                      }
                    },
                    child:
                        BlocListener<
                          PresensiGetAllDataCubit,
                          PresensiGetAllDataState
                        >(
                          listener: (context, state) {
                            if (state.status.isLoaded) {
                              final hasCheckedOutToday =
                                  state.lstData?.any((item) {
                                    final presensiDate =
                                        item.tanggalPresensi?.toDateTime;
                                    final isToday =
                                        presensiDate?.isToday ?? false;
                                    final isCheckedOut =
                                        item
                                            .statusKerja
                                            ?.toStatusKerja
                                            ?.isPulang ??
                                        false;
                                    return isToday && isCheckedOut;
                                  }) ??
                                  false;
                              context
                                  .read<AppCubit>()
                                  .syncCheckedOutDateFromTodayAttendance(
                                    hasCheckedOutToday,
                                  );
                            }

                            if (state.status.isNotLoaded) {
                              //! not show message if array has data
                              if (!(state.failure?.code.isArrayEmpty ?? true)) {
                                Fluttertoast.showToast(
                                  msg: state.failure!.message,
                                );
                              }
                            }
                          },
                          child: BlocBuilder<AppCubit, AppState>(
                            builder: (context, state) {
                              String getActionButtonLabel() {
                                if (state.isOvertimeActive) {
                                  return 'Sedang Lembur';
                                }

                                final activeAttendance =
                                    state.activeAttendance.data;
                                final hasOngoingAttendance =
                                    activeAttendance != null &&
                                    activeAttendance.jamPulang == null;
                                if (hasOngoingAttendance) return 'Check Out';

                                if (state.canStartOvertime) {
                                  final setting = state.setting.data;
                                  final canCheckInAfterCheckout =
                                      setting == null ||
                                      setting.allowShiftAttendance ||
                                      (setting.allowOnCallAttendance &&
                                          setting.allowOnCallAfterCheckout);
                                  return canCheckInAfterCheckout
                                      ? 'Check In'
                                      : 'Mulai Lembur';
                                }

                                return state.activeAttendance.maybeWhen(
                                  success: (v) => 'Check Out',
                                  orElse: () => 'Check In',
                                );
                              }

                              void onTapActionButton() async {
                                if (state.isOvertimeActive) return;

                                if (!await ensureAttendanceSettingAvailable(
                                      context,
                                    ) ||
                                    !context.mounted) {
                                  return;
                                }

                                final appCubit = context.read<AppCubit>();
                                final activeAttendance =
                                    state.activeAttendance.data;
                                final hasOngoingAttendance =
                                    activeAttendance != null &&
                                    activeAttendance.jamPulang == null;
                                if (hasOngoingAttendance) {
                                  context.router
                                      .push(CheckOutPageRoute())
                                      .then((_) => appCubit.onRefresh());
                                  return;
                                }

                                if (state.canStartOvertime) {
                                  final setting = state.setting.data;
                                  final canCheckInAfterCheckout =
                                      setting == null ||
                                      setting.allowShiftAttendance ||
                                      (setting.allowOnCallAttendance &&
                                          setting.allowOnCallAfterCheckout);
                                  if (canCheckInAfterCheckout) {
                                    context.router.push(CheckInPageRoute());
                                  } else {
                                    appCubit.startOvertime();
                                  }
                                  return;
                                }

                                state.activeAttendance.maybeWhen(
                                  success: (v) async {
                                    await context.router.push(
                                      CheckOutPageRoute(),
                                    );
                                    appCubit.onRefresh();
                                  },
                                  orElse: () async {
                                    await context.router.push(
                                      CheckInPageRoute(),
                                    );
                                  },
                                );
                              }

                              return PopScope(
                                canPop: false,
                                onPopInvokedWithResult: (didPop, result) async {
                                  if (didPop) return;
                                  if (tabsRouter.activeIndex != 0) {
                                    tabsRouter.setActiveIndex(0);
                                    return;
                                  }

                                  final shouldPop =
                                      await AppModalBottom.handleWillPop(
                                        context,
                                      );
                                  if (shouldPop && context.mounted) {
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: Scaffold(
                                  floatingActionButtonLocation:
                                      FloatingActionButtonLocation.centerDocked,
                                  floatingActionButton:
                                      AppBottomNavigationBar.buildMainActionButton(
                                        context,
                                        getActionButtonLabel(),
                                        onTapActionButton,
                                        enabled: !state.isOvertimeActive,
                                      ),
                                  bottomNavigationBar: AppBottomNavigationBar(
                                    currentIndex: tabsRouter.activeIndex,
                                    onTap: tabsRouter.setActiveIndex,
                                  ),
                                  body: child,
                                ),
                              );
                            },
                          ),
                        ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
