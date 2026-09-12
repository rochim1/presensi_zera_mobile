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
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_cubit.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_state.dart';
import 'package:presensi_mobile/service/background_location_service.dart';
import 'package:presensi_mobile/service/websocket_service.dart';

import '../formz/_formz.dart';
import 'bloc/check_out_state.dart';

@RoutePage()
class CheckOutPage extends StatelessWidget {
  const CheckOutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, appState) {
        final setting = appState.setting.data;
        if (!appState.setting.isSuccess || setting == null) {
          return const _SettingUnavailablePage(title: 'Check Out');
        }
        final mode = setting.attendanceMode ?? SettingAttendanceMode.tanpa_foto;
        final attendanceType =
            appState.activeAttendance.data?.type ?? AttendanceType.shift;
        return BlocProvider(
          key: ValueKey(mode),
          create: (_) => sl<CheckOutCubit>()..init(mode, attendanceType),
          child: CheckOutView(mode: mode),
        );
      },
    );
  }
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
        context.router.replace(const CheckOutPageRoute());
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

class CheckOutView extends StatefulWidget {
  final SettingAttendanceMode mode;
  const CheckOutView({super.key, required this.mode});

  @override
  State<CheckOutView> createState() => _CheckOutViewState();
}

class _CheckOutViewState extends State<CheckOutView> {
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  bool _hasOpenedCamera = false;
  int? _moodScore;
  String? _workRelation;

  @override
  void initState() {
    super.initState();
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

  void onTapLocation(BuildContext context, CheckOutState state) {
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
      context.read<CheckOutCubit>().onChangePhoto(result);
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
      context.read<CheckOutCubit>().onChangeAttachment(
        result.map((e) => e).toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckOutCubit, CheckOutState>(
      listenWhen: (previous, current) =>
          previous.currentAddress != current.currentAddress ||
          previous.checkOut != current.checkOut ||
          previous.attendanceMode != current.attendanceMode,
      listener: (context, state) {
        state.currentAddress.maybeWhen(
          success: (data) async {
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

        state.checkOut.maybeWhen(
          success: (_) async {
            // ── Hentikan live location tracking setelah check-out ──
            WebSocketService.instance.notifyTrackingStopped();
            await BackgroundLocationService.stop();
            // ───────────────────────────────────────────────────────

            if (!context.mounted) return;
            final appCubit = context.read<AppCubit>();
            await appCubit.markCheckedOutToday();
            if (!state.queuedOffline) {
              await appCubit.getActiveAttendance();
            }
            if (!context.mounted) return;

            AppSnackbar.showSuccess(
              context,
              state.queuedOffline
                  ? 'Checkout disimpan offline dan akan dikirim otomatis'
                  : 'Presensi berhasil dikirim',
            );
            context.router.pop();
          },
          failure: (f) {
            AppSnackbar.showError(context, f.message);
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        final cubit = context.read<CheckOutCubit>();
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

  Widget _buildMap(LatLng latLng, bool isSuccess, CheckOutState state) {
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

  Widget _buildTopOverlay(CheckOutCubit cubit, CheckOutState state) {
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

  Widget _buildBottomSheet(CheckOutCubit cubit, CheckOutState state) {
    final policy = state.logbookPolicyResult;
    final isLogbookBlocked = policy?.isBlocked ?? false;

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
                AppButton(
                  onPressed: isLogbookBlocked
                      ? () {}
                      : () {
                          if (_moodScore == null) {
                            AppSnackbar.showError(
                              context,
                              'Pilih perasaan Anda terlebih dahulu',
                            );
                            return;
                          }
                          if (_moodScore! <= 2 && _workRelation == null) {
                            AppSnackbar.showError(
                              context,
                              'Pilih apakah kondisi ini berkaitan dengan pekerjaan',
                            );
                            return;
                          }
                          cubit.submit(
                            moodScore: _moodScore!,
                            workRelation: _workRelation,
                          );
                        },
                  text: 'Check Out',
                  isLoading:
                      state.checkOut.isLoading || state.policyState.isLoading,
                  colors: isLogbookBlocked
                      ? const [AppColors.grey, AppColors.grey]
                      : const [AppColors.red, AppColors.pink],
                ),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bagaimana perasaanmu setelah bekerja hari ini?',
                style: context.textStyle.titleMedium?.copyWith(
                  color: AppColors.labelPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:
                    const [
                      (1, '😞', 'Buruk'),
                      (2, '😟', 'Kurang'),
                      (3, '😐', 'Biasa'),
                      (4, '🙂', 'Baik'),
                      (5, '😄', 'Sangat baik'),
                    ].map((mood) {
                      final selected = _moodScore == mood.$1;
                      return Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            setState(() {
                              _moodScore = mood.$1;
                              if (mood.$1 > 2) _workRelation = null;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.primary.withValues(alpha: 0.12)
                                  : AppColors.fillTertiary,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selected
                                    ? AppColors.primary
                                    : Colors.transparent,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  mood.$2,
                                  style: const TextStyle(fontSize: 26),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  mood.$3,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: context.textStyle.labelSmall?.copyWith(
                                    color: selected
                                        ? AppColors.primary
                                        : AppColors.labelSecondary,
                                    fontWeight: selected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
              if ((_moodScore ?? 5) <= 2) ...[
                const SizedBox(height: 16),
                Text(
                  'Apakah kondisi ini berkaitan dengan pekerjaan?',
                  style: context.textStyle.bodyMedium?.copyWith(
                    color: AppColors.labelPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'yes', label: Text('Ya')),
                    ButtonSegment(value: 'partly', label: Text('Sebagian')),
                    ButtonSegment(value: 'no', label: Text('Tidak')),
                  ],
                  emptySelectionAllowed: true,
                  selected: _workRelation == null
                      ? const <String>{}
                      : {_workRelation!},
                  onSelectionChanged: (value) {
                    setState(
                      () => _workRelation = value.isEmpty ? null : value.first,
                    );
                  },
                ),
              ],
              const SizedBox(height: 20),
              if (isLogbookBlocked) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.orange.withValues(alpha: 0.1),
                    border: Border.all(color: AppColors.orange),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            PhosphorIcons.warningCircleFill,
                            color: AppColors.orange,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Logbook Wajib Diisi',
                              style: context.textStyle.titleMedium?.copyWith(
                                color: AppColors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        policy?.message ??
                            'Anda harus mengisi logbook sebelum Check Out.',
                        style: context.textStyle.bodyMedium?.copyWith(
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            context.router.push(const LogbookPageRoute());
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.orange,
                            side: const BorderSide(color: AppColors.orange),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Isi Logbook Sekarang'),
                        ),
                      ),
                    ],
                  ),
                ),
                AppDimens.paddingMedium.hSpace,
              ],
              AppTextField(
                label: 'Catatan (Opsional)',
                hintText: 'Masukkan catatan untuk presensi ini',
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
}
