enum AttendanceRequestType {
  lupa_presensi_masuk,
  lupa_presensi_pulang,
  lupa_masuk,
  lupa_masuk_dan_pulang,
  koreksi_masuk,
  koreksi_pulang,
  koreksi_masuk_dan_pulang,
  koreksi_waktu_istirahat,
  dinas_luar,
  wfh,
}

enum AttendanceRequestStatus { pending, approved, rejected, cancelled }

enum AttendanceRequestApprovalAction {
  approve,
  reject,
  none;

  bool get isApprove => this == AttendanceRequestApprovalAction.approve;

  bool get isReject => this == AttendanceRequestApprovalAction.reject;

  bool get isNone => this == AttendanceRequestApprovalAction.none;
}
