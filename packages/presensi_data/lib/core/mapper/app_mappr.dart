import 'package:auto_mappr_annotation/auto_mappr_annotation.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

import 'app_mappr.auto_mappr.dart';

@AutoMappr([
  // Common
  MapType<PaginationParams, PaginationRequest>(),
  MapType<AppLocation, LocationModel>(
    fields: [
      Field('latitude', custom: AppMappr.mapLatitude),
      Field('longitude', custom: AppMappr.mapLongitude),
    ],
  ),
  MapType<LocationResponse, AppLocation>(),

  // Attendance
  MapType<AttendanceResponse, Attendance>(),
  MapType<AttendanceActivityResponse, AttendanceActivity>(),
  MapType<AttendancePhotoResponse, AttendancePhoto>(),
  MapType<
    AttendanceActivityFormatLocalResponse,
    AttendanceActivityFormatLocal
  >(),
  MapType<AttendanceCurrentSettingResponse, AttendanceCurrentSetting>(),
  MapType<AttendanceStatisticResponse, AttendanceStatistic>(),
  MapType<CheckInInputParams, CheckInRequest>(),
  MapType<CheckOutInputParams, CheckOutRequest>(),
  MapType<BreakInParams, BreakInRequest>(),
  MapType<BreakOutParams, BreakOutRequest>(),
  MapType<GetAttendancesParams, GetAttendancesRequest>(
    fields: [
      Field('pilihTanggal', custom: AppMappr.mapNull),
      Field('rentang', custom: AppMappr.mapNullInt),
      Field('tipeLaporan', custom: AppMappr.mapKastem),
      Field('startDate', from: 'startDate'),
      Field('endDate', from: 'endDate'),
      Field('nama', from: 'searchName'),
      Field('typePresensi', from: 'typePresensi'),
    ],
  ),

  // Leave Request
  MapType<GetLeaveRequestsParams, GetLeaveRequestsRequest>(),
  MapType<LeaveCategoryResponse, LeaveCategory>(),
  MapType<LeaveRequestResponse, LeaveRequest>(),
  MapType<CreateLeaveRequestParams, CreateLeaveRequestRequest>(),

  // User
  MapType<UserResponse, User>(
    fields: [Field('rolePermissions', custom: AppMappr.mapRolePermissions)],
  ),
  MapType<UserAvatarResponse, UserAvatar>(),
  MapType<DepartmentResponse, Department>(),
  MapType<OrganizationResponse, Organization>(),
  MapType<GetUsersParams, GetUsersRequest>(),

  // Shift
  MapType<GetAvailableShiftsForSwapParams, GetAvailableShiftsForSwapRequest>(),
  MapType<
    CreateShiftSwapRequestApprovalParams,
    CreateShiftSwapRequestApprovalRequest
  >(),
  MapType<AvailableShiftForSwapScheduleResponse, ShiftSchedule>(),
  MapType<AvailableShiftForSwapResponse, AvailableShiftForSwap>(),
  MapType<GetShiftSchedulesParams, GetShiftSchedulesRequest>(),
  MapType<GetShiftSwapRequestsParams, GetShiftSwapRequestsRequest>(),
  MapType<GetMyShiftSchedulesParams, GetMyShiftSchedulesRequest>(),
  MapType<ShiftResponse, Shift>(),
  MapType<ShiftScheduleResponse, ShiftSchedule>(),
  MapType<ShiftSwapRequestResponse, ShiftSwapRequest>(),
  MapType<GetMyShiftSwapRequestsParams, GetMyShiftSwapRequestsRequest>(),

  // Attendance Request
  MapType<AttendanceRequestResponse, AttendanceRequest>(),
  MapType<GetAttendanceRequestsParams, GetAttendanceRequestsRequest>(),
  MapType<CreateAttendanceRequestParams, CreateAttendanceRequestRequest>(),

  // Overtime
  MapType<GetOvertimeRequestsParams, GetOvertimeRequestsRequest>(),
  MapType<OvertimeRequestResponse, OvertimeRequest>(),
  MapType<CreateOvertimeRequestParams, CreateOvertimeRequestRequest>(),

  // Approval
  MapType<CreateApprovalParams, CreateApprovalRequest>(),
  MapType<GetMyPendingApprovalsParams, GetMyPendingApprovalsRequest>(),
  MapType<ApprovalHistoryResponse, ApprovalHistory>(),
  MapType<PayrollApprovalBatchResponse, PayrollApprovalBatch>(),
  MapType<ApproverResponse, Approver>(),

  // Notification
  MapType<GetNotificationParams, GetNotificationsRequest>(),
  MapType<NotificationResponse, AppNotification>(),

  // Payroll
  MapType<GetPayrollSlipsParams, GetPayrollSlipsRequest>(),
  MapType<PayrollSlipUserResponse, PayrollSlipUser>(),
  MapType<PayrollAttendanceSummaryResponse, PayrollAttendanceSummary>(),
  MapType<PayrollDeductionSummaryResponse, PayrollDeductionSummary>(),
  MapType<PayrollSlipResponse, PayrollSlip>(),

  // Setting
  MapType<SettingResponse, Setting>(),

  // Announcement
  MapType<AnnouncementResponse, Announcement>(),
  MapType<AnnouncementAttachmentResponse, AnnouncementAttachment>(),

  // Survey
  MapType<SurveyResponse, Survey>(),

  // Reimbursement
  MapType<GetReimbursementsParams, GetReimbursementsRequest>(),
  MapType<ReimbursementResponse, Reimbursement>(),
  MapType<ReimbursementCategoryResponse, ReimbursementCategory>(),
  MapType<CreateReimbursementParams, CreateReimbursementRequest>(),

  // KPI
  MapType<KpiAssignmentUserResponse, KpiAssignmentUser>(
    fields: [
      Field('fotoUrl', custom: AppMappr.mapKpiFoto),
      Field('divisiName', custom: AppMappr.mapKpiDivisi),
      Field('jabatanName', custom: AppMappr.mapKpiJabatan),
    ],
  ),
  MapType<KpiAssignmentTemplateResponse, KpiAssignmentTemplate>(
    fields: [
      Field('namaTemplate', from: 'nama_template'),
      Field('allowSelfAssessment', from: 'allow_self_assessment'),
      Field('anonymousPeerReview', from: 'anonymous_peer_review'),
    ],
  ),
  MapType<KpiCategoryRefResponse, KpiCategoryRef>(
    fields: [Field('namaKategori', from: 'nama_kategori')],
  ),
  MapType<KpiIndicatorRefResponse, KpiIndicatorRef>(
    fields: [
      Field('namaIndikator', from: 'nama_indikator'),
      Field('tipeData', from: 'tipe_data'),
      Field('category', from: 'category_id'),
    ],
  ),
  MapType<KpiScoreResponse, KpiScore>(
    fields: [
      Field('indicator', from: 'indicator_id'),
      Field('targetMinimum', from: 'target_minimum'),
      Field('targetMax', from: 'target_max'),
      Field('nilaiAktual', from: 'nilai_aktual'),
      Field('selfRating', from: 'self_rating'),
      Field('catatanKaryawan', from: 'catatan_karyawan'),
      Field('managerRating', from: 'manager_rating'),
      Field('catatanReviewer', from: 'catatan_reviewer'),
      Field('nilaiRating', from: 'nilai_rating'),
      Field('nilaiTerbobot', from: 'nilai_terbobot'),
      Field('autoData', from: 'auto_data'),
    ],
  ),
  MapType<KpiAssignmentResponse, KpiAssignment>(
    fields: [
      Field('user', from: 'user_id'),
      Field('template', from: 'template_id'),
      Field('periodeLabel', from: 'periode_label'),
      Field('sourceUpdateMessage', from: 'source_update_message'),
      Field('tanggalMulai', from: 'tanggal_mulai'),
      Field('tanggalSelesai', from: 'tanggal_selesai'),
      Field('finalScore', from: 'final_score'),
      Field('finalGrade', from: 'final_grade'),
      Field('catatanKaryawanGlobal', from: 'catatan_karyawan_global'),
      Field('catatanReviewerGlobal', from: 'catatan_reviewer_global'),
      Field('selfSubmittedAt', from: 'self_submitted_at'),
      Field('managerReviewedAt', from: 'manager_reviewed_at'),
      Field('acknowledgedAt', from: 'acknowledged_at'),
    ],
  ),
  MapType<KpiGradeDistributionResponse, KpiGradeDistribution>(),
  MapType<KpiTeamSummaryResponse, KpiTeamSummary>(
    fields: [
      Field('totalKaryawan', from: 'total_karyawan'),
      Field('inProgress', from: 'in_progress'),
      Field('notStarted', from: 'not_started'),
      Field('avgScore', from: 'avg_score'),
      Field('gradeDistribution', from: 'grade_distribution'),
    ],
  ),
  MapType<SelfScoreInputParams, SelfScoreInputRequest>(
    fields: [
      Field('indicator_id', from: 'indicatorId'),
      Field('self_rating', from: 'selfRating'),
      Field('catatan_karyawan', from: 'catatanKaryawan'),
    ],
  ),
  MapType<SubmitSelfAssessmentParams, KpiSelfAssessmentRequest>(
    fields: [
      Field('assignment_id', from: 'assignmentId'),
      Field('catatan_karyawan_global', from: 'catatanKaryawanGlobal'),
    ],
  ),
  MapType<ManagerScoreInputParams, ManagerScoreInputRequest>(
    fields: [
      Field('indicator_id', from: 'indicatorId'),
      Field('manager_rating', from: 'managerRating'),
      Field('catatan_reviewer', from: 'catatanReviewer'),
    ],
  ),
  MapType<SubmitManagerReviewParams, KpiManagerReviewRequest>(
    fields: [
      Field('assignment_id', from: 'assignmentId'),
      Field('catatan_reviewer_global', from: 'catatanReviewerGlobal'),
    ],
  ),
])
class AppMappr extends $AppMappr {
  const AppMappr();

  // TODO: remove this manual mapping when LocationModel already refactored
  static String mapLatitude(AppLocation i) => i.lat.toString();
  static String mapLongitude(AppLocation i) => i.long.toString();

  static int mapZero(GetAttendancesParams _) => 0;
  static int? mapNullInt(GetAttendancesParams _) => null;
  static String mapBulanan(GetAttendancesParams _) => 'bulanan';
  static String mapKastem(GetAttendancesParams _) => 'kastem';
  static DateTime? mapNull(GetAttendancesParams _) => null;
  static String? mapKpiFoto(KpiAssignmentUserResponse value) =>
      value.foto?['url_path']?.toString();
  static String? mapKpiDivisi(KpiAssignmentUserResponse value) =>
      value.divisi_id?['nama_divisi']?.toString();
  static String? mapKpiJabatan(KpiAssignmentUserResponse value) =>
      value.jabatan_id?['nama_jabatan']?.toString();
  static LoginRolePermissionsEntity? mapRolePermissions(UserResponse input) =>
      input.rolePermissions;
}
