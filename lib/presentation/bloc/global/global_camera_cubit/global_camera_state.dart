part of 'global_camera_cubit.dart';

class GlobalCameraState extends Equatable {
  final bool isCameraGranted;
  final CameraLensDirection? cameraLensDirection;
  final TypeState typeState;
  final CameraState cameraState;
  final XFile? data;
  final String? message;
  final FlashMode? flashMode;
  final double minZoomLevel;
  final double maxZoomLevel;
  final double currentZoomLevel;
  final CustomPaint? customPaint;
  final FaceDetector faceDetector;
  final bool faceFound;
  final bool isBusyDetector;
  final CameraDescription? cameraDescription;

  const GlobalCameraState({
    this.isCameraGranted = false,
    this.cameraLensDirection = CameraLensDirection.back,
    this.typeState = TypeState.initial,
    this.cameraState = CameraState.initial,
    this.data,
    this.message,
    this.minZoomLevel = 0.0,
    this.maxZoomLevel = 1.0,
    this.currentZoomLevel = 0.0,
    this.flashMode = FlashMode.off,
    this.customPaint,
    required this.faceDetector,
    this.faceFound = false,
    this.isBusyDetector = false,
    this.cameraDescription,
  });

  @override
  List<Object?> get props {
    return [
      isCameraGranted,
      cameraLensDirection,
      typeState,
      cameraState,
      data,
      message,
      flashMode,
      minZoomLevel,
      maxZoomLevel,
      currentZoomLevel,
      customPaint,
      faceDetector,
      faceFound,
      isBusyDetector,
      cameraDescription,
    ];
  }

  GlobalCameraState copyWith({
    bool? isCameraGranted,
    CameraLensDirection? cameraLensDirection,
    TypeState? typeState,
    CameraState? cameraState,
    XFile? data,
    String? message,
    FlashMode? flashMode,
    double? minZoomLevel,
    double? maxZoomLevel,
    double? currentZoomLevel,
    CustomPaint? customPaint,
    FaceDetector? faceDetector,
    bool? faceFound,
    bool? isBusyDetector,
    CameraDescription? cameraDescription,
  }) {
    return GlobalCameraState(
      isCameraGranted: isCameraGranted ?? this.isCameraGranted,
      cameraLensDirection: cameraLensDirection ?? this.cameraLensDirection,
      typeState: typeState ?? this.typeState,
      cameraState: cameraState ?? this.cameraState,
      data: data ?? this.data,
      message: message ?? this.message,
      flashMode: flashMode ?? this.flashMode,
      minZoomLevel: minZoomLevel ?? this.minZoomLevel,
      maxZoomLevel: maxZoomLevel ?? this.maxZoomLevel,
      currentZoomLevel: currentZoomLevel ?? this.currentZoomLevel,
      customPaint: customPaint ?? this.customPaint,
      faceDetector: faceDetector ?? this.faceDetector,
      faceFound: faceFound ?? this.faceFound,
      isBusyDetector: isBusyDetector ?? this.isBusyDetector,
      cameraDescription: cameraDescription ?? this.cameraDescription,
    );
  }
}
