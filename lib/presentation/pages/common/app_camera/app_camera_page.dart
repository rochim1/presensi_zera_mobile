import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';
import 'bloc/app_camera_state.dart';
import 'widgets/app_camera_overlay.dart';

@RoutePage()
class AppCameraPage extends StatelessWidget {
  final AppCameraType type;

  const AppCameraPage({super.key, this.type = AppCameraType.selfie});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AppCameraCubit>()..initialize(type: type),
      child: const AppCameraView(),
    );
  }
}

class AppCameraView extends StatefulWidget {
  const AppCameraView({super.key});

  @override
  State<AppCameraView> createState() => _AppCameraViewState();
}

class _AppCameraViewState extends State<AppCameraView> {
  bool _isLeaving = false;

  Future<void> _finish(XFile? file) async {
    if (_isLeaving || context.read<AppCameraCubit>().isBusy) return;
    setState(() => _isLeaving = true);
    try {
      final popped = await context.router.maybePop<XFile?>(file);
      if (!popped && mounted) setState(() => _isLeaving = false);
    } catch (_) {
      if (mounted) setState(() => _isLeaving = false);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppCameraCubit>();
    return BlocBuilder<AppCameraCubit, AppCameraState>(
      builder: (context, state) {
        return PopScope(
          canPop: !cubit.isBusy,
          child: Scaffold(
            backgroundColor: Colors.black,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: Text(
                state.type.title,
                style: context.textStyle.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              automaticallyImplyLeading: false,
            ),
            body: BlocConsumer<AppCameraCubit, AppCameraState>(
              listener: (context, state) {
                if (state.status == AppCameraStatus.failure &&
                    state.errorMessage != null) {
                  AppSnackbar.showError(context, state.errorMessage ?? '');
                }
              },
              builder: (context, state) {
                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: kIsWeb ? 520 : double.infinity,
                    ),
                    child: Stack(
                      children: [
                        // Camera Preview or Captured File
                        if (state.capturedFile != null)
                          Positioned.fill(
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationY(
                                !kIsWeb &&
                                        state.lensDirection ==
                                            CameraLensDirection.front
                                    ? 3.14159
                                    : 0,
                              ),
                              child: kIsWeb
                                  ? FutureBuilder<Uint8List>(
                                      future: state.capturedFile!.readAsBytes(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return const Center(
                                            child: Icon(
                                              Icons.broken_image_outlined,
                                              color: Colors.white,
                                              size: 48,
                                            ),
                                          );
                                        }
                                        if (!snapshot.hasData) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                        return Image.memory(
                                          snapshot.data!,
                                          // Desktop webcams are usually
                                          // landscape; keep the complete frame.
                                          fit: BoxFit.contain,
                                        );
                                      },
                                    )
                                  : Image.file(
                                      File(state.capturedFile!.path),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          )
                        else
                          Positioned.fill(
                            child: _buildCameraPreview(cubit, state),
                          ),

                        // Scanning Overlay (only show if not previewing)
                        if (state.capturedFile == null)
                          Positioned.fill(
                            child: CustomPaint(
                              painter: AppCameraOverlay(
                                isFaceDetected: state.isFaceDetected,
                              ),
                            ),
                          ),

                        // Instructions (only show if not previewing)
                        if (state.capturedFile == null)
                          Positioned(
                            bottom: 150,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(
                                    AppDimens.r20,
                                  ),
                                ),
                                child: Text(
                                  kIsWeb
                                      ? 'Pastikan wajah terlihat jelas, lalu ambil foto'
                                      : state.isFaceDetected
                                      ? 'Wajah Terdeteksi'
                                      : state.type.instruction,
                                  style: context.textStyle.bodySmall?.copyWith(
                                    color: !kIsWeb && state.isFaceDetected
                                        ? Colors.green
                                        : Colors.white,
                                    fontWeight: !kIsWeb && state.isFaceDetected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),

                        // Action Buttons (floating)
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: _buildActionButtons(context, cubit, state),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildCameraPreview(AppCameraCubit cubit, AppCameraState state) {
    final controller = cubit.controller;
    if (controller == null || !controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final previewSize = controller.value.previewSize;
        if (previewSize == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return ClipRect(
          child: SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                // previewSize is reported in sensor landscape orientation.
                // Swap it for portrait UI so preview and captured image match.
                width: previewSize.height,
                height: previewSize.width,
                child: CameraPreview(controller),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    AppCameraCubit cubit,
    AppCameraState state,
  ) {
    final busy = cubit.isBusy || _isLeaving;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    if (state.capturedFile != null && state.status == AppCameraStatus.success) {
      return Container(
        padding: EdgeInsets.fromLTRB(
          AppDimens.paddingLarge,
          AppDimens.paddingLarge,
          AppDimens.paddingLarge,
          AppDimens.paddingLarge + bottomPadding,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: busy ? null : () => cubit.retake(),
              icon: Icon(
                PhosphorIcons.arrowsClockwise,
                size: AppDimens.iconLarge,
              ),
              color: Colors.white,
            ),

            // Shutter Button
            GestureDetector(
              onTap: busy ? null : () => _finish(state.capturedFile),
              child: Opacity(
                opacity: 1.0,
                child: Container(
                  width: AppDimens.w80,
                  height: AppDimens.h80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.green.withValues(alpha: 0.2),
                    border: Border.all(
                      color: AppColors.white,
                      width: AppDimens.w4,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: AppDimens.size1X,
                      height: AppDimens.size1X,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.green,
                      ),
                      child: _isLeaving
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            )
                          : Icon(
                              PhosphorIcons.check,
                              color: AppColors.white,
                              size: AppDimens.sizeXL,
                            ),
                    ),
                  ),
                ),
              ),
            ),

            // Empty space to balance the layout
            SizedBox(width: AppDimens.w48),
          ],
        ),
      );
    }

    // ML Kit face detection is unavailable on Flutter Web. The browser camera
    // must therefore allow manual capture; native front cameras keep the face
    // detection requirement.
    final bool canCapture =
        !busy &&
        (state.status == AppCameraStatus.ready ||
            state.status == AppCameraStatus.failure) &&
        (kIsWeb ||
            state.lensDirection == CameraLensDirection.back ||
            state.isFaceDetected);

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppDimens.paddingLarge,
        AppDimens.paddingLarge,
        AppDimens.paddingLarge,
        AppDimens.paddingLarge + bottomPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Switch Camera
          if (!state.type.onlyFront)
            IconButton(
              onPressed: busy ? null : () => cubit.switchCamera(),
              icon: Icon(PhosphorIcons.cameraRotate, size: AppDimens.iconLarge),
              color: Colors.white,
            )
          else
            SizedBox(width: AppDimens.w48),

          // Shutter Button
          GestureDetector(
            onTap: canCapture ? () => cubit.takePicture() : null,
            child: Opacity(
              opacity: canCapture ? 1.0 : 0.5,
              child: Container(
                width: AppDimens.w80,
                height: AppDimens.h80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.orange.withValues(alpha: 0.2),
                  border: Border.all(
                    color: AppColors.white,
                    width: AppDimens.w4,
                  ),
                ),
                child: Center(
                  child: Container(
                    width: AppDimens.size1X,
                    height: AppDimens.size1X,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.orange,
                    ),
                    child: busy
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          )
                        : Icon(
                            PhosphorIcons.apertureFill,
                            color: AppColors.white,
                            size: AppDimens.sizeXL,
                          ),
                  ),
                ),
              ),
            ),
          ),

          // Close Button
          SizedBox(
            width: 48,
            height: 48,
            child: IconButton(
              onPressed: busy ? null : () => _finish(null),
              padding: const EdgeInsets.all(12),
              iconSize: 20,
              icon: const Icon(PhosphorIcons.x),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
