import 'package:auto_route/auto_route.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route,Tab,Global,Form')
class AppRouter extends RootStackRouter {
  final AppGuard auth;

  AppRouter({required this.auth, super.navigatorKey});

  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      initial: true,
      path: mainPath,
      page: MainPageRoute.page,
      guards: [auth],
      children: [
        AutoRoute(path: homePath, page: HomePageRoute.page),
        AutoRoute(
          path: deliveryPath,
          page: DeliveryPageRoute.page,
          children: [
            AutoRoute(
              path: pendingDeliveryPath,
              page: DeliveryPendingTabRoute.page,
            ),
            AutoRoute(
              path: successDeliveryPath,
              page: DeliverySuccessTabRoute.page,
            ),
            AutoRoute(
              path: canceledDeliveryPath,
              page: DeliveryCanceledTabRoute.page,
            ),
          ],
        ),

        // Attendance
        AutoRoute(
          page: AttendancePageRoute.page,
          path: attendancePath,
          children: [
            AutoRoute(page: MyAttendancePageRoute.page, path: myAttendancePath),
            AutoRoute(page: AttendancesPageRoute.page, path: attendancesPath),
          ],
        ),
        AutoRoute(path: consignmentPath, page: ConsignmentPageRoute.page),
        AutoRoute(path: profilePath, page: ProfilePageRoute.page),
      ],
    ),

    // Attendance
    AutoRoute(page: AttendanceDetailPageRoute.page, path: attendanceDetailPath),
    AutoRoute(page: CheckOutPageRoute.page, path: checkOutFormPath),
    AutoRoute(page: CheckInPageRoute.page, path: checkInFormPath),
    AutoRoute(page: TodayAttendancePageRoute.page, path: todayAttendancePath),

    // Announcement
    AutoRoute(page: AnnouncementPageRoute.page, path: announcementPath),

    // Loan
    AutoRoute(page: LoanPageRoute.page, path: loanPath),
    AutoRoute(page: LoanFormPageRoute.page, path: loanFormPath),
    AutoRoute(page: LoanDetailPageRoute.page, path: loanDetailPath),

    // Global
    AutoRoute(page: GlobalPdfViewerPageRoute.page, path: globalPdfViewerPath),
    AutoRoute(page: GlobalCameraPageRoute.page, path: globalCameraPath),
    AutoRoute(page: AppCameraPageRoute.page, path: appCameraPath),
    AutoRoute(page: InAppBrowserPageRoute.page, path: inAppBrowserPath),
    AutoRoute(page: LocationPickerPageRoute.page, path: locationPickerPath),

    // Development
    AutoRoute(page: DevelopmentPageRoute.page, path: developmentPath),

    // Sales & Inventory
    AutoRoute(page: SalesDashboardPageRoute.page, path: salesDashboardPath),
    AutoRoute(page: ProductCatalogPageRoute.page, path: productCatalogPath),
    AutoRoute(page: PiutangPageRoute.page, path: piutangPath),
    AutoRoute(page: TakingOrderPageRoute.page, path: takingOrderPath),
    AutoRoute(page: VanStockPageRoute.page, path: vanStockPath),
    AutoRoute(page: IncidentalReportPageRoute.page, path: incidentalReportPath),
    AutoRoute(
      page: IncidentalReportFormPageRoute.page,
      path: incidentalReportFormPath,
    ),

    // Apotek
    AutoRoute(page: ApotekPageRoute.page, path: apotekPath),
    AutoRoute(page: ApotekAddFormRoute.page, path: apotekAddFormPath),
    AutoRoute(page: ApotekDetailPageRoute.page, path: apotekDetailPath),
    AutoRoute(page: ApotekSearchPageRoute.page, path: apotekSearchPath),

    // Task
    AutoRoute(
      page: DeliveryCheckingFormRoute.page,
      path: deliveryCheckingFormPath,
    ),
    AutoRoute(page: DeliveryAddFormRoute.page, path: deliveryAddFormPath),
    AutoRoute(page: DeliveryDetailPageRoute.page, path: deliveryDetailPath),
    AutoRoute(
      page: DeliveryCanceledFormRoute.page,
      path: deliveryCanceledFormPath,
    ),

    // Attendance Request
    AutoRoute(
      page: AttendanceRequestPageRoute.page,
      path: attendanceRequestPath,
      children: [
        AutoRoute(
          page: MyAttendanceRequestPageRoute.page,
          path: myAttendanceRequestsPath,
        ),
        AutoRoute(
          page: AttendanceRequestApprovalPageRoute.page,
          path: attendanceRequestApprovalPath,
        ),
      ],
    ),
    AutoRoute(
      page: AttendanceRequestFormPageRoute.page,
      path: attendanceRequestFormPath,
    ),

    // Leaves
    AutoRoute(
      page: LeavePageRoute.page,
      path: leavePath,
      children: [
        AutoRoute(page: MyLeavePageRoute.page, path: myLeaveTabPath),
        AutoRoute(
          page: LeaveApprovalPageRoute.page,
          path: leaveApprovalTabPath,
        ),
      ],
    ),
    AutoRoute(page: LeaveRequestPageRoute.page, path: leaveRequestPath),

    // Overtime
    AutoRoute(
      page: OvertimePageRoute.page,
      path: overtimePath,
      children: [
        AutoRoute(
          page: MyOvertimeRequestPageRoute.page,
          path: myOvertimeRequestsPath,
        ),
        AutoRoute(
          page: OvertimeRequestApprovalPageRoute.page,
          path: overtimeRequestApprovalPath,
        ),
      ],
    ),
    AutoRoute(
      page: OvertimeRequestFormPageRoute.page,
      path: overtimeRequestFormPath,
    ),

    // Payroll
    AutoRoute(
      page: PayrollPageRoute.page,
      path: payrollPath,
      children: [
        AutoRoute(
          page: MyPayrollPageRoute.page,
          path: 'my-payroll',
          initial: true,
        ),
        AutoRoute(
          page: ApprovalPayrollPageRoute.page,
          path: 'approval-payroll',
        ),
      ],
    ),
    AutoRoute(page: PayrollDetailPageRoute.page, path: payrollDetailPath),
    AutoRoute(page: PayrollDownloadPageRoute.page, path: payrollDownloadPath),
    AutoRoute(page: KalenderPageRoute.page, path: kalenderPath),
    AutoRoute(page: ActivityPageRoute.page, path: activityPath),
    AutoRoute(page: LogbookPageRoute.page, path: logbookPath),

    // Shift
    AutoRoute(
      page: ShiftPageRoute.page,
      path: shiftPath,
      children: [
        AutoRoute(page: MyShiftPageRoute.page, path: myShiftPath),
        AutoRoute(page: MyShiftSwapPageRoute.page, path: myShiftSwapPath),
        AutoRoute(
          page: ApprovalShiftSwapPageRoute.page,
          path: approvalShiftSwapPath,
        ),
      ],
    ),
    AutoRoute(
      page: ShiftSwapRequestFormPageRoute.page,
      path: shiftSwapRequestFormPath,
    ),

    // Reimbursement
    AutoRoute(
      page: ReimbursementPageRoute.page,
      path: reimbursementPath,
      children: [
        AutoRoute(
          page: MyReimbursementPageRoute.page,
          path: myReimbursementPath,
        ),
        AutoRoute(
          page: ApprovalReimbursementPageRoute.page,
          path: approvalReimbursementPath,
        ),
      ],
    ),
    AutoRoute(
      page: ReimbursementRequestFormPageRoute.page,
      path: reimbursementRequestFormPath,
    ),

    // Survey
    AutoRoute(page: SurveyPageRoute.page, path: surveyPath),

    // Profile
    AutoRoute(page: ProfileUserPageRoute.page, path: profileUserPath),
    AutoRoute(page: ProfileAccountPageRoute.page, path: profileAccountPath),
    AutoRoute(page: ProfileInventoryPageRoute.page, path: profileInventoryPath),
    AutoRoute(page: ProfileOfficePageRoute.page, path: profileOfficePath),
    AutoRoute(page: ProfileSyncPageRoute.page, path: profileSyncPath),

    // Notification
    AutoRoute(page: NotificationPageRoute.page, path: notificationPath),

    // Auth
    AutoRoute(page: LoginPageRoute.page, path: loginPath),
    AutoRoute(page: RegisterPageRoute.page, path: registerPath),
    AutoRoute(page: InstansiSetupPageRoute.page, path: instansiSetupPath),

    // Intro
    AutoRoute(page: IntroPageRoute.page, path: introPath),

    // Chat
    AutoRoute(page: ChatListPageRoute.page, path: chatListPath),
    AutoRoute(page: ChatRoomPageRoute.page, path: chatRoomPath),
    AutoRoute(page: ChatSearchUserPageRoute.page, path: chatSearchUserPath),
    AutoRoute(page: ChatCreateGroupPageRoute.page, path: chatCreateGroupPath),
    AutoRoute(page: EmailDetailPageRoute.page, path: emailDetailPath),

    // KPI
    AutoRoute(
      page: KpiPageRoute.page,
      path: kpiPath,
      children: [
        AutoRoute(page: MyKpiTabRoute.page, path: myKpiPath, initial: true),
        AutoRoute(page: TeamKpiTabRoute.page, path: teamKpiPath),
      ],
    ),
    AutoRoute(page: SelfAssessmentPageRoute.page, path: selfAssessmentPath),
    AutoRoute(page: KpiReviewPageRoute.page, path: kpiReviewPath),

    // Fallback
    RedirectRoute(path: '*', redirectTo: mainPath),
  ];
}

const vanStockPath = '/van-stock';

const chatListPath = '/chat-list';
const chatRoomPath = '/chat-room';
const chatSearchUserPath = '/chat-search-user';
const chatCreateGroupPath = '/chat-create-group';
const emailDetailPath = '/email-detail';
const profileSyncPath = '/profile-sync';
// force rebuild
