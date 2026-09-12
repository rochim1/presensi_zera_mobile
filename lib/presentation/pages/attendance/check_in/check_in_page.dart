import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_cubit.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_state.dart';

import '../formz/_formz.dart';
import 'bloc/check_in_state.dart';

@RoutePage()
class CheckInPage extends StatelessWidget {
  const CheckInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, appState) {
        final setting = appState.setting.data;
        if (!appState.setting.isSuccess || setting == null) {
          return const _SettingUnavailablePage(title: 'Check In');
        }
        final completedAttendance =
            appState.activeAttendance.data?.jamPulang != null;
        final mode = setting.attendanceMode ?? SettingAttendanceMode.tanpa_foto;
        final availableTypes = _resolveAvailableAttendanceTypes(
          setting,
          afterCheckout: completedAttendance,
        );
        return BlocProvider(
          key: ValueKey(mode),
          create: (_) =>
              sl<CheckInCubit>()
                ..init(mode, initialPresenceType: availableTypes.first),
          child: CheckInView(mode: mode),
        );
      },
    );
  }
}

Future<bool> ensureAttendanceSettingAvailable(BuildContext context) async {
  final appCubit = context.read<AppCubit>();

  bool isAvailable() =>
      appCubit.state.setting.isSuccess && appCubit.state.setting.data != null;

  if (isAvailable()) {
    // A valid cache keeps the UI usable, but it may contain an old attendance
    // mode. Always synchronize the latest setting before opening attendance.
    await appCubit.getSetting();
    return true;
  }

  // App initialization may still be fetching the user/setting when the route
  // is opened. Wait for that in-flight work instead of showing a false warning.
  if (appCubit.state.user.isLoading || appCubit.state.setting.isLoading) {
    try {
      await appCubit.stream
          .firstWhere(
            (state) => !state.user.isLoading && !state.setting.isLoading,
          )
          .timeout(const Duration(seconds: 15));
    } on TimeoutException {
      // Continue with cache/network recovery below.
    }
    if (isAvailable()) return true;
  }

  // Cache makes this reliable during a slow refresh or a brief network issue.
  await appCubit.loadSettingCache();
  if (isAvailable()) return true;

  // Fetch only the required setting. A full dashboard refresh is unnecessary
  // and can make the attendance route appear stuck.
  await appCubit.getSetting();
  if (isAvailable()) return true;
  if (!context.mounted) return false;

  var refreshing = false;
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setDialogState) => AlertDialog(
        title: const Text('Pengaturan presensi belum tersedia'),
        content: const Text(
          'Perbarui data terlebih dahulu sebelum melakukan presensi.',
        ),
        actions: [
          TextButton(
            onPressed: refreshing
                ? null
                : () => Navigator.of(dialogContext).pop(false),
            child: const Text('Tutup'),
          ),
          FilledButton(
            onPressed: refreshing
                ? null
                : () async {
                    setDialogState(() => refreshing = true);
                    await appCubit.loadSettingCache();
                    if (!isAvailable()) await appCubit.getSetting();
                    if (!dialogContext.mounted) return;
                    final available = isAvailable();
                    if (available) {
                      Navigator.of(dialogContext).pop(true);
                      return;
                    }
                    setDialogState(() => refreshing = false);
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Pengaturan belum dapat dimuat. Periksa koneksi lalu coba lagi.',
                        ),
                      ),
                    );
                  },
            child: refreshing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Perbarui'),
          ),
        ],
      ),
    ),
  );
  return result == true;
}

class _SettingUnavailablePage extends StatefulWidget {
  final String title;
  const _SettingUnavailablePage({required this.title});

  @override
  State<_SettingUnavailablePage> createState() =>
      _SettingUnavailablePageState();
}

class _SettingUnavailablePageState extends State<_SettingUnavailablePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final available = await ensureAttendanceSettingAvailable(context);
      if (!mounted) return;
      if (available) {
        context.router.replace(const CheckInPageRoute());
      } else {
        context.router.maybePop();
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppTopBar(title: widget.title),
    body: const Center(child: CircularProgressIndicator()),
  );
}

class CheckInView extends StatefulWidget {
  final SettingAttendanceMode mode;
  const CheckInView({super.key, required this.mode});

  @override
  State<CheckInView> createState() => _CheckInViewState();
}

class _CheckInViewState extends State<CheckInView> {
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  bool _hasOpenedCamera = false;

  @override
  void initState() {
    super.initState();
    // On web, Google Maps may never finish initializing (for example when its
    // API key is rejected). Opening the selfie must not depend on the map.
    if (kIsWeb && widget.mode == SettingAttendanceMode.foto) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _openSelfieOnce();
      });
    }
  }

  void _openSelfieOnce() {
    if (_hasOpenedCamera || widget.mode != SettingAttendanceMode.foto) return;
    _hasOpenedCamera = true;
    onTapPhoto();
  }

  void onTapLocation(BuildContext context, CheckInState state) {
    final location = state.currentAddress.maybeWhen(
      orElse: () => null,
      success: (data) => data.location,
    );
    if (location == null) return;
    context.router.push(
      LocationPickerPageRoute(
        initialLat: location.lat,
        initialLong: location.long,
        isReadOnly: true,
      ),
    );
  }

  void onTapPhoto() async {
    final result = await context.router.push<XFile?>(
      AppCameraPageRoute(type: AppCameraType.selfie),
    );

    if (mounted) {
      context.read<CheckInCubit>().onChangePhoto(result);
    }
  }

  void onTapAttachment(BuildContext context) async {
    final result = await AppUtility.fileAttachment(
      true,
      AttachmentInput.allowedExtensions,
      FileType.custom,
    );
    if (result.isEmpty) return;

    if (context.mounted) {
      context.read<CheckInCubit>().onChangeAttachment(
        result.map((e) => e).toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckInCubit, CheckInState>(
      listenWhen: (previous, current) =>
          previous.currentAddress != current.currentAddress ||
          previous.checkIn != current.checkIn ||
          previous.attendanceMode != current.attendanceMode,
      listener: (context, state) {
        state.currentAddress.maybeWhen(
          success: (data) async {
            // Camera navigation must run before map animation. Waiting for an
            // uninitialized web map here used to block the selfie indefinitely.
            _openSelfieOnce();

            if (_mapController.isCompleted) {
              final controller = await _mapController.future;
              controller.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(data.location.lat, data.location.long),
                    zoom: 15,
                  ),
                ),
              );
            }
          },
          failure: (_) {
            _openSelfieOnce();
          },
          orElse: () {},
        );

        state.checkIn.maybeWhen(
          success: (_) async {
            await context.read<AppCubit>().getActiveAttendance();
            if (!context.mounted) return;
            AppSnackbar.showSuccess(context, 'Presensi berhasil dikirim');
            context.router.pop();
          },
          failure: (v) {
            AppSnackbar.showError(context, v.message);
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        final cubit = context.read<CheckInCubit>();
        final latValue = state.currentAddress.maybeWhen(
          orElse: () => kDDefaultLat,
          success: (d) => d.location.lat,
        );
        final longValue = state.currentAddress.maybeWhen(
          orElse: () => kDDefaultLong,
          success: (d) => d.location.long,
        );
        final latLng = LatLng(latValue, longValue);

        final isSuccess = state.currentAddress.maybeWhen(
          success: (_) => true,
          orElse: () => false,
        );

        return UnfocuserForm(
          child: Scaffold(
            body: Stack(
              children: [
                // Map Layer
                _buildMap(latLng, isSuccess, state),

                // Top Overlay Layer
                _buildTopOverlay(cubit, state),

                // Photo Preview Layer (Floating)
                if (state.attendanceMode == SettingAttendanceMode.foto)
                  Positioned(
                    right: AppDimens.paddingMedium,
                    bottom: FloatingPhotoInput.safeBottomOffset(context),
                    child: FloatingPhotoInput(
                      imagePath: state.form.photo.value?.path,
                      imageFile: state.form.photo.value,
                      onTap: () => onTapPhoto(),
                      onDelete: () => cubit.onChangePhoto(null),
                      errorText: state.form.photo.errorMessage,
                    ),
                  ),

                // Bottom Sheet Layer (Draggable)
                _buildBottomSheet(cubit, state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMap(LatLng latLng, bool isSuccess, CheckInState state) {
    return Positioned.fill(
      child: GoogleMap(
        initialCameraPosition: CameraPosition(target: latLng, zoom: 15),
        onMapCreated: (controller) => _mapController.complete(controller),
        zoomControlsEnabled: false,
        myLocationButtonEnabled: false,
        markers: isSuccess
            ? {
                Marker(
                  markerId: const MarkerId('current_location'),
                  position: latLng,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed,
                  ),
                ),
              }
            : {},
        circles: isSuccess
            ? {
                Circle(
                  circleId: const CircleId('current_circle'),
                  center: latLng,
                  radius: 120,
                  fillColor: AppColors.primary.withValues(alpha: 0.15),
                  strokeColor: AppColors.primary.withValues(alpha: 0.3),
                  strokeWidth: 1,
                ),
              }
            : {},
      ),
    );
  }

  Widget _buildTopOverlay(CheckInCubit cubit, CheckInState state) {
    return Positioned(
      top: context.paddingSize.top + AppDimens.paddingSmall,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingSmall),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppCircleButton(
              icon: Icons.arrow_back,
              onTap: () => context.router.pop(),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Text(
                state.currentTime,
                style: context.textStyle.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: Colors.black,
                ),
              ),
            ),
            AppCircleButton(
              icon: Icons.refresh,
              onTap: () => cubit.getCurrentAddress(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheet(CheckInCubit cubit, CheckInState state) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.32,
      maxChildSize: 0.9,
      snap: true,
      builder: (context, scrollController) {
        return AttendanceBottomSheet(
          addressState: state.currentAddress,
          scrollController: scrollController,
          locationError: state.form.location.errorMessage,
          actionButton: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              children: [
                AttendanceTypeSelector(
                  selectedType: state.presenceType,
                  onChanged: cubit.onChangePresenceType,
                  availableTypes: _availableAttendanceTypes(context),
                ),
                AppDimens.paddingMedium.hSpace,
                AppButton(
                  onPressed: cubit.submit,
                  text: 'Check In',
                  isLoading: state.checkIn.isLoading,
                ),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                label: 'Catatan (Opsional)',
                hintText: 'Masukkan catatan untuk kehadiran ini',
                maxLines: 3,
                onChanged: cubit.onChangeKeterangan,
                errorText: state.form.keterangan.errorMessage,
              ),
              AppDimens.paddingMedium.hSpace,
              AppAttachmentField(
                label: 'Lampiran (Opsional)',
                hintText: 'Tambahkan foto atau dokumen pendukung',
                errorText: state.form.attachment.errorMessage,
                value: state.form.attachment.value
                    .map((e) => e.name)
                    .join(', '),
                onDelete: () {
                  cubit.onChangeAttachment([]);
                },
                onTap: () => onTapAttachment(context),
              ),
            ],
          ),
        );
      },
    );
  }

  List<AttendanceType> _availableAttendanceTypes(BuildContext context) {
    final appState = context.read<AppCubit>().state;
    final setting = appState.setting.data;
    final completedAttendance =
        appState.activeAttendance.data?.jamPulang != null;
    return _resolveAvailableAttendanceTypes(
      setting,
      afterCheckout: completedAttendance,
    );
  }
}

List<AttendanceType> _resolveAvailableAttendanceTypes(
  Setting? setting, {
  bool afterCheckout = false,
}) {
  if (setting == null) return AttendanceType.values;

  final types = <AttendanceType>[];
  if (!afterCheckout && setting.allowDailyAttendance) {
    types.add(AttendanceType.daily);
  }
  if (setting.allowShiftAttendance) types.add(AttendanceType.shift);
  if (setting.allowOnCallAttendance &&
      (!afterCheckout || setting.allowOnCallAfterCheckout)) {
    types.add(AttendanceType.oncall);
  }

  return types.isEmpty ? [AttendanceType.daily] : types;
}
