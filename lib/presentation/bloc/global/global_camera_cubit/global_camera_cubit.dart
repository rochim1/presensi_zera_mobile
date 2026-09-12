import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:camera/camera.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

part 'global_camera_state.dart';

class GlobalCameraCubit extends Cubit<GlobalCameraState> {
  GlobalCameraCubit()
    : super(
        GlobalCameraState(
          faceFound: false,
          faceDetector: FaceDetector(
            options: FaceDetectorOptions(
              enableContours: true,
              enableLandmarks: false,
            ),
          ),
        ),
      );

  CameraController? _controller;
  CameraController? getController() => _controller;
  bool get isInitialized => _controller?.value.isInitialized ?? false;

  void getPermissionStatus([CameraLensDirection? cameraLensDirection]) async {
    await Permission.camera.request();
    var status = await Permission.camera.status;

    if (status.isGranted) {
      onCameraInitial(cameraLensDirection);
      emit(state.copyWith(typeState: TypeState.loaded, isCameraGranted: true));
    } else {
      emit(
        state.copyWith(
          typeState: TypeState.notLoaded,
          isCameraGranted: false,
          message: PERMISSION_CAMERA_DENIED,
        ),
      );
    }
  }

  void onCameraInitial([CameraLensDirection? cameraLensDirection]) async {
    try {
      final cameras = await availableCameras();

      final camera = cameras.firstWhereOrNull(
        (camera) =>
            camera.lensDirection ==
            (cameraLensDirection ?? state.cameraLensDirection),
      );

      //! if camera not found or not available
      if (camera == null) {
        return emit(
          state.copyWith(
            cameraState: CameraState.notAvailable,
            message: kCameraNotFound,
          ),
        );
      }

      _controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: cameraLensDirection == CameraLensDirection.front
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.jpeg,
      );

      await _controller?.initialize();

      final zoomMin = await _controller?.getMinZoomLevel();
      final zoomMax = await _controller?.getMaxZoomLevel();

      emit(
        state.copyWith(
          cameraState:
              !kIsWeb && cameraLensDirection == CameraLensDirection.front
              ? rc.getFaceDetector
                    ? CameraState.initial
                    : CameraState.ready
              : CameraState.ready,
          cameraLensDirection: cameraLensDirection,
          minZoomLevel: zoomMin,
          maxZoomLevel: zoomMax,
        ),
      );

      //! ML face detector only work on CameraLensDirection.front
      if (!kIsWeb &&
          rc.getFaceDetector &&
          cameraLensDirection == CameraLensDirection.front) {
        await _controller?.startImageStream((image) {
          return _processCameraImage(image, camera);
        });
      }
    } on CameraException catch (e, s) {
      log.w(e, stackTrace: s);

      emit(
        state.copyWith(
          typeState: TypeState.notLoaded,
          cameraState: CameraState.failure,
          message: e.description,
        ),
      );
    }
  }

  void onCameraCaptured() async {
    if (_controller == null) return;

    if (state.cameraState.isReady && isInitialized) {
      try {
        emit(state.copyWith(cameraState: CameraState.loading));
        await _controller?.lockCaptureOrientation(DeviceOrientation.portraitUp);
        await _controller?.setFocusMode(FocusMode.locked);
        await _controller?.setFlashMode(state.flashMode!);

        if (rc.getFaceDetector &&
            state.cameraLensDirection == CameraLensDirection.front) {
          try {
            await _controller?.stopImageStream();
          } catch (_) {}
          try {
            await state.faceDetector.close();
          } catch (_) {}
        }

        XFile file = await _controller!.takePicture();

        emit(
          state.copyWith(
            cameraState: CameraState.success,
            data: file,
            message: kSuccessCapture,
          ),
        );
      } on CameraException catch (e, s) {
        log.w(e, stackTrace: s);
        emit(
          state.copyWith(
            typeState: TypeState.notLoaded,
            cameraState: CameraState.failure,
            message: e.description,
          ),
        );
      }
    }
  }

  void setFlashMode(FlashMode flashMode) {
    emit(state.copyWith(flashMode: flashMode));
  }

  void onChangeZoom(double value) async {
    var currentZoomLevel =
        (value / state.maxZoomLevel) *
            (state.maxZoomLevel - state.minZoomLevel) +
        state.minZoomLevel;

    if (currentZoomLevel < 1.0) currentZoomLevel = 1.0;

    emit(state.copyWith(currentZoomLevel: currentZoomLevel));
    await _controller?.setZoomLevel(currentZoomLevel);
  }

  void onCameraPicker() async {
    try {
      final XFile file = await AppUtility.pickerImage(ImageSource.gallery);
      emit(
        state.copyWith(
          cameraState: CameraState.success,
          data: file,
          message: kSuccessCapture,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          cameraState: CameraState.failure,
          message: kFailedCapture,
        ),
      );
    }
  }

  void _processCameraImage(CameraImage image, CameraDescription camera) {
    final inputImage = _inputImageFromCameraImage(image, camera);
    if (inputImage == null) return;

    _processFaceDetector(inputImage);
  }

  /// initiation camera with face detector
  InputImage? _inputImageFromCameraImage(
    CameraImage image,
    CameraDescription camera,
  ) {
    if (_controller == null) {
      emit(
        state.copyWith(
          typeState: TypeState.notLoaded,
          cameraState: CameraState.failure,
          message: kWhenWrong,
        ),
      );
      return null;
    }

    final sensorOrientation = camera.sensorOrientation;
    InputImageRotation? rotation;

    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
          AppUtility.orientationsDevice[_controller?.value.deviceOrientation];
      if (rotationCompensation == null) return null;

      //! rotation Compensation for CameraLensDirection.front
      rotationCompensation = (sensorOrientation + rotationCompensation) % 360;

      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }

    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw);

    //! validate format depending on platform
    //! only supported formats:
    //! * nv21 for Android
    //! * bgra8888 for iOS
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) {
      return null;
    }

    // since format is constraint to nv21 or bgra8888, both only have one plane
    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    // compose InputImage using bytes
    try {
      return InputImage.fromBytes(
        bytes: plane.bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: rotation, // used only in Android
          format: format, // used only in iOS
          bytesPerRow: plane.bytesPerRow, // used only in iOS
        ),
      );
    } catch (e) {
      log.d(e);
      return null;
    }
  }

  Future<void> _processFaceDetector(InputImage inputImage) async {
    if (state.isBusyDetector) return;

    emit(state.copyWith(isBusyDetector: true));
    final faces = await state.faceDetector.processImage(inputImage);
    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = FaceDetectorPainter(
        faces,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        state.cameraLensDirection,
      );

      emit(
        state.copyWith(
          cameraState: CameraState.ready,
          customPaint: CustomPaint(painter: painter),
          faceFound: faces.isNotEmpty,
        ),
      );
    } else {
      emit(state.copyWith(customPaint: null));
    }
    emit(state.copyWith(isBusyDetector: false));
  }

  @override
  Future<void> close() async {
    if (rc.getFaceDetector &&
        state.cameraLensDirection == CameraLensDirection.front) {
      try {
        state.faceDetector.close();
      } catch (_) {}
      try {
        await _controller?.stopImageStream();
      } catch (_) {}
    }

    try {
      await _controller?.dispose();
    } catch (_) {}

    return super.close();
  }
}
