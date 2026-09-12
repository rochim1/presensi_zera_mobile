import 'dart:io';
import 'dart:ui' show Size;
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/service/web_face_detection_stub.dart'
    if (dart.library.html) 'package:presensi_mobile/service/web_face_detection_web.dart';
import '../models/app_camera_type.dart' show AppCameraType;
import 'app_camera_state.dart';

class AppCameraCubit extends Cubit<AppCameraState> {
  AppCameraCubit() : super(const AppCameraState());

  CameraController? _controller;
  bool _isImageStreamRunning = false;
  bool _isTakingPicture = false;
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(enableContours: true, enableLandmarks: false),
  );

  CameraController? get controller => _controller;

  Future<void> initialize({
    required AppCameraType type,
    CameraLensDirection? lensDirection,
  }) async {
    try {
      final direction = lensDirection ?? type.initialDirection;
      emit(
        state.copyWith(
          status: AppCameraStatus.loading,
          type: type,
          lensDirection: direction,
          enabledFaceDetection: !kIsWeb && type.enabledFaceDetection,
        ),
      );

      final status = await Permission.camera.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        emit(
          state.copyWith(
            status: AppCameraStatus.failure,
            errorMessage: PERMISSION_CAMERA_DENIED,
          ),
        );
        return;
      }

      final cameras = await availableCameras();
      final camera = cameras.firstWhere(
        (c) => c.lensDirection == direction,
        orElse: () => cameras.first,
      );

      _controller = CameraController(
        camera,
        type.resolutionPreset,
        enableAudio: false,
        imageFormatGroup: direction == CameraLensDirection.front
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.jpeg,
      );

      await _controller!.initialize();

      // camera_web does not guarantee zoom support. Querying its zoom range
      // can itself throw zoomLevelNotSupported on desktop browsers.
      var zoomMin = 1.0;
      var zoomMax = 1.0;
      if (!kIsWeb) {
        zoomMin = await _controller?.getMinZoomLevel() ?? 1.0;
        zoomMax = await _controller?.getMaxZoomLevel() ?? 1.0;
      }

      emit(
        state.copyWith(
          status: AppCameraStatus.ready,
          minZoomLevel: zoomMin,
          maxZoomLevel: zoomMax,
          currentZoomLevel: zoomMin,
        ),
      );

      // Start image stream for face detection if enabled for this type and current lens is front
      if (!kIsWeb &&
          type.enabledFaceDetection &&
          direction == CameraLensDirection.front) {
        await _controller!.startImageStream(
          (image) => _processCameraImage(image, camera),
        );
        _isImageStreamRunning = true;
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: AppCameraStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> switchCamera() async {
    final newDirection = state.lensDirection == CameraLensDirection.front
        ? CameraLensDirection.back
        : CameraLensDirection.front;

    await _controller?.dispose();
    _controller = null;
    await initialize(type: state.type, lensDirection: newDirection);
  }

  Future<void> takePicture() async {
    if (_isTakingPicture ||
        _controller == null ||
        !_controller!.value.isInitialized) {
      return;
    }

    _isTakingPicture = true;
    try {
      if (state.lensDirection == CameraLensDirection.front &&
          state.enabledFaceDetection &&
          _isImageStreamRunning) {
        try {
          await _controller!.stopImageStream();
          _isImageStreamRunning = false;
        } catch (_) {}
      }

      final file = await _controller!.takePicture();

      if (kIsWeb && state.type.enabledFaceDetection) {
        final detection = await WebFaceDetectionService.detect(file);
        if (!detection.available) {
          emit(
            state.copyWith(
              status: AppCameraStatus.failure,
              errorMessage:
                  'Deteksi wajah Web belum siap. Periksa koneksi lalu coba lagi.',
            ),
          );
          return;
        }
        if (detection.faceCount == 0) {
          emit(
            state.copyWith(
              status: AppCameraStatus.failure,
              errorMessage:
                  'Wajah tidak terdeteksi. Pastikan wajah terlihat jelas dan pencahayaan cukup.',
            ),
          );
          return;
        }
        if (detection.faceCount > 1) {
          emit(
            state.copyWith(
              status: AppCameraStatus.failure,
              errorMessage: 'Pastikan hanya satu wajah berada di dalam kamera.',
            ),
          );
          return;
        }
      }

      emit(state.copyWith(status: AppCameraStatus.success, capturedFile: file));
    } catch (e) {
      emit(
        state.copyWith(
          status: AppCameraStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    } finally {
      _isTakingPicture = false;
    }
  }

  Future<void> retake() async {
    await _controller?.dispose();
    _controller = null;
    _isImageStreamRunning = false;
    _isTakingPicture = false;
    emit(state.copyWith(status: AppCameraStatus.initial, capturedFile: null));
    await initialize(type: state.type, lensDirection: state.lensDirection);
  }

  void _processCameraImage(CameraImage image, CameraDescription camera) {
    final inputImage = _inputImageFromCameraImage(image, camera);
    if (inputImage == null) return;

    _processFaceDetector(inputImage);
  }

  InputImage? _inputImageFromCameraImage(
    CameraImage image,
    CameraDescription camera,
  ) {
    if (_controller == null) return null;

    final sensorOrientation = camera.sensorOrientation;
    InputImageRotation? rotation;

    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
          AppUtility.orientationsDevice[_controller?.value.deviceOrientation];
      if (rotationCompensation == null) return null;

      rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }

    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw);

    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) {
      return null;
    }

    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    try {
      return InputImage.fromBytes(
        bytes: plane.bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: rotation,
          format: format,
          bytesPerRow: plane.bytesPerRow,
        ),
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> _processFaceDetector(InputImage inputImage) async {
    if (state.isBusyDetector) return;

    emit(state.copyWith(isBusyDetector: true));
    final faces = await _faceDetector.processImage(inputImage);
    final isFaceDetected = faces.isNotEmpty;

    if (isFaceDetected &&
        state.type.enabledFaceDetection &&
        state.lensDirection == CameraLensDirection.front &&
        _isImageStreamRunning) {
      try {
        await _controller?.stopImageStream();
        _isImageStreamRunning = false;
      } catch (_) {}
    }

    emit(state.copyWith(isFaceDetected: isFaceDetected, isBusyDetector: false));
  }

  @override
  Future<void> close() async {
    try {
      if (state.lensDirection == CameraLensDirection.front &&
          state.enabledFaceDetection &&
          _isImageStreamRunning) {
        await _controller?.stopImageStream();
        _isImageStreamRunning = false;
      }
    } catch (_) {}

    try {
      await _controller?.dispose();
    } catch (_) {}

    try {
      await _faceDetector.close();
    } catch (_) {}
    return super.close();
  }
}
