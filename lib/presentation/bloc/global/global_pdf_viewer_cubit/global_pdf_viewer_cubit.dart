import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';

part 'global_pdf_viewer_state.dart';

class GlobalPdfViewerCubit extends Cubit<GlobalPdfViewerState> {
  final DeviceInfoPlugin deviceInfo;
  GlobalPdfViewerCubit(this.deviceInfo) : super(const GlobalPdfViewerState());

  void getPermissionStatus(String? fileIzin) async {
    // if (kIsWeb) return loadPdf(fileIzin);

    // final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    // final int sdkVersion = androidInfo.version.sdkInt;

    // if (sdkVersion >= 29) {
    //   await Permission.manageExternalStorage.request();
    //   var status = await Permission.manageExternalStorage.status;

    //   _getStatus(status, fileIzin);
    // } else {
    //   await Permission.storage.request();
    //   var status = await Permission.storage.status;

    //   _getStatus(status, fileIzin);
    // }
    _getStatus(fileIzin);
  }

  Future<void> _getStatus(String? fileIzin) async {
    // if (status.isGranted) {
    emit(state.copyWith(isStorageGranted: true, status: TypeState.loaded));
    loadPdf(fileIzin);
    // } else if (status.isPermanentlyDenied || status.isDenied) {
    // await openAppSettings();

    // emit(state.copyWith(
    //   status: TypeState.notLoaded,
    //   isStorageGranted: false,
    //   message: PERMISSION_STORAGE_DENIED,
    // ));
    // } else {
    //   emit(state.copyWith(
    //     status: TypeState.notLoaded,
    //     isStorageGranted: false,
    //     message: PERMISSION_STORAGE_DENIED,
    //   ));
    // }
  }

  void loadPdf(String? fileIzin) async {
    try {
      emit(state.copyWith(status: TypeState.loading));
      final data = AppUtility.fromBase64StringFile(fileIzin!);
      if (kIsWeb) {
        emit(state.copyWith(status: TypeState.loaded, uInt8: data));
        return;
      }
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/izin_kerja.pdf');
      await file.writeAsBytes(data);
      emit(state.copyWith(status: TypeState.loaded, file: file, uInt8: data));
    } catch (e) {
      log.e(e.toString());
      emit(
        state.copyWith(
          status: TypeState.notLoaded,
          message: FAILURE_FILE_UKNOWN,
        ),
      );
    }
  }

  void hasError(dynamic error) {
    log.e(error.toString());

    emit(
      state.copyWith(status: TypeState.notLoaded, message: FAILURE_FILE_UKNOWN),
    );
  }
}
