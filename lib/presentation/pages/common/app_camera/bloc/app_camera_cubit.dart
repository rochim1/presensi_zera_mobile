import 'dart:io';
import 'dart:ui' show Size;
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:presensi_mobile/service/camera_access.dart';
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
  bool _isInitializing = false;
  bool _isClosing = false;
  int _cameraGeneration = 0;

  bool get isBusy => _isTakingPicture || _isInitializing || _isClosing;

  @override
  void emit(AppCameraState state) {
    if (!_isClosing && !isClosed) super.emit(state);
  }

  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(enableContours: true, enableLandmarks: false),
  );

  CameraController? get controller => _controller;

  Future<void> initialize({
    required AppCameraType type,
    CameraLensDirection? lensDirection,
  }) async {
    if (isBusy || isClosed) return;
    _isInitializing = true;
    _cameraGeneration++;
    try {
      final direction = lensDirection ?? type.initialDirection;
      emit(
        state.copyWith(
          status: AppCameraStatus.loading,
          type: type,
          lensDirection: direction,
          enabledFaceDetection: !kIsWeb && type.enabledFaceDetection,
          capturedFile: null,
          isFaceDetected: false,
          isBusyDetector: false,
          errorMessage: null,
        ),
      );

      await _controller?.dispose();
      _controller = null;
      _isImageStreamRunning = false;
      final environmentError = cameraEnvironmentError();
      if (environmentError != null) {
        emit(
          state.copyWith(
            status: AppCameraStatus.failure,
            errorMessage: environmentError,
          ),
        );
        return;
      }
      final granted = await requestNativeCameraAccess();
      if (_isClosing) return;
      if (!granted) {
        emit(
          state.copyWith(
            status: AppCameraStatus.failure,
            errorMessage: PERMISSION_CAMERA_DENIED,
          ),
        );
        return;
      }

      final cameras = await availableCameras();
      if (_isClosing) return;
      if (cameras.isEmpty) {
        emit(
          state.copyWith(
            status: AppCameraStatus.failure,
            errorMessage: 'Kamera tidak ditemukan pada perangkat ini.',
          ),
        );
        return;
      }
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
      if (_isClosing) return;

      // camera_web does not guarantee zoom support. Querying its zoom range
      // can itself throw zoomLevelNotSupported on desktop browsers.
      var zoomMin = 1.0;
      var zoomMax = 1.0;
      if (!kIsWeb) {
        zoomMin = await _controller?.getMinZoomLevel() ?? 1.0;
        zoomMax = await _controller?.getMaxZoomLevel() ?? 1.0;
      }

      // Start image stream for face detection if enabled for this type and current lens is front
      if (!kIsWeb &&
          type.enabledFaceDetection &&
          direction == CameraLensDirection.front) {
        await _controller!.startImageStream(
          (image) => _processCameraImage(image, camera),
        );
        _isImageStreamRunning = true;
      }
      if (_isClosing) return;
      emit(
        state.copyWith(
          status: AppCameraStatus.ready,
          minZoomLevel: zoomMin,
          maxZoomLevel: zoomMax,
          currentZoomLevel: zoomMin,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AppCameraStatus.failure,
          errorMessage: cameraAccessError(e),
        ),
      );
    } finally {
      _isInitializing = false;
    }
  }

  Future<void> switchCamera() async {
    final newDirection = state.lensDirection == CameraLensDirection.front
        ? CameraLensDirection.back
        : CameraLensDirection.front;

    if (isBusy || isClosed) return;
    await initialize(type: state.type, lensDirection: newDirection);
  }

  Future<void> takePicture() async {
    if (isBusy ||
        isClosed ||
        state.capturedFile != null ||
        _controller == null ||
        !_controller!.value.isInitialized) {
      return;
    }

    _isTakingPicture = true;
    emit(state.copyWith(status: AppCameraStatus.capturing));
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
          errorMessage: cameraAccessError(e),
        ),
      );
    } finally {
      _isTakingPicture = false;
    }
  }

  Future<void> retake() async {
    if (isBusy || isClosed) return;
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
    if (state.isBusyDetector || isBusy || isClosed) return;
    final generation = _cameraGeneration;
    emit(state.copyWith(isBusyDetector: true));
    try {
      final faces = await _faceDetector.processImage(inputImage);
      if (_isClosing || isClosed || generation != _cameraGeneration) return;
      final isFaceDetected = faces.isNotEmpty;
      if (isFaceDetected &&
          !isBusy &&
          state.type.enabledFaceDetection &&
          state.lensDirection == CameraLensDirection.front &&
          _isImageStreamRunning) {
        try {
          await _controller?.stopImageStream();
          _isImageStreamRunning = false;
        } catch (_) {}
      }
      if (generation == _cameraGeneration) {
        emit(state.copyWith(isFaceDetected: isFaceDetected));
      }
    } catch (_) {
      // A disposed detector or failed frame must not escape as an async error.
    } finally {
      if (generation == _cameraGeneration) {
        emit(state.copyWith(isBusyDetector: false));
      }
    }
  }

  @override
  Future<void> close() async {
    _isClosing = true;
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
