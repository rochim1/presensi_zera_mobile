import 'dart:math' as math;
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

part 'global_camera_action.dart';

@RoutePage()
class GlobalCameraPage extends StatefulWidget {
  final CameraLensDirection? cameraLensDirection;
  final String? message;

  const GlobalCameraPage({
    super.key,
    this.cameraLensDirection = CameraLensDirection.back,
    this.message = kDfltCapCamera,
  });

  @override
  State<GlobalCameraPage> createState() => _GlobalCameraPageState();
}

class _GlobalCameraPageState extends State<GlobalCameraPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);
    Debounce.cancelAll();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<GlobalCameraCubit>()
            ..getPermissionStatus(widget.cameraLensDirection),
      child: BlocConsumer<GlobalCameraCubit, GlobalCameraState>(
        listener: (context, state) {
          if (state.typeState.isLoaded && state.cameraState.isFailure) {
            Fluttertoast.showToast(msg: state.message!);
          }
          if (state.typeState.isNotLoaded) {
            Fluttertoast.showToast(msg: state.message!);
            if (!state.isCameraGranted) context.router.pop<XFile?>(null);
          }
        },
        builder: (context, state) {
          return Material(
            color: AppColors.bgPrimaryDark,
            child: Stack(
              children: [
                SizedBox.expand(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //! Photo view
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(AppDimens.radiusLargeX),
                            bottomRight: Radius.circular(
                              AppDimens.radiusLargeX,
                            ),
                          ),
                          child: SizedBox(
                            width: context.width,
                            child: _cameraPreview(context, state),
                          ),
                        ),
                      ),
                      //! Action
                      GlobalCameraAction(
                        info: widget.message!,
                        onClosed: () {
                          if (state.cameraState.isSuccess) {
                            Debounce.debounce(
                              kDebCamera,
                              const Duration(seconds: 1),
                              () async {
                                context
                                    .read<GlobalCameraCubit>()
                                    .onCameraInitial(
                                      widget.cameraLensDirection,
                                    );
                              },
                            );
                          }
                        },
                        onSaved: () => context.router.pop<XFile?>(state.data),
                        onCapture: () {
                          //! condition if camera initial
                          if (state.cameraState.isLoading) return;

                          //! condition if camera not available
                          if (state.cameraState.isNotAvailable) {
                            Fluttertoast.showToast(msg: state.message ?? '');
                          }

                          //! condition if camera ready to capture
                          if (state.cameraState.isReady) {
                            //! capture when face detected
                            final result = AppUtility.onCapture(
                              rc.getFaceDetector,
                              state.faceFound,
                              state.cameraLensDirection!,
                            );

                            if (result) {
                              Debounce.debounce(
                                kDebCamera,
                                const Duration(seconds: 1),
                                () async {
                                  context
                                      .read<GlobalCameraCubit>()
                                      .onCameraCaptured();
                                },
                              );
                            } else {
                              Fluttertoast.showToast(msg: kFaceNotDetected);
                            }
                          } else {
                            log.i('Camera not Ready');
                          }
                        },
                        onFlashMode: widget.cameraLensDirection!.isBack
                            ? () {
                                if (mounted) {
                                  context
                                      .read<GlobalCameraCubit>()
                                      .setFlashMode(
                                        AppUtility.flashMode(state.flashMode!),
                                      );
                                }
                              }
                            : null,
                        onPickerImage: state.cameraState.isNotAvailable
                            ? () {
                                Debounce.debounce(
                                  kDebCamera,
                                  const Duration(seconds: 1),
                                  () async {
                                    context
                                        .read<GlobalCameraCubit>()
                                        .onCameraPicker();
                                  },
                                );
                              }
                            : null,
                      ),
                    ],
                  ),
                ),

                //! Arrow Back
                Align(
                  alignment: Alignment.topLeft,
                  child: SafeArea(
                    child: ButtonAddAppBar(
                      isDark: true,
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.white,
                      ),
                      onTap: () => context.router.pop<XFile?>(null),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _cameraPreview(BuildContext context, GlobalCameraState state) {
    if (state.cameraState.isLoading || state.cameraState.isReady) {
      return Stack(
        alignment: AlignmentDirectional.center,
        fit: StackFit.expand,
        children: [
          FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: context
                  .read<GlobalCameraCubit>()
                  .getController()!
                  .value
                  .aspectRatio,
              height: 1.0,
              child: CameraPreview(
                context.read<GlobalCameraCubit>().getController()!,
                child: state.customPaint,
              ),
            ),
          ),
          //! Zoom Slider
          if (state.cameraLensDirection == CameraLensDirection.back)
            Positioned(
              bottom: AppDimens.size4S,
              left: 0,
              right: AppDimens.sizeM,
              child: Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: state.currentZoomLevel,
                      min: 0,
                      max: state.maxZoomLevel,
                      activeColor: AppColors.white,
                      inactiveColor: AppColors.white.withValues(alpha: 0.35),
                      onChanged: (value) async {
                        context.read<GlobalCameraCubit>().onChangeZoom(value);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: AppDimens.paddingSmall,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.labelPrimary,
                        borderRadius: BorderRadius.circular(
                          AppDimens.radiusMedium,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(AppDimens.paddingSmallX),
                        child: Text(
                          '${state.currentZoomLevel.toStringAsFixed(1)}x',
                          style: const TextStyle(color: AppColors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      );
    } else if (state.cameraState.isSuccess) {
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(
          state.cameraLensDirection!.isFront ? math.pi : 0,
        ),
        child: Image.file(File(state.data!.path), fit: BoxFit.cover),
      );
    } else if (state.cameraState.isFailure ||
        state.cameraState.isNotAvailable) {
      return Center(
        child: Text(
          state.message!,
          style: context.textStyle.bodyMedium!.copyWith(color: AppColors.white),
        ),
      );
    } else {
      return const Center(
        child: SpinKitCircle(color: AppColors.white, size: AppDimens.size4XL),
      );
    }
  }
}
