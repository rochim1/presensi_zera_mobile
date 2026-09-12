/// condition of authentication
enum AuthState { initial, loading, loggedIn, notLoggedIn }

/// condition of load data
enum TypeState { initial, loading, loaded, notLoaded }

/// condition of camera
enum CameraState { initial, ready, loading, success, failure, notAvailable }

/// state of dialog
enum AnswerState { cancel, yesOk, third }

/// for class [ChipWidget] params
enum ChipType { light, normal }

/// for class [FailureViewWidget] params
enum EmptyState {
  lostConnection,
  emptyList,
  somethingWrong,
  successfully,
  confirmation,
}

/// is state of edit/delete avatar profile
enum AvatarAnswerState { camera, gallery, delete }

/// attachment type for class [TextFieldAttachment]
enum AttachmentType { cameraFront, cameraBack, document }

/// type for delivery status for class [DestinationCardWidget]
enum StatusTask { pending, done, cancel }

/// For Role account
enum DivisiType {
  marketing,
  courier,
  operationalManager,
  werehouseStaff,
  apjAlkes,
  apoteker,
  adminStaff,
  onlineStaff,
  director,
  itStaff,
  taxStaff,
  galat,
}

/// gender type
enum GenderType { m, f }

enum StatusIzinType { diterima, ditolak, diajukan }

enum TypeCuti { izinCutiTahunan, izinSakit, izinUrusanKeluarga, lainnya }

enum JenisKendaraan { mobil, motor, trukEkspedisi }

enum JenisPembatalan { wrongSelected, other }

enum NotificationType {
  notifikasiJamMasuk,
  notifikasiJamPulang,
  notifikasiJamIstirahat,
  notifikasiCutiDiajukan,
  notifikasiCutiDiterima,
  notifikasiCutiDitolak,
  notifikasiTaskFromAdmin,
  notifikasiTaskDoneToday,
  notifikasiTaskCancelToday,
  tasks,
  inventarisService,
  inventarisPajak,
  inventaris,
  other,
}

enum NotificationState { onMessage, onMessageOpenedApp, other }

enum ActiveType { active, deleted }

enum ItemTypeProfile { general, language, text }

enum RequestPresensiType {
  lupaPresensiMasuk,
  lupaPresensiPulang,
  lupaMasuk,
  lupaMasukDanPulang,
  koreksiMasuk,
  koreksiPulang,
  koreksiMasukDanPulang,
  koreksiWaktuIstirahat,
  dinasLuar,
  wfh,
}

enum RequestPresensiStatus { pending, approved, rejected, cancelled }
