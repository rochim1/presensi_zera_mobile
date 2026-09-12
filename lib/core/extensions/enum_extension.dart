import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

extension EnvType on Env {
  bool get isDev => this == Env.DEVELOPMENT;

  bool get isProd => this == Env.PRODUCTION;

  bool get isStag => this == Env.STAGING;
}

extension TypeStateEnum on TypeState {
  bool get isInitial => this == TypeState.initial;

  bool get isLoading => this == TypeState.loading;

  bool get isLoaded => this == TypeState.loaded;

  bool get isNotLoaded => this == TypeState.notLoaded;
}

extension AuthStateEnum on AuthState {
  bool get isLoading => this == AuthState.loading;

  bool get isLoggedIn => this == AuthState.loggedIn;

  bool get isNotLoggedIn => this == AuthState.notLoggedIn;
}

extension AnswerStateEnum on AnswerState {
  bool get isCancel => this == AnswerState.cancel;

  bool get isYesOk => this == AnswerState.yesOk;

  bool get isThird => this == AnswerState.third;
}

extension ChipTypeEnum on ChipType {
  bool get isNormal => this == ChipType.normal;

  bool get isLight => this == ChipType.light;
}

extension EmptyStateEnum on EmptyState {
  bool get isSuccessfuly => this == EmptyState.successfully;

  bool get isLostConnection => this == EmptyState.lostConnection;

  bool get isEmptyList => this == EmptyState.emptyList;

  bool get isSomethingWrong => this == EmptyState.somethingWrong;

  bool get isConfirmation => this == EmptyState.confirmation;
}

extension AvatarAnswerStateEnum on AvatarAnswerState {
  bool get isCamera => this == AvatarAnswerState.camera;

  bool get isGallery => this == AvatarAnswerState.gallery;

  bool get isDelete => this == AvatarAnswerState.delete;
}

extension AttachmentTypeEnum on AttachmentType {
  bool get isCameraFront => this == AttachmentType.cameraFront;

  bool get isCameraBack => this == AttachmentType.cameraBack;

  bool get isDocument => this == AttachmentType.document;
}

extension CameraStateEnum on CameraState {
  bool get isInitial => this == CameraState.initial;

  bool get isReady => this == CameraState.ready;

  bool get isLoading => this == CameraState.loading;

  bool get isSuccess => this == CameraState.success;

  bool get isFailure => this == CameraState.failure;

  bool get isNotAvailable => this == CameraState.notAvailable;
}

extension CameraLensDirectionEnum on CameraLensDirection {
  bool get isBack => this == CameraLensDirection.back;

  bool get isFront => this == CameraLensDirection.front;

  bool get isExternal => this == CameraLensDirection.external;
}

extension FlashModeEnum on FlashMode {
  bool get isAuto => this == FlashMode.auto;

  bool get isOff => this == FlashMode.off;

  bool get isAlways => this == FlashMode.always;

  bool get isTorch => this == FlashMode.torch;
}

extension StatusTaskEnum on StatusTask {
  bool get isPending => this == StatusTask.pending;

  bool get isDone => this == StatusTask.done;

  bool get isCanceled => this == StatusTask.cancel;

  String get toKey {
    if (isDone) {
      return 'done';
    } else if (isPending) {
      return 'pending';
    } else {
      return 'cancel';
    }
  }

  /// return of name enum
  String get toName {
    switch (this) {
      case StatusTask.done:
        return 'Selesai';
      case StatusTask.pending:
        return 'Diproses';
      default:
        return 'Dibatalkan';
    }
  }

  /// return color by this type
  Color get toColor {
    switch (this) {
      case StatusTask.done:
        return AppColors.green;
      case StatusTask.pending:
        return AppColors.orange;
      default:
        return AppColors.red;
    }
  }
}

extension DivisiTypeEnum on DivisiType {
  bool get isMarketing => this == DivisiType.marketing;

  bool get isCourier => this == DivisiType.courier;

  bool get isOperationalManager => this == DivisiType.operationalManager;

  bool get isWerehouseStaff => this == DivisiType.werehouseStaff;

  bool get isApjAlkes => this == DivisiType.apjAlkes;

  bool get isApoteker => this == DivisiType.apoteker;

  bool get isAdminStaff => this == DivisiType.adminStaff;

  bool get isOnlineStaff => this == DivisiType.onlineStaff;

  bool get isDirector => this == DivisiType.director;

  bool get isItStaff => this == DivisiType.itStaff;

  bool get isTaxStaff => this == DivisiType.taxStaff;
}

extension GenderTypeEnum on GenderType {
  bool get isAuto => this == GenderType.f;

  bool get isOff => this == GenderType.m;
}

extension StatusKerjaEnum on StatusKerja {
  bool get isIstirahat => this == StatusKerja.istirahat;

  bool get isKerja => this == StatusKerja.kerja;

  bool get isPulang => this == StatusKerja.pulang;

  bool get isMulaiKerja => this == StatusKerja.mulaiKerja;

  /// return of name enum
  String toName() {
    if (this == StatusKerja.pulang) {
      return 'Pulang';
    } else if (this == StatusKerja.istirahat) {
      return 'Istirahat';
    } else if (this == StatusKerja.mulaiKerja) {
      return 'Mulai Kerja';
    } else if (this == StatusKerja.kerja) {
      return 'Masuk Kerja';
    } else {
      return 'Galat';
    }
  }

  DateTime? toDateByStatusKerja(PresensiFormatWaktuEntity? format) {
    if (this == StatusKerja.pulang) {
      return format?.jamPulangKerja?.toDateTime;
    } else if (this == StatusKerja.istirahat) {
      return format?.jamIstirahatKerja?.toDateTime;
    } else if (this == StatusKerja.mulaiKerja) {
      return format?.jamKembaliKerja?.toDateTime;
    } else if (this == StatusKerja.kerja) {
      return format?.jamMasukKerja?.toDateTime;
    } else {
      return null;
    }
  }
}

extension StatusIzinTypeEnum on StatusIzinType {
  bool get isDiterima => this == StatusIzinType.diterima;

  bool get isDitolak => this == StatusIzinType.ditolak;

  bool get isDiajukan => this == StatusIzinType.diajukan;

  String? get toName {
    if (isDiajukan) {
      return 'Diajukan';
    } else if (isDiterima) {
      return 'Diterima';
    } else {
      return 'Ditolak';
    }
  }

  Color get toColor {
    if (isDiajukan) {
      return AppColors.orange;
    } else if (isDiterima) {
      return AppColors.green;
    } else {
      return AppColors.red;
    }
  }
}

extension TypeCutiEnum on TypeCuti {
  bool get isCutiTahunan => this == TypeCuti.izinCutiTahunan;

  bool get isSakit => this == TypeCuti.izinSakit;

  bool get isUrusanKeluarga => this == TypeCuti.izinUrusanKeluarga;

  bool get isLainnya => this == TypeCuti.lainnya;

  String? get toKey {
    if (isSakit) {
      return 'izin_sakit';
    } else if (isCutiTahunan) {
      return 'izin_cuti_tahunan';
    } else if (isUrusanKeluarga) {
      return 'izin_urusan_keluarga';
    } else {
      return 'lainnya';
    }
  }

  String? get toName {
    if (isSakit) {
      return 'Izin Sakit';
    } else if (isCutiTahunan) {
      return 'Izin Cuti Tahunan';
    } else if (isUrusanKeluarga) {
      return 'Izin Urusan Keluarga';
    } else {
      return 'Lainnya';
    }
  }
}

extension JenisKendaraanEnum on JenisKendaraan {
  bool get isMotor => this == JenisKendaraan.motor;

  bool get isMobil => this == JenisKendaraan.mobil;

  bool get isTrukEkspedisi => this == JenisKendaraan.trukEkspedisi;

  String? get toKey {
    if (isMotor) {
      return 'motor';
    } else if (isMobil) {
      return 'mobil';
    } else {
      return 'truk_ekspedisi';
    }
  }

  String? get toName {
    if (isMobil) {
      return 'Mobil';
    } else if (isMotor) {
      return 'Motor';
    } else if (isTrukEkspedisi) {
      return 'Truk Ekspedisi';
    } else {
      return 'Lainnya';
    }
  }
}

extension JenisPembatalanEnum on JenisPembatalan {
  bool get isWrongSelected => this == JenisPembatalan.wrongSelected;

  bool get isOther => this == JenisPembatalan.other;

  String? get toKey {
    if (isWrongSelected) {
      return 'wrong_selected';
    } else {
      return 'other';
    }
  }

  String? get toName {
    if (isWrongSelected) {
      return 'Salah memilih Kunjungan';
    } else {
      return 'Lainnya';
    }
  }
}

extension NotificationTypeEnum on NotificationType {
  bool get isNotifikasiJamMasuk => this == NotificationType.notifikasiJamMasuk;

  bool get isNotifikasiJamPulang =>
      this == NotificationType.notifikasiJamPulang;

  bool get isNotifikasiJamIstirahat =>
      this == NotificationType.notifikasiJamIstirahat;

  bool get isNotifikasiCutiDiajukan =>
      this == NotificationType.notifikasiCutiDiajukan;

  bool get isNotifikasiCutiDiterima =>
      this == NotificationType.notifikasiCutiDiterima;

  bool get isNotifikasiCutiDitolak =>
      this == NotificationType.notifikasiCutiDitolak;

  bool get isNotifikasiTaskFromAdmin =>
      this == NotificationType.notifikasiTaskFromAdmin;

  bool get isNotifikasiTaskDoneToday =>
      this == NotificationType.notifikasiTaskDoneToday;

  bool get isNotifikasiTaskCancelToday =>
      this == NotificationType.notifikasiTaskCancelToday;

  bool get isTasks => this == NotificationType.tasks;

  bool get isInventarisService => this == NotificationType.inventarisService;

  bool get isInventarisPajak => this == NotificationType.inventarisPajak;

  bool get isOther => this == NotificationType.other;
}

extension NotificationStateEnum on NotificationState {
  bool get isOnMessage => this == NotificationState.onMessage;

  bool get onMessageOpenedApp => this == NotificationState.onMessageOpenedApp;
}

extension ActiveTypeEnum on ActiveType {
  bool get isActive => this == ActiveType.active;

  bool get isDelete => this == ActiveType.deleted;

  String? get toName {
    if (isActive) {
      return 'Aktif';
    } else {
      return 'Tidak Aktif';
    }
  }

  Color? get toColor {
    if (isActive) {
      return AppColors.green;
    } else {
      return AppColors.red;
    }
  }
}

extension ItemTypeProfileEnum on ItemTypeProfile {
  bool get isGeneral => this == ItemTypeProfile.general;

  bool get isLanguage => this == ItemTypeProfile.language;

  bool get isText => this == ItemTypeProfile.text;
}

extension PresenceTypeEnum on AttendanceType {
  bool get isDaily => this == AttendanceType.daily;

  bool get isShift => this == AttendanceType.shift;

  bool get isOncall => this == AttendanceType.oncall;

  String get toName {
    switch (this) {
      case AttendanceType.daily:
        return 'Reguler';
      case AttendanceType.shift:
        return 'Shift';
      case AttendanceType.oncall:
        return 'On Call';
    }
  }

  String get toKey {
    switch (this) {
      case AttendanceType.daily:
        return 'reguler';
      case AttendanceType.shift:
        return 'shift';
      case AttendanceType.oncall:
        return 'oncall';
    }
  }

  Color get displayColor {
    switch (this) {
      case AttendanceType.daily:
        return AppColors.primary;
      case AttendanceType.shift:
        return AppColors.secondary;
      case AttendanceType.oncall:
        return AppColors.green;
    }
  }
}

extension RequestPresensiTypeEnum on RequestPresensiType {
  bool get isLupaPresensiMasuk => this == RequestPresensiType.lupaPresensiMasuk;

  bool get isLupaPresensiPulang =>
      this == RequestPresensiType.lupaPresensiPulang;

  bool get isLupaMasuk => this == RequestPresensiType.lupaMasuk;

  bool get isLupaMasukDanPulang =>
      this == RequestPresensiType.lupaMasukDanPulang;

  bool get isKoreksiMasuk => this == RequestPresensiType.koreksiMasuk;

  bool get isKoreksiPulang => this == RequestPresensiType.koreksiPulang;

  bool get isKoreksiMasukDanPulang =>
      this == RequestPresensiType.koreksiMasukDanPulang;

  bool get isKoreksiWaktuIstirahat =>
      this == RequestPresensiType.koreksiWaktuIstirahat;

  bool get isDinasLuar => this == RequestPresensiType.dinasLuar;

  bool get isWfh => this == RequestPresensiType.wfh;

  String get toName {
    switch (this) {
      case RequestPresensiType.lupaPresensiMasuk:
        return 'Lupa Presensi Masuk';
      case RequestPresensiType.lupaPresensiPulang:
        return 'Lupa Presensi Pulang';
      case RequestPresensiType.lupaMasuk:
        return 'Lupa Masuk';
      case RequestPresensiType.lupaMasukDanPulang:
        return 'Lupa Masuk & Pulang';
      case RequestPresensiType.koreksiMasuk:
        return 'Koreksi Masuk';
      case RequestPresensiType.koreksiPulang:
        return 'Koreksi Pulang';
      case RequestPresensiType.koreksiMasukDanPulang:
        return 'Koreksi Masuk & Pulang';
      case RequestPresensiType.koreksiWaktuIstirahat:
        return 'Koreksi Waktu Istirahat';
      case RequestPresensiType.dinasLuar:
        return 'Dinas Luar';
      case RequestPresensiType.wfh:
        return 'Work From Home';
    }
  }

  String get toKey {
    switch (this) {
      case RequestPresensiType.lupaPresensiMasuk:
        return 'lupa_presensi_masuk';
      case RequestPresensiType.lupaPresensiPulang:
        return 'lupa_presensi_pulang';
      case RequestPresensiType.lupaMasuk:
        return 'lupa_masuk';
      case RequestPresensiType.lupaMasukDanPulang:
        return 'lupa_masuk_dan_pulang';
      case RequestPresensiType.koreksiMasuk:
        return 'koreksi_masuk';
      case RequestPresensiType.koreksiPulang:
        return 'koreksi_pulang';
      case RequestPresensiType.koreksiMasukDanPulang:
        return 'koreksi_masuk_dan_pulang';
      case RequestPresensiType.koreksiWaktuIstirahat:
        return 'koreksi_waktu_istirahat';
      case RequestPresensiType.dinasLuar:
        return 'dinas_luar';
      case RequestPresensiType.wfh:
        return 'wfh';
    }
  }
}

extension RequestPresensiStatusEnum on RequestPresensiStatus {
  bool get isPending => this == RequestPresensiStatus.pending;

  bool get isApproved => this == RequestPresensiStatus.approved;

  bool get isRejected => this == RequestPresensiStatus.rejected;

  bool get isCancelled => this == RequestPresensiStatus.cancelled;

  String get toName {
    switch (this) {
      case RequestPresensiStatus.pending:
        return 'Pending';
      case RequestPresensiStatus.approved:
        return 'Disetujui';
      case RequestPresensiStatus.rejected:
        return 'Ditolak';
      case RequestPresensiStatus.cancelled:
        return 'Dibatalkan';
    }
  }

  String get toKey {
    switch (this) {
      case RequestPresensiStatus.pending:
        return 'pending';
      case RequestPresensiStatus.approved:
        return 'approved';
      case RequestPresensiStatus.rejected:
        return 'rejected';
      case RequestPresensiStatus.cancelled:
        return 'cancelled';
    }
  }
}

extension LeaveStatusExt on LeaveStatus {
  String get toDisplayName {
    switch (this) {
      case LeaveStatus.diterima:
        return "Approved";
      case LeaveStatus.ditolak:
        return 'Rejected';
      case LeaveStatus.diajukan:
        return 'Pending';
    }
  }

  Color get toDisplayColor {
    switch (this) {
      case LeaveStatus.diterima:
        return AppColors.green;
      case LeaveStatus.ditolak:
        return AppColors.danger;
      case LeaveStatus.diajukan:
        return AppColors.warning;
    }
  }
}

extension AttendanceRequestStatusExt on AttendanceRequestStatus {
  String get toDisplayName {
    switch (this) {
      case AttendanceRequestStatus.pending:
        return 'Pending';
      case AttendanceRequestStatus.approved:
        return 'Approved';
      case AttendanceRequestStatus.rejected:
        return 'Rejected';
      case AttendanceRequestStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get toDisplayColor {
    switch (this) {
      case AttendanceRequestStatus.pending:
        return AppColors.warning;
      case AttendanceRequestStatus.approved:
        return AppColors.green;
      case AttendanceRequestStatus.rejected:
        return AppColors.danger;
      case AttendanceRequestStatus.cancelled:
        return AppColors.grey;
    }
  }
}

extension AttendanceRequestTypeExt on AttendanceRequestType {
  String get displayName {
    switch (this) {
      case AttendanceRequestType.lupa_presensi_masuk:
        return 'Lupa Presensi Masuk';
      case AttendanceRequestType.lupa_presensi_pulang:
        return 'Lupa Presensi Pulang';
      case AttendanceRequestType.lupa_masuk:
        return 'Lupa Masuk';
      case AttendanceRequestType.lupa_masuk_dan_pulang:
        return 'Lupa Masuk & Pulang';
      case AttendanceRequestType.koreksi_masuk:
        return 'Koreksi Masuk';
      case AttendanceRequestType.koreksi_pulang:
        return 'Koreksi Pulang';
      case AttendanceRequestType.koreksi_masuk_dan_pulang:
        return 'Koreksi Masuk & Pulang';
      case AttendanceRequestType.koreksi_waktu_istirahat:
        return 'Koreksi Istirahat';
      case AttendanceRequestType.dinas_luar:
        return 'Dinas Luar';
      case AttendanceRequestType.wfh:
        return 'WFH';
    }
  }

  Color get displayColor {
    switch (this) {
      case AttendanceRequestType.lupa_presensi_masuk:
      case AttendanceRequestType.lupa_presensi_pulang:
      case AttendanceRequestType.lupa_masuk:
      case AttendanceRequestType.lupa_masuk_dan_pulang:
        return AppColors.orange;

      case AttendanceRequestType.koreksi_masuk:
      case AttendanceRequestType.koreksi_pulang:
      case AttendanceRequestType.koreksi_masuk_dan_pulang:
      case AttendanceRequestType.koreksi_waktu_istirahat:
        return AppColors.blue;

      case AttendanceRequestType.dinas_luar:
        return AppColors.purple;

      case AttendanceRequestType.wfh:
        return AppColors.tial;
    }
  }
}

extension OvertimeRequestStatusExt on OvertimeRequestStatus {
  String get toDisplayName {
    switch (this) {
      case OvertimeRequestStatus.active:
        return 'Aktif';
      case OvertimeRequestStatus.pending:
        return 'Pending';
      case OvertimeRequestStatus.approved:
        return 'Approved';
      case OvertimeRequestStatus.rejected:
        return 'Rejected';
      case OvertimeRequestStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get toDisplayColor {
    switch (this) {
      case OvertimeRequestStatus.active:
        return AppColors.blue;
      case OvertimeRequestStatus.pending:
        return AppColors.warning;
      case OvertimeRequestStatus.approved:
        return AppColors.green;
      case OvertimeRequestStatus.rejected:
        return AppColors.danger;
      case OvertimeRequestStatus.cancelled:
        return AppColors.grey;
    }
  }
}

extension PayrollSlipStatusExt on PayrollSlipStatus {
  String get toDisplayName {
    switch (this) {
      case PayrollSlipStatus.draft:
        return 'Draft';
      case PayrollSlipStatus.pending:
        return 'Pending';
      case PayrollSlipStatus.approved:
        return 'Approved';
      case PayrollSlipStatus.paid:
        return 'Paid';
      case PayrollSlipStatus.cancelled:
        return 'Cancelled';
      case PayrollSlipStatus.unknown:
        return 'Unknown';
    }
  }

  Color get toDisplayColor {
    switch (this) {
      case PayrollSlipStatus.draft:
        return AppColors.grey;
      case PayrollSlipStatus.pending:
        return AppColors.warning;
      case PayrollSlipStatus.approved:
        return AppColors.blue;
      case PayrollSlipStatus.paid:
        return AppColors.green;
      case PayrollSlipStatus.cancelled:
        return AppColors.danger;
      case PayrollSlipStatus.unknown:
        return AppColors.grey;
    }
  }
}

extension ApprovalTypeExt on ApprovalType {
  String get toDisplayName {
    switch (this) {
      case ApprovalType.single:
        return 'Satu Orang';
      case ApprovalType.sequential:
        return 'Bertahap';
      case ApprovalType.parallel:
        return 'Parallel';
    }
  }
}

extension ApprovalStatusExt on ApprovalStatus {
  String get toDisplayName {
    switch (this) {
      case ApprovalStatus.pending:
        return 'Pending';
      case ApprovalStatus.approved:
        return 'Approved';
      case ApprovalStatus.rejected:
        return 'Rejected';
    }
  }

  Color get toDisplayColor {
    switch (this) {
      case ApprovalStatus.pending:
        return AppColors.warning;
      case ApprovalStatus.approved:
        return AppColors.green;
      case ApprovalStatus.rejected:
        return AppColors.danger;
    }
  }
}

extension ApprovalHistoryStatusExt on ApprovalHistoryStatus {
  String get toDisplayName {
    switch (this) {
      case ApprovalHistoryStatus.in_progress:
        return 'In Progress';
      case ApprovalHistoryStatus.approved:
        return 'Approved';
      case ApprovalHistoryStatus.rejected:
        return 'Rejected';
    }
  }

  Color get toDisplayColor {
    switch (this) {
      case ApprovalHistoryStatus.in_progress:
        return AppColors.warning;
      case ApprovalHistoryStatus.approved:
        return AppColors.green;
      case ApprovalHistoryStatus.rejected:
        return AppColors.danger;
    }
  }
}

extension NotificationNewTypeExtension on NotificationNewType {
  IconData get icon {
    switch (this) {
      case NotificationNewType.notifikasi_jam_istirahat:
        return PhosphorIconsFill.coffee;
      case NotificationNewType.notifikasi_jam_pulang:
        return PhosphorIconsFill.door;
      case NotificationNewType.notifikasi_cuti_diajukan:
        return PhosphorIconsFill.airplaneTilt;
      case NotificationNewType.notifikasi_cuti_diterima:
        return PhosphorIconsFill.checkCircle;
      case NotificationNewType.notifikasi_cuti_ditolak:
        return PhosphorIconsFill.xCircle;
      case NotificationNewType.notifikasi_task_from_admin:
        return PhosphorIconsFill.fileText;
      case NotificationNewType.notifikasi_jam_kerja:
        return PhosphorIconsFill.clock;
      case NotificationNewType.tasks:
        return PhosphorIconsFill.clipboardText;
      case NotificationNewType.inventaris_service:
        return PhosphorIconsFill.wrench;
      case NotificationNewType.inventaris_pajak:
        return PhosphorIconsFill.receipt;
      case NotificationNewType.inventaris_kontrak_sewa:
        return PhosphorIconsFill.signature;
      case NotificationNewType.notifikasi_task_cancel_today:
        return PhosphorIconsFill.calendarX;
      case NotificationNewType.notifikasi_shift_assigned:
        return PhosphorIconsFill.calendar;
      case NotificationNewType.notifikasi_shift_swap_request:
        return PhosphorIconsFill.arrowsLeftRight;
      case NotificationNewType.notifikasi_shift_swap_approved:
        return PhosphorIconsFill.calendarCheck;
      case NotificationNewType.notifikasi_shift_swap_rejected:
        return PhosphorIconsFill.calendarX;
      case NotificationNewType.notifikasi_shift_swap_expired:
        return PhosphorIconsFill.timer;
      case NotificationNewType.notifikasi_punishment_added:
        return PhosphorIconsFill.warning;
      case NotificationNewType.notifikasi_punishment_deleted:
        return PhosphorIconsFill.trash;
      case NotificationNewType.notifikasi_purchase_order_diajukan:
        return PhosphorIconsFill.shoppingCart;
      case NotificationNewType.unknown:
        return PhosphorIconsFill.bell;
    }
  }

  Color get iconColor {
    switch (this) {
      case NotificationNewType.notifikasi_jam_istirahat:
      case NotificationNewType.inventaris_service:
        return AppColors.orange;
      case NotificationNewType.notifikasi_jam_pulang:
      case NotificationNewType.notifikasi_cuti_ditolak:
      case NotificationNewType.notifikasi_punishment_added:
        return AppColors.red;
      case NotificationNewType.notifikasi_cuti_diajukan:
      case NotificationNewType.notifikasi_task_from_admin:
      case NotificationNewType.notifikasi_shift_swap_request:
        return AppColors.blue;
      case NotificationNewType.notifikasi_cuti_diterima:
      case NotificationNewType.notifikasi_shift_swap_approved:
      case NotificationNewType.inventaris_kontrak_sewa:
        return AppColors.green;
      case NotificationNewType.notifikasi_jam_kerja:
      case NotificationNewType.tasks:
        return AppColors.indigo;
      case NotificationNewType.notifikasi_shift_assigned:
        return AppColors.pink;
      case NotificationNewType.unknown:
      default:
        return AppColors.primary;
    }
  }
}

extension ShiftScheduleStatusExt on ShiftScheduleStatus {
  String get toDisplayName {
    switch (this) {
      case ShiftScheduleStatus.assigned:
        return 'Terjadwal';
      case ShiftScheduleStatus.completed:
        return 'Selesai';
      case ShiftScheduleStatus.cancelled:
        return 'Dibatalkan';
      case ShiftScheduleStatus.swap_requested:
        return 'Request Tukar';
      case ShiftScheduleStatus.swapped:
        return 'Sudah Ditukar';
    }
  }

  Color get toDisplayColor {
    switch (this) {
      case ShiftScheduleStatus.assigned:
        return AppColors.success;
      case ShiftScheduleStatus.completed:
        return AppColors.primary;
      case ShiftScheduleStatus.cancelled:
        return AppColors.labelSecondary;
      case ShiftScheduleStatus.swap_requested:
        return AppColors.blue;
      case ShiftScheduleStatus.swapped:
        return AppColors.orange;
    }
  }
}

extension RequestStatusStatusExt on RequestStatus {
  String get toDisplayName {
    switch (this) {
      case RequestStatus.pending:
        return 'Pending';
      case RequestStatus.approved:
        return 'Approved';
      case RequestStatus.rejected:
        return 'Rejected';
      case RequestStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get toDisplayColor {
    switch (this) {
      case RequestStatus.pending:
        return AppColors.warning;
      case RequestStatus.approved:
        return AppColors.green;
      case RequestStatus.rejected:
        return AppColors.danger;
      case RequestStatus.cancelled:
        return AppColors.grey;
    }
  }
}

extension WorkStatusExt on StatusKerja {
  String get toDisplayName {
    switch (this) {
      case StatusKerja.pulang:
        return 'Pulang';
      case StatusKerja.kerja:
        return 'Kerja';
      case StatusKerja.istirahat:
        return 'Istirahat';
      case StatusKerja.mulaiKerja:
        return 'Mulai Kerja';
      case StatusKerja.galat:
        return 'Error';
    }
  }

  Color get toDisplayColor {
    switch (this) {
      case StatusKerja.pulang:
      case StatusKerja.kerja:
        return AppColors.primary;
      case StatusKerja.istirahat:
        return AppColors.blue;
      case StatusKerja.mulaiKerja:
        return AppColors.green;
      case StatusKerja.galat:
        return AppColors.danger;
    }
  }
}

extension CurrencySymbolExt on CurrencySymbol {
  String get displayName {
    switch (this) {
      case CurrencySymbol.IDR:
        return 'Rupiah (IDR)';
      case CurrencySymbol.USD:
        return 'US Dollar (USD)';
      case CurrencySymbol.EUR:
        return 'Euro (EUR)';
    }
  }

  String get symbol {
    switch (this) {
      case CurrencySymbol.IDR:
        return 'Rp';
      case CurrencySymbol.USD:
        return '\$';
      case CurrencySymbol.EUR:
        return '€';
    }
  }

  String get locale {
    switch (this) {
      case CurrencySymbol.IDR:
        return 'id_ID';
      case CurrencySymbol.USD:
        return 'en_US';
      case CurrencySymbol.EUR:
        return 'de_DE';
    }
  }
}
