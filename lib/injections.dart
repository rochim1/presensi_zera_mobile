import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:presensi_data/core/mapper/app_mappr.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_data/src/datasources/remote/sales_target_remote_datasource.dart';
import 'package:presensi_data/src/datasources/remote/task_report_remote_datasource.dart';
import 'package:presensi_data/src/repositories/sales_target_repository_impl.dart';
import 'package:presensi_data/src/repositories/task_report_repository_impl.dart';
import 'package:presensi_domain/src/repositories/sales_target_repository.dart';
import 'package:presensi_domain/src/repositories/task_report_repository.dart';
import 'package:presensi_mobile/presentation/cubits/sales_target/sales_target_cubit.dart';
import 'package:presensi_mobile/presentation/cubits/task_report/task_report_cubit.dart';

import 'package:presensi_mobile/presentation/pages/inventory/incidental/bloc/incidental_report_cubit.dart';
import 'package:presensi_mobile/presentation/pages/inventory/incidental/bloc/incidental_report_form_cubit.dart';

import 'package:presensi_data/src/datasources/remote/email_remote_datasource.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_cubit.dart';
import 'package:presensi_mobile/presentation/bloc/presensi/presensi_get_one_cubit/presensi_get_one_cubit.dart';
import 'package:presensi_mobile/presentation/pages/home/bloc/home_cubit.dart';
import 'package:presensi_mobile/service/_service.dart';
import 'package:presensi_mobile/presentation/pages/kpi/tabs/my_kpi/bloc/my_kpi_cubit.dart';
import 'package:presensi_mobile/presentation/pages/kpi/tabs/team_kpi/bloc/team_kpi_cubit.dart';
import 'package:presensi_mobile/presentation/pages/kpi/self_assessment/bloc/self_assessment_cubit.dart';
import 'package:presensi_mobile/presentation/pages/kpi/kpi_review/bloc/kpi_review_cubit.dart';
import 'package:presensi_mobile/presentation/pages/announcement/bloc/announcement_cubit.dart';
import 'package:presensi_mobile/presentation/bloc/chat/chat_create_group_cubit.dart';
import 'package:presensi_mobile/presentation/bloc/email/email_list_cubit.dart';
import 'package:presensi_mobile/presentation/pages/loan/bloc/loan_form_cubit.dart';
import 'package:presensi_mobile/presentation/pages/loan/bloc/loan_list_cubit.dart';
import 'package:presensi_mobile/presentation/pages/van_stock/bloc/van_stock_cubit.dart';
import 'package:presensi_mobile/presentation/bloc/delivery_order/delivery_order_get_all_cubit.dart';
import 'package:presensi_mobile/presentation/bloc/order/record_payment/record_payment_cubit.dart';
import 'package:presensi_mobile/core/_core.dart';

/// Injection instance e.g, `sl<FlavorConfig>().name;`
final sl = GetIt.instance;

/// For print debugger e.g logX.e(details.toString(), stackTrace: details.stack);
final log = sl<Logger>();

final fl = sl<FlavorConfig>();

final fs = sl<FirebaseCrashlytics>();

final fa = sl<FirebaseAnalytics>();

final rc = sl<RemoteConfigService>();

void initLocator(FlavorConfig flavor) {
  sl.allowReassignment = true;

  // //! Core
  _core();
  // //! External
  _external(flavor);
  // //! Service
  _service();
  // //! Bloc / Cubit
  try {
    _bloc();
    print('[DI] _bloc() completed successfully');
  } catch (e, s) {
    print('[DI] _bloc() FAILED: $e');
    print('[DI] Stack: $s');
  }
  // //! Usecase
  try {
    _useCase();
    print('[DI] _useCase() completed successfully');
  } catch (e, s) {
    print('[DI] _useCase() FAILED: $e');
    print('[DI] Stack: $s');
  }
  // //! Repository
  try {
    _repository();
    print('[DI] _repository() completed successfully');
  } catch (e, s) {
    print('[DI] _repository() FAILED: $e');
    print('[DI] Stack: $s');
  }
  // //! DataSource
  try {
    _dataSource();
    print('[DI] _dataSource() completed successfully');
  } catch (e, s) {
    print('[DI] _dataSource() FAILED: $e');
    print('[DI] Stack: $s');
  }

  // Verify critical registrations
  print('[DI] EmailListCubit registered: ${sl.isRegistered<EmailListCubit>()}');
  print(
    '[DI] GetAllEmailUsecase registered: ${sl.isRegistered<GetAllEmailUsecase>()}',
  );
  print(
    '[DI] CountUnreadEmailUsecase registered: ${sl.isRegistered<CountUnreadEmailUsecase>()}',
  );
  print(
    '[DI] EmailRepository registered: ${sl.isRegistered<EmailRepository>()}',
  );
}

void _core() {
  // App Mappr
  sl.registerSingleton<AppMappr>(const AppMappr());
}

void _external(FlavorConfig flavor) {
  // Flavor
  sl.registerSingleton<FlavorConfig>(flavor);
  // Logger
  sl.registerSingleton<Logger>(Logger());
  // Connectivity regiter
  sl.registerSingleton<Connectivity>(Connectivity());
  // Location Class
  sl.registerSingleton<Location>(Location());
  // Analytics App
  sl.registerSingleton<FirebaseAnalytics>(FirebaseAnalytics.instance);
  // Crashlytics has no web implementation. Keep its registration native-only;
  // every access is guarded with kIsWeb as well.
  if (!kIsWeb) {
    sl.registerSingleton<FirebaseCrashlytics>(FirebaseCrashlytics.instance);
  }
  // Remote Config
  sl.registerSingleton<FirebaseRemoteConfig>(FirebaseRemoteConfig.instance);
  // FCM notification
  sl.registerSingleton<FirebaseMessaging>(FirebaseMessaging.instance);
  // Local notification
  sl.registerSingleton<FlutterLocalNotificationsPlugin>(
    FlutterLocalNotificationsPlugin(),
  );
  // Device Info
  sl.registerSingleton<DeviceInfoPlugin>(DeviceInfoPlugin());
  // handle API graphql setup jwt and header
  sl.registerSingleton<GraphqlLinkService>(GraphqlLinkService(sl()));
  // Handle API graphql service
  sl.registerSingleton<GraphQlService>(
    GraphQlService(flavor: sl(), linkService: sl()),
  );
  // API for Rest Api
  // sl.registerSingleton(RestService(flavor));
  // Remote Config
  sl.registerSingleton<RemoteConfigService>(
    RemoteConfigService(flavorConfig: sl(), remoteConfig: sl(), log: sl()),
  );
  // Login route
  sl.registerFactory<AppGuard>(() => AppGuard(sl()));
  // Network Info
  sl.registerFactory<NetworkInfo>(() => NetworkInfoImpl(sl()));
}

void _service() {
  // Local Notification Service
  sl.registerLazySingleton<LocalNotificationService>(
    () => LocalNotificationServiceImpl(sl()),
  );

  sl.registerLazySingleton<LocationService>(
    () => LocationServiceImpl(locationLib: sl()),
  );

  // Local Cache Service
  sl.registerLazySingleton<LocalCacheService>(() => LocalCacheService());

  sl.registerLazySingleton<SyncService>(
    () => SyncService(
      orderRepository: sl(),
      presensiRepository: sl(),
      tasksRepository: sl(),
      localCacheService: sl(),
      networkInfo: sl(),
    ),
  );
}

void _bloc() {
  // Common
  sl.registerFactory<AppCameraCubit>(() => AppCameraCubit());

  // Global
  sl.registerFactory(
    () => AppCubit(
      getActiveAttendanceUseCase: sl(),
      getAttendancesUseCase: sl(),
      getEffectiveScheduleTodayUseCase: sl(),
      getCurrentUserUseCase: sl(),
      getSettingByOrganizationIdUseCase: sl(),
      getAuthSessionUseCase: sl(),
      createOvertimeRequestUseCase: sl(),
      getActiveOvertimeSessionUseCase: sl(),
      startOvertimeSessionUseCase: sl(),
      finishOvertimeSessionUseCase: sl(),
      cancelOvertimeSessionUseCase: sl(),
    ),
  );
  sl.registerFactory(() => GlobalInAppUpgradeCubit());
  sl.registerFactory(() => GlobalAttachmentCubit());
  sl.registerFactory(() => GlobalCameraCubit());
  sl.registerFactory(() => GlobalMapCubit(sl()));
  sl.registerFactory(() => GlobalPdfViewerCubit(sl()));
  sl.registerFactory(() => GlobalGetVersionCubit(sl()));
  sl.registerFactory(
    () => GlobalPostFcmCubit(
      deviceInfo: sl(),
      postTokenFcm: sl(),
      messaging: sl(),
      loginCheck: sl(),
      localNotificationService: sl(),
    ),
  );
  sl.registerFactory<HomeCubit>(
    () => HomeCubit(
      logger: sl(),
      breakInUseCase: sl(),
      breakOutUseCase: sl(),
      getUnreadNotificationsCountUseCase: sl(),
      getAnnouncementsUseCase: sl(),
      chatGetConversationsUseCase: sl(),
      countUnreadEmailUseCase: sl(),
    ),
  );
  // Login
  sl.registerFactory<LoginSignInCubit>(
    () => LoginSignInCubit(deviceInfo: sl(), loginSignIn: sl()),
  );
  sl.registerFactory<LoginCheckCubit>(() => LoginCheckCubit(sl()));
  sl.registerFactory<LoginSignOutCubit>(() => LoginSignOutCubit(sl()));
  sl.registerFactory<RegisterCubit>(
    () => RegisterCubit(
      loginRegister: sl(),
      loginCheckEmailAvailable: sl(),
      loginCheckUsernameAvailable: sl(),
    ),
  );
  // User
  sl.registerFactory<UserGetLocalCubit>(() => UserGetLocalCubit(sl()));
  sl.registerFactory<UserGetDataCubit>(() => UserGetDataCubit(sl()));
  sl.registerFactory<UserPostCubit>(
    () => UserPostCubit(userPost: sl(), userPostAccount: sl()),
  );
  sl.registerFactory<UserPostImageCubit>(
    () => UserPostImageCubit(userDeleteImage: sl(), userPostImage: sl()),
  );
  sl.registerFactory<UserGetAllInventarisCubit>(
    () => UserGetAllInventarisCubit(sl()),
  );
  // Presensi
  sl.registerFactory<PresensiGetAllDataCubit>(
    () => PresensiGetAllDataCubit(sl()),
  );
  sl.registerFactory<PresensiGetOneCubit>(() => PresensiGetOneCubit(sl()));
  sl.registerFactory<CheckInCubit>(
    () =>
        CheckInCubit(logger: sl(), checkInUseCase: sl(), locationService: sl()),
  );
  sl.registerFactory<CheckOutCubit>(
    () => CheckOutCubit(
      logger: sl(),
      checkOutUseCase: sl(),
      locationService: sl(),
      logbookRemoteDatasource: sl(),
      loginLocalDatasource: sl(),
      localCacheService: sl(),
      syncService: sl(),
    ),
  );

  // Attendance
  sl.registerFactory(
    () => AttendanceCubit(logger: sl(), getAttendanceStatisticsUseCase: sl()),
  );
  sl.registerFactory(
    () => MyAttendanceCubit(logger: sl(), getMyAttendancesUseCase: sl()),
  );
  sl.registerFactory(
    () => AttendanceDetailCubit(
      logger: sl(),
      getAttendanceByIdUseCase: sl(),
      locationService: sl(),
    ),
  );
  sl.registerFactory(
    () => AttendancesCubit(logger: sl(), getAttendancesUseCase: sl()),
  );

  // Attendance Request
  sl.registerFactory(() => AttendanceRequestCubit(logger: sl()));
  sl.registerFactory(
    () => MyAttendanceRequestCubit(
      logger: sl(),
      getAttendanceRequestsUseCase: sl(),
      repository: sl(),
    ),
  );
  sl.registerFactory(
    () => AttendanceRequestApprovalCubit(
      logger: sl(),
      getMyPendingApprovalsUseCase: sl(),
      createApprovalUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => AttendanceRequestFormCubit(
      logger: sl(),
      getShiftSchedulesUseCase: sl(),
      createAttendanceRequestUseCase: sl(),
      repository: sl(),
    ),
  );

  // Leaves
  sl.registerFactory<LeaveCubit>(
    () => LeaveCubit(
      logger: sl(),
      testWorkflowUserUseCase: sl(),
      getAuthSessionUseCase: sl(),
    ),
  );
  sl.registerFactory<MyLeaveCubit>(
    () => MyLeaveCubit(
      logger: sl(),
      getLeaveRequestsUseCase: sl(),
      repository: sl(),
    ),
  );
  sl.registerFactory<LeaveApprovalCubit>(
    () => LeaveApprovalCubit(
      logger: sl(),
      getMyPendingApprovalsUseCase: sl(),
      getLeaveRequestByIdUseCase: sl(),
      createApprovalUseCase: sl(),
    ),
  );
  sl.registerFactory<LeaveRequestCubit>(
    () => LeaveRequestCubit(
      logger: sl(),
      getLeaveCategoriesUseCase: sl(),
      getUsersUseCase: sl(),
      createLeaveRequestUseCase: sl(),
      leaveRepository: sl(),
    ),
  );

  // Overtime
  sl.registerFactory(() => OvertimeCubit(logger: sl()));
  sl.registerFactory(
    () => MyOvertimeRequestCubit(
      logger: sl(),
      getOvertimeRequestsUseCase: sl(),
      deleteOvertimeRequestUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => OvertimeRequestApprovalCubit(
      logger: sl(),
      getMyPendingApprovalsUseCase: sl(),
      getOvertimeRequestByIdUseCase: sl(),
      createApprovalUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => OvertimeRequestFormCubit(
      logger: sl(),
      createOvertimeRequestUseCase: sl(),
      updateOvertimeRequestUseCase: sl(),
    ),
  );

  // Payroll
  sl.registerFactory(
    () => PayrollCubit(
      logger: sl(),
      getPayrollSlipsUseCase: sl(),
      testWorkflowUserUseCase: sl(),
      getAuthSessionUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => PayrollDetailCubit(
      logger: sl(),
      getPayrollSlipByIdUseCase: sl(),
      downloadPayrollSlipPdfUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => ApprovalPayrollCubit(
      getMyPendingApprovalsUseCase: sl(),
      createApprovalUseCase: sl(),
    ),
  );

  // Shift
  sl.registerFactory(() => ShiftCubit(logger: sl()));
  sl.registerFactory(
    () => MyShiftCubit(logger: sl(), getMyShiftSchedulesUseCase: sl()),
  );
  sl.registerFactory(
    () => MyShiftSwapCubit(
      logger: sl(),
      getMyShiftSwapRequestUseCase: sl(),
      repository: sl(),
    ),
  );
  sl.registerFactory(
    () => ShiftSwapRequestFormCubit(
      logger: sl(),
      getShiftScheduleByIdUseCase: sl(),
      getAvailableShiftsForSwapUseCase: sl(),
      createShiftSwapRequestUseCase: sl(),
      repository: sl(),
    ),
  );
  sl.registerFactory(
    () => ApprovalShiftSwapCubit(
      logger: sl(),
      getShiftSwapRequestsUseCase: sl(),
      createShiftSwapRequestApprovalUseCase: sl(),
    ),
  );

  // Reimbursement
  sl.registerFactory(() => ReimbursementCubit(logger: sl()));
  sl.registerFactory(
    () => MyReimbursementCubit(
      logger: sl(),
      getMyReimbursementsUseCase: sl(),
      repository: sl(),
    ),
  );
  sl.registerFactory(
    () => ApprovalReimbursementCubit(
      logger: sl(),
      getMyPendingApprovalsUseCase: sl(),
      getReimbursementByIdUseCase: sl(),
      createApprovalUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => ReimbursementRequestFormCubit(
      logger: sl(),
      createReimbursementUseCase: sl(),
      getReimbursementCategoriesUseCase: sl(),
      repository: sl(),
    ),
  );

  // Survey
  sl.registerFactory(
    () => SurveyCubit(logger: sl(), getMySurveysUseCase: sl()),
  );

  // Notification
  sl.registerFactory(
    () => NotificationCubit(
      logger: sl(),
      getNotificationsUseCase: sl(),
      markNotificationAsReadByIdUseCase: sl(),
      deleteNotificationByIdUseCase: sl(),
    ),
  );

  // Tasks
  sl.registerFactory<TasksGetAllPendingCubit>(
    () => TasksGetAllPendingCubit(sl()),
  );
  sl.registerFactory<TasksGetAllSuccessCubit>(
    () => TasksGetAllSuccessCubit(sl()),
  );
  sl.registerFactory<TasksGetAllCanceledCubit>(
    () => TasksGetAllCanceledCubit(sl()),
  );
  sl.registerFactory<TasksPostDataCubit>(() => TasksPostDataCubit(sl()));
  sl.registerFactory<TasksGetAllApotikCubit>(
    () => TasksGetAllApotikCubit(sl()),
  );
  sl.registerFactory<TasksPostCompletedCubit>(
    () => TasksPostCompletedCubit(sl()),
  );
  sl.registerFactory<TasksPostCanceledCubit>(
    () => TasksPostCanceledCubit(sl()),
  );
  sl.registerFactory<TasksGetAllPerjalananCubit>(
    () => TasksGetAllPerjalananCubit(sl()),
  );

  // Sales Target & Task Report
  sl.registerFactory<SalesTargetCubit>(() => SalesTargetCubit(sl()));
  sl.registerFactory<TaskReportCubit>(() => TaskReportCubit(sl()));
  // Apotek
  sl.registerFactory<ApotekGetAllDataCubit>(() => ApotekGetAllDataCubit(sl()));
  sl.registerFactory<ApotekPostDataCubit>(() => ApotekPostDataCubit(sl()));
  sl.registerFactory<ApotekQueryCubit>(
    () => ApotekQueryCubit(getQuery: sl(), postQuery: sl()),
  );

  // Order
  sl.registerFactory<OrderCreateCubit>(() => OrderCreateCubit(sl()));
  sl.registerFactory<ProductGetAllCubit>(() => ProductGetAllCubit(sl()));
  sl.registerFactory<OrderGetAllSalesOrdersCubit>(
    () => OrderGetAllSalesOrdersCubit(usecase: sl()),
  );

  // Delivery Order
  sl.registerFactory<DeliveryOrderGetAllCubit>(
    () => DeliveryOrderGetAllCubit(getAllDeliveryOrders: sl()),
  );
  sl.registerFactory<RecordPaymentCubit>(
    () => RecordPaymentCubit(recordSalesPayment: sl()),
  );

  // Chat
  sl.registerFactory<ChatListCubit>(
    () => ChatListCubit(getConversationsUseCase: sl()),
  );
  sl.registerFactory<ChatRoomCubit>(
    () => ChatRoomCubit(
      getMessagesUseCase: sl(),
      getThreadMessagesUseCase: sl(),
      sendMessageUseCase: sl(),
      markMessagesAsReadUseCase: sl(),
      connectWebSocketUseCase: sl(),
      disconnectWebSocketUseCase: sl(),
    ),
  );
  sl.registerFactory<ChatSearchUserCubit>(
    () => ChatSearchUserCubit(searchUsersUseCase: sl()),
  );

  // Inventory
  sl.registerFactory<IncidentalReportCubit>(() => IncidentalReportCubit(sl()));
  sl.registerFactory<IncidentalReportFormCubit>(
    () => IncidentalReportFormCubit(sl(), sl()),
  );

  // KPI
  sl.registerFactory<MyKpiCubit>(
    () =>
        MyKpiCubit(logger: sl(), getMyAssignments: sl(), acknowledgeKpi: sl()),
  );
  sl.registerFactory<TeamKpiCubit>(
    () => TeamKpiCubit(
      logger: sl(),
      getTeamAssignments: sl(),
      getTeamSummary: sl(),
    ),
  );
  sl.registerFactory<SelfAssessmentCubit>(
    () => SelfAssessmentCubit(
      logger: sl(),
      getDetail: sl(),
      submitSelfAssessment: sl(),
    ),
  );
  sl.registerFactory<KpiReviewCubit>(
    () => KpiReviewCubit(
      logger: sl(),
      getDetail: sl(),
      submitManagerReview: sl(),
    ),
  );

  // Announcement
  sl.registerFactory<AnnouncementCubit>(
    () => AnnouncementCubit(logger: sl(), getAnnouncementsUseCase: sl()),
  );

  // Chat Create Group
  sl.registerFactory<ChatCreateGroupCubit>(
    () => ChatCreateGroupCubit(
      searchUsersUseCase: sl(),
      createConversationUseCase: sl(),
    ),
  );

  // Email
  sl.registerFactory<EmailListCubit>(
    () => EmailListCubit(
      getAllEmailUsecase: sl(),
      getUnreadEmailCountUseCase: sl(),
      readEmailUsecase: sl(),
    ),
  );

  // Loan
  sl.registerFactory<LoanListCubit>(
    () => LoanListCubit(logger: sl(), getEmployeeLoansUseCase: sl()),
  );
  sl.registerFactory<LoanFormCubit>(
    () => LoanFormCubit(createEmployeeLoanUseCase: sl()),
  );

  // Van Stock
  sl.registerFactory<VanStockCubit>(
    () =>
        VanStockCubit(logger: sl(), getVanStockList: sl(), getUserLocal: sl()),
  );
}

void _useCase() {
  // Global
  sl.registerLazySingleton(() => GlobalGetVersion(sl()));
  sl.registerLazySingleton(() => GlobalPostTokenFcm(sl()));
  // Login
  sl.registerLazySingleton(() => LoginSignIn(sl()));
  sl.registerLazySingleton(() => LoginRegister(sl()));
  sl.registerLazySingleton(() => LoginCheckEmailAvailable(sl()));
  sl.registerLazySingleton(() => LoginCheckUsernameAvailable(sl()));
  sl.registerLazySingleton(
    () => LoginCheck(loginRepository: sl(), userRepository: sl()),
  );
  sl.registerLazySingleton(
    () => LoginSignOut(authRepository: sl(), globalRepository: sl()),
  );
  // User
  sl.registerLazySingleton(() => UserGetLocal(sl()));
  sl.registerLazySingleton(() => UserGetData(sl()));
  sl.registerLazySingleton(() => UserPost(sl()));
  sl.registerLazySingleton(() => UserPostAccount(sl()));
  sl.registerLazySingleton(() => UserPostImage(sl()));
  sl.registerLazySingleton(() => UserDeleteImage(sl()));
  sl.registerLazySingleton(() => UserGetAllInventaris(sl()));
  sl.registerLazySingleton(() => GetUserById(repository: sl()));
  sl.registerLazySingleton(() => GetUsers(repository: sl()));
  sl.registerLazySingleton(() => GetCurrentUser(repository: sl()));

  // Auth
  sl.registerLazySingleton(() => GetAuthSession(repository: sl()));

  // Presensi
  sl.registerLazySingleton(() => PresensiGetAllData(sl()));
  sl.registerLazySingleton(() => PresensiGetOne(sl()));

  sl.registerLazySingleton(() => CheckIn(repository: sl()));
  sl.registerLazySingleton(() => CheckOut(repository: sl()));
  sl.registerLazySingleton(() => BreakIn(repository: sl()));
  sl.registerLazySingleton(() => BreakOut(repository: sl()));

  // Leaves
  sl.registerLazySingleton(() => GetLeaveRequests(repository: sl()));
  sl.registerLazySingleton(() => GetLeaveCategories(repository: sl()));
  sl.registerLazySingleton(() => GetLeaveRequestById(repository: sl()));
  sl.registerLazySingleton(() => CreateLeaveRequest(repository: sl()));

  // Tasks
  sl.registerLazySingleton(() => TasksGetAllData(sl()));
  sl.registerLazySingleton(() => TasksPostData(sl()));
  sl.registerLazySingleton(() => TasksGetAllApotek(sl()));
  sl.registerLazySingleton(() => TasksPostCompleted(sl()));
  sl.registerLazySingleton(() => TasksPostCanceled(sl()));
  sl.registerLazySingleton(() => TasksGetAllPerjalanan(sl()));
  // Apotek
  sl.registerLazySingleton(() => ApotekGetAllData(sl()));
  sl.registerLazySingleton(() => ApotekPostData(sl()));
  sl.registerLazySingleton(() => ApotekGetQuery(sl()));
  sl.registerLazySingleton(() => ApotekPostQuery(sl()));

  // Order
  sl.registerLazySingleton(() => OrderCreateSalesOrder(sl()));
  sl.registerLazySingleton(() => OrderGetAllProducts(sl()));
  sl.registerLazySingleton(() => OrderGetAllSalesOrdersUsecase(sl()));
  sl.registerLazySingleton(() => RecordSalesPayment(sl()));

  // Delivery Order
  sl.registerLazySingleton(() => GetAllDeliveryOrders(sl()));

  // Chat
  sl.registerLazySingleton(() => ChatGetConversationsUseCase(repository: sl()));
  sl.registerLazySingleton(() => ChatGetMessagesUseCase(repository: sl()));
  sl.registerLazySingleton(
    () => ChatGetThreadMessagesUseCase(repository: sl()),
  );
  sl.registerLazySingleton(() => ChatSearchUsersUseCase(repository: sl()));
  sl.registerLazySingleton(
    () => ChatGetOrCreatePrivateConversationUseCase(repository: sl()),
  );
  sl.registerLazySingleton(() => ChatSendMessageUseCase(repository: sl()));
  sl.registerLazySingleton(
    () => ChatMarkMessagesAsReadUseCase(repository: sl()),
  );
  sl.registerLazySingleton(() => ChatConnectWebSocketUseCase(repository: sl()));
  sl.registerLazySingleton(
    () => ChatDisconnectWebSocketUseCase(repository: sl()),
  );
  sl.registerLazySingleton(
    () => ChatCreateConversationUseCase(repository: sl()),
  );

  // Email
  sl.registerLazySingleton(() => GetAllEmailUsecase(sl()));
  sl.registerLazySingleton(() => CountUnreadEmailUsecase(repository: sl()));
  sl.registerLazySingleton(() => ReadEmailUsecase(sl()));

  // Inventory
  sl.registerLazySingleton(() => GetIncidentalReportsUseCase(sl()));
  sl.registerLazySingleton(() => AddIncidentalReportUseCase(sl()));
  sl.registerLazySingleton(() => GetInventarisUmumUseCase(sl()));
  sl.registerLazySingleton(() => GetInventoryLocationBalancesUseCase(sl()));

  // Loan
  sl.registerLazySingleton(() => GetEmployeeLoans(sl()));
  sl.registerLazySingleton(() => CreateEmployeeLoan(sl()));

  // KPI
  sl.registerLazySingleton(() => GetMyKpiAssignments(repository: sl()));
  sl.registerLazySingleton(() => GetTeamKpiAssignments(repository: sl()));
  sl.registerLazySingleton(() => GetTeamKpiSummary(repository: sl()));
  sl.registerLazySingleton(() => GetKpiAssignmentDetail(repository: sl()));
  sl.registerLazySingleton(() => SubmitSelfAssessment(repository: sl()));
  sl.registerLazySingleton(() => SubmitManagerReview(repository: sl()));
  sl.registerLazySingleton(() => AcknowledgeKpiUseCase(repository: sl()));

  // Van Stock
  sl.registerLazySingleton(() => GetVanStockList(sl()));
  sl.registerLazySingleton(() => GetVanStockSummary(sl()));

  // Attendance
  sl.registerLazySingleton(() => GetActiveAttendance(repository: sl()));
  sl.registerLazySingleton(() => GetEffectiveScheduleToday(repository: sl()));
  sl.registerLazySingleton(() => GetAttendances(repository: sl()));
  sl.registerLazySingleton(() => GetAttendanceById(repository: sl()));
  sl.registerLazySingleton(
    () => GetMyAttendances(repository: sl(), userRepository: sl()),
  );
  sl.registerLazySingleton(() => GetAttendanceStatistics(repository: sl()));
  sl.registerLazySingleton(() => GetHomeAlertUseCase(sl()));

  // Attendance Request
  sl.registerLazySingleton(() => GetAttendanceRequests(repository: sl()));
  sl.registerLazySingleton(() => CreateAttendanceRequest(repository: sl()));

  // Approval
  sl.registerLazySingleton(() => CreateApproval(repository: sl()));
  sl.registerLazySingleton(() => GetMyPendingApprovals(repository: sl()));
  sl.registerLazySingleton(() => TestWorkflowUserUseCase(sl()));

  // Shift
  sl.registerLazySingleton(() => CreateShiftSwapRequest(repository: sl()));
  sl.registerLazySingleton(
    () => CreateShiftSwapRequestApproval(repository: sl()),
  );
  sl.registerLazySingleton(() => GetAvailableShiftsForSwap(repository: sl()));
  sl.registerLazySingleton(() => GetShiftScheduleById(repository: sl()));
  sl.registerLazySingleton(() => GetShiftSchedules(repository: sl()));
  sl.registerLazySingleton(() => GetShiftSwapRequests(repository: sl()));
  sl.registerLazySingleton(() => GetMyShiftSchedules(repository: sl()));
  sl.registerLazySingleton(() => GetMyShiftSwapRequests(repository: sl()));

  // Overtime
  sl.registerLazySingleton(() => GetOvertimeRequests(repository: sl()));
  sl.registerLazySingleton(() => GetOvertimeRequestById(repository: sl()));
  sl.registerLazySingleton(() => CreateOvertimeRequest(repository: sl()));
  sl.registerLazySingleton(() => UpdateOvertimeRequest(repository: sl()));
  sl.registerLazySingleton(() => DeleteOvertimeRequest(repository: sl()));
  sl.registerLazySingleton(() => GetActiveOvertimeSession(repository: sl()));
  sl.registerLazySingleton(() => StartOvertimeSession(repository: sl()));
  sl.registerLazySingleton(() => FinishOvertimeSession(repository: sl()));
  sl.registerLazySingleton(() => CancelOvertimeSession(repository: sl()));

  // Payroll
  sl.registerLazySingleton(() => GetPayrollSlips(repository: sl()));
  sl.registerLazySingleton(() => GetPayrollSlipById(repository: sl()));
  sl.registerLazySingleton(() => DownloadPayrollSlipPdf(repository: sl()));

  // Notification
  sl.registerLazySingleton(() => GetUnreadNotificationsCount(repository: sl()));
  sl.registerLazySingleton(() => GetNotifications(repository: sl()));
  sl.registerLazySingleton(() => MarkNotificationAsReadById(repository: sl()));
  sl.registerLazySingleton(() => DeleteNotificationById(repository: sl()));

  // Setting
  sl.registerLazySingleton(() => GetSettingByOrganizationId(repository: sl()));

  // Announcement
  sl.registerLazySingleton(() => GetAnnouncements(repository: sl()));

  // Survey
  sl.registerLazySingleton(() => GetMySurveys(repository: sl()));

  // Reimbursement
  sl.registerLazySingleton(() => GetReimbursements(repository: sl()));
  sl.registerLazySingleton(
    () => GetMyReimbursements(repository: sl(), userRepository: sl()),
  );
  sl.registerLazySingleton(() => GetReimbursementById(repository: sl()));
  sl.registerLazySingleton(() => GetReimbursementCategories(repository: sl()));
  sl.registerLazySingleton(() => CreateReimbursement(repository: sl()));
}

void _repository() {
  // Global
  sl.registerLazySingleton<GlobalRepository>(
    () => GlobalRepositoryImpl(
      loginLocalDatasource: sl(),
      globalLocalDatasource: sl(),
      globalRemoteDatasource: sl(),
      log: sl(),
    ),
  );
  // Login
  sl.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(
      remoteDatasource: sl(),
      localDatasource: sl(),
      log: sl(),
    ),
  );
  // User
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDatasource: sl(),
      localDatasource: sl(),
      log: sl(),
      networkInfo: sl(),
      mapper: sl(),
    ),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      mapper: sl(),
      loginLocalDatasource: sl(),
      logger: sl(),
    ),
  );

  // Presensi
  sl.registerLazySingleton<PresensiRepository>(
    () =>
        PresensiRepositoryImpl(remoteDatasource: sl(), mapper: sl(), log: sl()),
  );

  // Tasks
  sl.registerLazySingleton<TasksRepository>(
    () => TasksRepositoryImpl(remoteDatasource: sl(), log: sl()),
  );

  // Sales Target & Task Report
  sl.registerLazySingleton<SalesTargetRepository>(
    () => SalesTargetRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<TaskReportRepository>(
    () => TaskReportRepositoryImpl(sl()),
  );

  // Order
  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(
      remoteDatasource: sl(),
      networkInfo: sl(),
      localCacheService: sl(),
    ),
  );

  // Delivery Order
  sl.registerLazySingleton<DeliveryOrderRepository>(
    () => DeliveryOrderRepositoryImpl(datasource: sl()),
  );

  // Chat
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(remoteDataSource: sl()),
  );

  // Email
  sl.registerLazySingleton<EmailRepository>(
    () => EmailRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Inventory
  sl.registerLazySingleton<InventoryRepository>(
    () => InventoryRepositoryImpl(remoteDataSource: sl(), logger: sl()),
  );

  // KPI
  sl.registerLazySingleton<KpiRepository>(
    () => KpiRepositoryImpl(datasource: sl(), mapper: sl(), logger: sl()),
  );

  // Van Stock
  sl.registerLazySingleton<VanStockRepository>(
    () => VanStockRepositoryImpl(datasource: sl(), logger: sl()),
  );

  // Loan
  sl.registerLazySingleton<LoanRepository>(
    () => LoanRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  // Apotek
  sl.registerLazySingleton<ApotekRepository>(
    () => ApotekRepositoryImpl(
      remoteDatasource: sl(),
      log: sl(),
      networkInfo: sl(),
      localCacheService: sl(),
    ),
  );

  sl.registerLazySingleton<AttendanceRepository>(
    () => AttendanceRepositoryImpl(
      remoteDatasource: sl(),
      loginLocalDatasource: sl(),
      mapper: sl(),
      logger: sl(),
    ),
  );

  sl.registerLazySingleton<AttendanceRequestRepository>(
    () => AttendanceRequestRepositoryImpl(
      remoteDatasource: sl(),
      loginLocalDatasource: sl(),
      mapper: sl(),
      logger: sl(),
    ),
  );

  sl.registerLazySingleton<ApprovalRepository>(
    () => ApprovalRepositoryImpl(
      remoteDatasource: sl(),
      mapper: sl(),
      logger: sl(),
    ),
  );

  sl.registerLazySingleton<LeaveRepository>(
    () => LeaveRepositoryImpl(logger: sl(), mapper: sl(), datasource: sl()),
  );

  sl.registerLazySingleton<ShiftRepository>(
    () => ShiftRepositoryImpl(
      logger: sl(),
      mapper: sl(),
      remoteDatasource: sl(),
      loginLocalDatasource: sl(),
    ),
  );

  sl.registerLazySingleton<OvertimeRepository>(
    () => OvertimeRepositoryImpl(
      logger: sl(),
      mapper: sl(),
      remoteDatasource: sl(),
      loginLocalDatasource: sl(),
    ),
  );

  sl.registerLazySingleton<PayrollRepository>(
    () => PayrollRepositoryImpl(
      logger: sl(),
      mapper: sl(),
      remoteDatasource: sl(),
      loginLocalDatasource: sl(),
    ),
  );

  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(
      logger: sl(),
      mapper: sl(),
      remoteDatasource: sl(),
    ),
  );

  sl.registerLazySingleton<SettingRepository>(
    () => SettingRepositoryImpl(
      logger: sl(),
      mapper: sl(),
      remoteDatasource: sl(),
      loginLocalDatasource: sl(),
    ),
  );

  sl.registerLazySingleton<AnnouncementRepository>(
    () => AnnouncementRepositoryImpl(
      logger: sl(),
      mapper: sl(),
      remoteDatasource: sl(),
    ),
  );

  sl.registerLazySingleton<SurveyRepository>(
    () => SurveyRepositoryImpl(
      logger: sl(),
      mapper: sl(),
      remoteDatasource: sl(),
    ),
  );

  sl.registerLazySingleton<ReimbursementRepository>(
    () => ReimbursementRepositoryImpl(
      remoteDatasource: sl(),
      mapper: sl(),
      logger: sl(),
    ),
  );
}

void _dataSource() {
  // Global
  sl.registerLazySingleton<GlobalRemoteDatasource>(
    () => GlobalRemoteDatasourceImpl(sl()),
  );
  // Global
  sl.registerLazySingleton<GlobalLocalDatasource>(
    () => GlobalLocalDatasourceImpl(),
  );
  // Login
  sl.registerLazySingleton<LoginRemoteDatasource>(
    () => LoginRemoteDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<LoginLocalDatasource>(
    () => LoginLocalDatasourceImpl(),
  );
  // User
  sl.registerLazySingleton<UserRemoteDatasource>(
    () => UserRemoteDatasourceImpl(sl(), logger: sl()),
  );
  // Presensi
  sl.registerLazySingleton<PresensiRemoteDatasource>(
    () => PresensiRemoteDatasourceImpl(logger: sl(), graphQlService: sl()),
  );

  // Leave
  sl.registerLazySingleton<LeaveRemoteDatasource>(
    () => LeaveRemoteDatasourceImpl(gql: sl(), logger: sl()),
  );
  // Tasks
  sl.registerLazySingleton<TasksRemoteDatasource>(
    () => TasksRemoteDatasourceImpl(sl()),
  );

  // Sales Target & Task Report
  sl.registerLazySingleton<SalesTargetRemoteDatasource>(
    () => SalesTargetRemoteDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<TaskReportRemoteDatasource>(
    () => TaskReportRemoteDatasourceImpl(sl()),
  );

  // Order
  sl.registerLazySingleton<OrderRemoteDatasource>(
    () => OrderRemoteDatasourceImpl(graphQlService: sl()),
  );

  // Chat
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(graphQlService: sl()),
  );

  // Inventory
  sl.registerLazySingleton<InventoryRemoteDataSource>(
    () => InventoryRemoteDataSourceImpl(graphQLService: sl(), logger: sl()),
  );
  // Apotek
  sl.registerLazySingleton<ApotekRemoteDatasource>(
    () => ApotekRemoteDatasourceImpl(sl()),
  );

  sl.registerLazySingleton<AttendanceRemoteDatasource>(
    () => AttendanceRemoteDatasourceImpl(gql: sl(), logger: sl()),
  );

  sl.registerLazySingleton<AttendanceRequestRemoteDatasource>(
    () => AttendanceRequestRemoteDatasourceImpl(gql: sl(), logger: sl()),
  );

  sl.registerLazySingleton<ApprovalRemoteDatasource>(
    () => ApprovalRemoteDatasourceImpl(gql: sl(), logger: sl()),
  );

  sl.registerLazySingleton<ShiftRemoteDatasource>(
    () => ShiftRemoteDatasourceImpl(gql: sl(), logger: sl()),
  );

  sl.registerLazySingleton<OvertimeRemoteDatasource>(
    () => OvertimeRemoteDatasourceImpl(gql: sl(), logger: sl()),
  );

  sl.registerLazySingleton<PayrollRemoteDatasource>(
    () => PayrollRemoteDatasourceImpl(gql: sl(), logger: sl()),
  );

  sl.registerLazySingleton<NotificationRemoteDatasource>(
    () => NotificationRemoteDatasourceImpl(gql: sl(), logger: sl()),
  );

  sl.registerLazySingleton<SettingRemoteDatasource>(
    () => SettingRemoteDatasourceImpl(gql: sl(), logger: sl()),
  );

  sl.registerLazySingleton<AnnouncementRemoteDatasource>(
    () => AnnouncementRemoteDatasourceImpl(gql: sl(), logger: sl()),
  );

  sl.registerLazySingleton<SurveyRemoteDatasource>(
    () => SurveyRemoteDatasourceImpl(gql: sl(), logger: sl()),
  );

  sl.registerLazySingleton<ReimbursementRemoteDatasource>(
    () => ReimbursementRemoteDatasourceImpl(gql: sl(), logger: sl()),
  );

  sl.registerLazySingleton<KalenderRemoteDatasource>(
    () => KalenderRemoteDatasourceImpl(gql: sl()),
  );

  sl.registerLazySingleton<LogbookRemoteDatasource>(
    () => LogbookRemoteDatasourceImpl(gql: sl()),
  );

  // Email
  sl.registerLazySingleton<EmailRemoteDataSource>(
    () => EmailRemoteDataSourceImpl(graphQlService: sl()),
  );

  // KPI
  sl.registerLazySingleton<KpiRemoteDatasource>(
    () => KpiRemoteDatasourceImpl(gql: sl()),
  );

  // Loan
  sl.registerLazySingleton<LoanRemoteDataSource>(
    () => LoanRemoteDataSourceImpl(sl()),
  );

  // Van Stock
  sl.registerLazySingleton<VanStockRemoteDatasource>(
    () => VanStockRemoteDatasourceImpl(gql: sl()),
  );

  // Delivery Order
  sl.registerLazySingleton<DeliveryOrderRemoteDatasource>(
    () => DeliveryOrderRemoteDatasourceImpl(graphQlService: sl()),
  );
}
