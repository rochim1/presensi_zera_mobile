import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/app_camera_type.dart';

part 'app_camera_state.freezed.dart';

enum AppCameraStatus { initial, loading, ready, success, failure }

@freezed
abstract class AppCameraState with _$AppCameraState {
  const factory AppCameraState({
    @Default(AppCameraStatus.initial) AppCameraStatus status,
    @Default(AppCameraType.selfie) AppCameraType type,
    @Default(CameraLensDirection.front) CameraLensDirection lensDirection,
    XFile? capturedFile,
    String? errorMessage,
    @Default(false) bool isFaceDetected,
    CustomPaint? customPaint,
    @Default(FlashMode.off) FlashMode flashMode,
    @Default(1.0) double currentZoomLevel,
    @Default(1.0) double maxZoomLevel,
    @Default(1.0) double minZoomLevel,
    @Default(false) bool isBusyDetector,
    @Default(true) bool enabledFaceDetection,
  }) = _AppCameraState;
}
