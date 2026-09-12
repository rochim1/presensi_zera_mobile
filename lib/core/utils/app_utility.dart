import 'dart:convert';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
// import 'package:device_info_plus/device_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

typedef OnLoginResultCallback =
    void Function(bool? value, LoginUserEntity? user);

class AppUtility {
  AppUtility._();

  /// handle nullabel "default Empty"
  /// e.g :
  /// ```
  /// val x = AppUtility.nullHandler(
  ///   stateData.data?.user?.gender,
  ///   fallback: state.data?.user?.gender,
  /// );
  /// ```
  static dynamic nullHandler(dynamic value, {dynamic fallback = ''}) {
    return value ?? fallback ?? '';
  }

  /// local default
  static Locale get locale => const Locale('id', 'ID');

  /// Resolve backend URL path, removing /graphql from base api
  static String resolveBackendUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    if (path.startsWith('//')) return 'https:$path';

    final flavorConfig = sl<FlavorConfig>();
    final baseUrl = flavorConfig.baseApi ?? flavorConfig.values?.baseApi ?? '';
    final serverUrl = baseUrl.replaceAll(RegExp(r'/graphql/?$'), '');

    final cleanServer = serverUrl.endsWith('/')
        ? serverUrl.substring(0, serverUrl.length - 1)
        : serverUrl;
    final cleanPath = path.startsWith('/') ? path : '/$path';

    return '$cleanServer$cleanPath';
  }

  /// launcher link to webview
  static void launchLink(String? url) async {
    if (url == null || url.isEmpty) return;

    final urlParse = Uri.parse(url);

    if (!await launchUrl(urlParse, mode: LaunchMode.inAppWebView)) {
      log.e('Could not launch $urlParse');
    }
  }

  /// isBottom for Infinity Scroll with `ScrollController`
  static bool isBottomInfinity(ScrollController controller) {
    final maxScroll = controller.position.maxScrollExtent;
    final currentScroll = controller.offset;

    if (!controller.hasClients) return false;
    return currentScroll == maxScroll;
  }

  /// isBottom for Infinity Scroll with
  static bool isBottomNotif(ScrollEndNotification scroll) {
    final maxScroll = scroll.metrics.maxScrollExtent;
    final currentScroll = scroll.metrics.pixels;

    if (!scroll.metrics.hasPixels) return false;
    return currentScroll == maxScroll;
  }

  /// handle empty state, and return svg image
  static String handleEmptyState(EmptyState state) {
    if (state.isConfirmation) {
      return AppImages.confirmSvg;
    } else if (state.isEmptyList) {
      return AppImages.emptyListSvg;
    } else if (state.isLostConnection) {
      return AppImages.lostConnectionSvg;
    } else if (state.isSuccessfuly) {
      return AppImages.successfullySvg;
    } else {
      return AppImages.somethingWrongSvg;
    }
  }

  /// pic of Image from Gallery or Camera, then crop this Image
  static Future<XFile> pickerImage(ImageSource source) async {
    XFile? result = await ImagePicker().pickImage(source: source);
    CroppedFile? file;
    if (result != null) {
      // Crop image avatar
      file = await ImageCropper().cropImage(
        sourcePath: result.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Potong Gambar',
            toolbarColor: AppColors.primary,
            toolbarWidgetColor: AppColors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(minimumAspectRatio: 1.0),
        ],
      );
    }
    if (file == null) {
      throw const ProsessFailure(message: FAILURE_IMAGE_FILE);
    }
    return result!;
  }

  /// get file document into file manager (support for Android and Ios)
  static Future<List<PlatformFile>> fileAttachment([
    bool multiple = false,
    List<String>? extensions,
    FileType? type,
  ]) async {
    // final deviceInfo = await sl<DeviceInfoPlugin>().androidInfo;
    // final sdkVersion = deviceInfo.version.sdkInt;

    // if (sdkVersion >= 29) {
    //   if (await Permission.manageExternalStorage.request().isGranted) {
    //     return _pick(multiple, extensions, type);
    //   } else {
    //     throw const ProsessFailure(message: PERMISSION_STORAGE_DENIED);
    //   }
    // } else {
    //   if (await Permission.storage.request().isGranted) {
    return _pick(multiple, extensions, type);
    // } else {
    //   throw const ProsessFailure(message: PERMISSION_STORAGE_DENIED);
    // }
    // }
  }

  // get file document into file manager (support for Android and Ios)
  static Future<List<PlatformFile>> _pick(
    bool multiple,
    List<String>? extensions,
    FileType? type,
  ) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: multiple,
      allowedExtensions: extensions,
      type: type ?? FileType.any,
      withData: true,
    );

    if (result != null) {
      List<PlatformFile> pickedFiles = result.files.map((files) {
        return files;
      }).toList();

      return pickedFiles;
    } else {
      throw const ProsessFailure(message: FAILURE_UPLOAD_FILE);
    }
  }

  /// to Change camera lens Directory from package camera
  static CameraLensDirection cameraLens(CameraLensDirection lensDirection) {
    if (lensDirection.isBack) {
      return CameraLensDirection.front;
    } else {
      return CameraLensDirection.front;
    }
  }

  /// flash mode from  package camera
  static FlashMode flashMode(FlashMode flashMode) {
    if (flashMode.isAlways) {
      return FlashMode.off;
    } else {
      return FlashMode.always;
    }
  }

  /// maping address from [Placemark]
  static GlobalAddressEntity mapAddreass(List<Placemark> placemark) {
    final Placemark place = placemark.first;

    return GlobalAddressEntity(
      name: place.name,
      streetAddress: (place.thoroughfare?.isNotEmpty ?? false)
          ? place.thoroughfare!
          : place.street,
      subDistrict: place.subLocality,
      district: place.locality,
      regency: place.subAdministrativeArea,
      province: place.administrativeArea,
      country: place.country,
      postal: place.postalCode,
    );
  }

  /// data of month picker
  static List<String> get listMonth {
    return [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
  }

  static List<String> get listExtensions => [
    'pdf',
    'png',
    'jpg',
    'jpeg',
    'docx',
  ];

  static List<TypeCuti> get listTypeCuti {
    return [
      TypeCuti.izinCutiTahunan,
      TypeCuti.izinSakit,
      TypeCuti.izinUrusanKeluarga,
      TypeCuti.lainnya,
    ];
  }

  /// locale indonesia
  static Locale localeId() => const Locale('id', 'ID');

  /// base64 decode to stream
  static Uint8List fromBase64StringFile(String base64String) =>
      base64Decode(base64String.split(',').last);

  static Uint8List fromBase64String(String base64String) {
    final UriData? uri = Uri.parse(base64String).data;

    return uri?.contentAsBytes() ?? Uint8List(0);
  }

  /// stream to base64
  static String toBase64(Uint8List data) => base64Encode(data);

  /// path convert to byte
  /// this util for class [GlobalParamsImageEntity()]
  static MultipartFile? toMultipartFile(String? path) {
    if (path == null) return null;
    final fileName = path.split('/').last;
    final byteData = File(path).readAsBytesSync();
    return MultipartFile.fromBytes('file', byteData, filename: fileName);
  }

  /// Converts a picked document without relying solely on a filesystem path.
  /// Android document providers may return bytes with a null path.
  static MultipartFile toPickedMultipartFile(PlatformFile file) {
    final bytes =
        file.bytes ??
        ((file.path?.isNotEmpty ?? false) && File(file.path!).existsSync()
            ? File(file.path!).readAsBytesSync()
            : null);
    if (bytes == null || bytes.isEmpty) {
      throw const ProsessFailure(
        message: 'Dokumen tidak dapat dibaca. Silakan pilih ulang file.',
      );
    }
    return MultipartFile.fromBytes('file', bytes, filename: file.name);
  }

  static Future<PlatformFile?> toPlatformFile(
    String? base64String,
    String? fileName,
  ) async {
    if (base64String == null || fileName == null) return null;
    final bytes = fromBase64StringFile(base64String);
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(bytes);
    return PlatformFile(
      path: file.path,
      name: fileName,
      size: bytes.lengthInBytes,
      bytes: bytes,
    );
  }

  /// check condition is ready to break In
  static bool toBreakIn(PresensiEntity? data) {
    if (data == null) return false;

    //! jika status kerja itu "kerja" dan [join_work] itu false
    return (data.statusKerja?.toStatusKerja?.isKerja ?? false);
  }

  /// check condition is ready to break Out
  static bool toBreakOut(PresensiEntity? data) {
    if (data == null) return false;

    //! jika status kerja itu "isirahat" dan [join_work] itu false
    return (data.statusKerja?.toStatusKerja?.isIstirahat ?? false);
  }

  /// check condition is all task done to handle check out
  static bool toCheckOut(PresensiEntity? data, DivisiType? divisi) {
    if (data == null) return false;

    bool isKerjaCondition =
        (data.statusKerja?.toStatusKerja?.isKerja ?? false) &&
        (data.isAllTasksDone ?? false);

    //! Jika ada tugas hari ini
    if ((data.hasTaskToday ?? false)) {
      return isKerjaCondition;
    } else {
      return true;
    }
  }

  /// to handling has value null into list file
  static List<GlobalImageParamsEntity> fotoValueCondition(
    List<XFile>? prim,
    List<XFile>? secc,
  ) {
    final lst = <GlobalImageParamsEntity>[];

    if (prim != null && prim.isNotEmpty) {
      final newPrim = prim.where((element) => element.path.isNotEmpty);
      lst.addAll(
        newPrim.map(
          (e) => GlobalImageParamsEntity(
            file: toMultipartFile(e.path),
            path: e.path,
            name: e.name,
          ),
        ),
      );
    }

    if (secc != null && secc.isNotEmpty) {
      final newSecc = secc.where((element) => element.path.isNotEmpty);
      lst.addAll(
        newSecc.map(
          (e) => GlobalImageParamsEntity(
            file: toMultipartFile(e.path),
            path: e.path,
            name: e.name,
          ),
        ),
      );
    }

    return lst;
  }

  static bool onCapture(
    bool featureFace,
    bool faceFound,
    CameraLensDirection cameraLensDirection,
  ) {
    return !featureFace ||
        (featureFace && faceFound) ||
        (featureFace && cameraLensDirection == CameraLensDirection.back);
  }

  /// to handling has value null into list indexing
  static List<int> fotoIndexCondition(List<XFile>? prim, List<XFile>? secc) {
    final count = <int>[];
    if (prim != null && prim.isNotEmpty) {
      final newPrim = prim.where((element) => element.path.isNotEmpty);
      count.add(newPrim.length);
    }
    if (secc != null && secc.isNotEmpty) {
      final newSecc = secc.where((element) => element.path.isNotEmpty);
      count.add(newSecc.length);
    }

    return count;
  }

  static String? getTransportasi(InventarisEntity? inv) {
    if (inv == null) return null;

    final jenis = inv.jenisKendaraan?.toJenisKendaraan?.toName ?? '-';
    final merk = inv.merk ?? '-';
    final plat = inv.platNomer ?? '-';

    if (jenis == '-' && merk == '-' && plat == '-') return null;

    return '$jenis - $merk ($plat)';
  }

  static void routeNotification(
    BuildContext context,
    NotificationType? notificationType,
  ) {
    if ((notificationType?.isInventarisService ?? false) ||
        (notificationType?.isInventarisPajak ?? false)) {
      context.router.navigate(const ProfileInventoryPageRoute());
    } else if (notificationType?.isNotifikasiTaskDoneToday ?? false) {
      context.router.navigate(
        const MainPageRoute(
          children: [
            DeliveryPageRoute(children: [DeliverySuccessTabRoute()]),
          ],
        ),
      );
    } else if (notificationType?.isNotifikasiTaskCancelToday ?? false) {
      context.router.navigate(
        const MainPageRoute(
          children: [
            DeliveryPageRoute(children: [DeliveryCanceledTabRoute()]),
          ],
        ),
      );
    }
    return;
  }

  static Map<DeviceOrientation, int> orientationsDevice = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  static bool errorIgnore(String event) {
    final is404 = event.contains('NotFoundException');
    final isCache = event.contains('CacheException');
    final isNotFound = event.contains('NOT_FOUND');
    final isForbidden = event.contains('FORBIDDEN');
    final isBadrequest = event.contains('BAD_REQUEST');
    final isCamera = event.contains('CameraException');
    // handleing TextField on Samsung
    final isField = event.contains('EditableTextState');

    if (is404 ||
        isCache ||
        isNotFound ||
        isForbidden ||
        isBadrequest ||
        isCamera ||
        isField) {
      return false;
    }

    return true;
  }

  static NotificationType? stringToNotificationType(String? type) {
    try {
      return NotificationType.values.firstWhere(
        (e) => e.name.toLowerCase() == type?.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }
}
