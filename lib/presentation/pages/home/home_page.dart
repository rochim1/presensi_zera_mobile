import 'package:action_slider/action_slider.dart';
import 'package:auto_route/auto_route.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_cubit.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_state.dart';
import 'package:presensi_mobile/presentation/pages/home/bloc/home_state.dart';
import 'package:presensi_mobile/presentation/pages/logbook/bloc/logbook_cubit.dart';
import 'package:presensi_mobile/core/_core.dart';

import '../../_presentation.dart';
import 'bloc/home_cubit.dart';
import 'widgets/_widgets.dart';

part 'widgets/home_panel.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<HomeCubit>()..init()),
        BlocProvider(
          create: (_) =>
              LogbookCubit(remoteDatasource: sl<LogbookRemoteDatasource>())
                ..fetchLogbooks(),
        ),
      ],
      child: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late ActionSliderController attendanceSliderController =
      ActionSliderController();
  final scrollController = ScrollController();
  bool _isStartingOvertime = false;

  @override
  void dispose() {
    attendanceSliderController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  Future<void> onTapCheckIn() async {
    if (!await ensureAttendanceSettingAvailable(context) || !mounted) return;
    await context.router.push(const CheckInPageRoute());
  }

  Future<void> onTapCheckOut() async {
    if (!await ensureAttendanceSettingAvailable(context) || !mounted) return;
    await context.router.push(const CheckOutPageRoute());
  }

  void onRefresh() async {
    await Future.wait([
      context.read<AppCubit>().onRefresh(),
      context.read<HomeCubit>().onRefresh(),
      context.read<LogbookCubit>().fetchLogbooks(),
      context.read<TasksGetAllPendingCubit>().initLoadAllData(),
      context.read<TasksGetAllPerjalananCubit>().initLoadAllData(),
    ]);
  }

  bool _canCheckInAfterCheckout(AppState appState) {
    final setting = appState.setting.data;
    if (setting == null) return true;

    return setting.allowShiftAttendance ||
        (setting.allowOnCallAttendance && setting.allowOnCallAfterCheckout);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, appState) {
        return BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: const Color(0xFFF5F7F9),
              body: Stack(
                children: [
                  AppSmartRefresher(
                    onRefresh: () async => onRefresh(),
                    scrollController: scrollController,
                    child: SingleChildScrollView(
                      child: Stack(
                        children: [
                          _buildGradientHeader(),
                          SafeArea(
                            child: LayoutBuilder(
                              builder: (context, constraints) =>
                                  _buildResponsiveHomeContent(
                                    context,
                                    constraints,
                                    appState,
                                    state,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: AppRevealHeader(
                      controller: scrollController,
                      triggerOffset: AppDimens.h128,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(AppImages.geometricBg),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: SafeArea(
                              child: Center(
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 1440,
                                  ),
                                  child: _buildHeaderSection(appState, state),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildResponsiveHomeContent(
    BuildContext context,
    BoxConstraints constraints,
    AppState appState,
    HomeState state,
  ) {
    final isDesktop = constraints.maxWidth >= 1024;
    final horizontalPadding = isDesktop ? 24.0 : 16.0;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1440),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            children: [
              _buildHeaderSection(appState, state),
              const SizedBox(height: 16),
              if (isDesktop)
                _buildDesktopDashboard(context, appState, state)
              else
                _buildMobileDashboard(context, appState, state),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopDashboard(
    BuildContext context,
    AppState appState,
    HomeState state,
  ) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 7, child: _buildAttendanceCard(context, appState)),
            const SizedBox(width: 16),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const UnsyncedDataBanner(),
                  HomeFeatureGrid(isLoading: appState.user.isLoading),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 320,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(flex: 7, child: AnnouncementSection(state: state)),
              const SizedBox(width: 16),
              const Expanded(flex: 5, child: HomeLogbookCard()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileDashboard(
    BuildContext context,
    AppState appState,
    HomeState state,
  ) {
    return Column(
      children: [
        _buildAttendanceCard(context, appState),
        const SizedBox(height: 16),
        const UnsyncedDataBanner(),
        HomeFeatureGrid(isLoading: appState.user.isLoading),
        const SizedBox(height: 16),
        AnnouncementSection(state: state),
        const SizedBox(height: 16),
        const HomeLogbookCard(),
      ],
    );
  }

  Widget _buildHeaderSection(AppState appState, HomeState state) {
    return HeaderSection(
      isLoading: appState.user.isLoading,
      notificationBadgeCount: state.notificationCount.maybeWhen(
        orElse: () => null,
        success: (v) => v,
      ),
      chatBadgeCount: () {
        final chatCount = state.unreadChatCount.maybeWhen(
          orElse: () => 0,
          success: (v) => v,
        );
        final emailCount = state.unreadEmailCount.maybeWhen(
          orElse: () => 0,
          success: (v) => v,
        );
        final total = chatCount + emailCount;
        return total > 0 ? total : null;
      }(),
      user: appState.user.maybeWhen(orElse: () => null, success: (v) => v),
    );
  }

  Widget _buildGradientHeader() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [Image.asset(AppImages.geometricBg, fit: BoxFit.cover)],
        ),
      ),
    );
  }

  Widget _buildAttendanceCard(BuildContext context, AppState appState) {
    void onSliderAction() {
      appState.activeAttendance.maybeWhen(
        success: (value) {
          if (value.status.isKerja) {
            context.read<HomeCubit>().breakIn();
          }
          if (value.status.isIstirahat) {
            context.read<HomeCubit>().breakOut();
          }
        },
        orElse: () => {},
      );
    }

    final activeAttendance = appState.activeAttendance.maybeWhen(
      success: (value) => value,
      orElse: () => null,
    );

    String getSliderText() {
      return activeAttendance?.status.isIstirahat == true
          ? 'Geser untuk Kerja'
          : 'Geser untuk Istirahat';
    }

    String getActionButtonLabelText() {
      if (appState.isOvertimeActive) return 'Akhiri Lembur';

      final isCompleted =
          activeAttendance != null && activeAttendance.jamPulang != null;
      if (activeAttendance != null && !isCompleted) return 'Check Out';

      if (appState.canStartOvertime) {
        return _canCheckInAfterCheckout(appState) ? 'Check In' : 'Mulai Lembur';
      }

      if (isCompleted) {
        return _canCheckInAfterCheckout(appState) ? 'Check In' : 'Mulai Lembur';
      }

      return activeAttendance == null ? 'Check In' : 'Check Out';
    }

    String? getSecondaryActionButtonLabelText() {
      if (appState.isOvertimeActive) return null;

      final isCompleted =
          activeAttendance != null && activeAttendance.jamPulang != null;
      if (activeAttendance != null && !isCompleted) return null;

      if (appState.canStartOvertime && _canCheckInAfterCheckout(appState)) {
        return 'Mulai Lembur';
      }

      if (isCompleted && _canCheckInAfterCheckout(appState)) {
        return 'Mulai Lembur';
      }

      return null;
    }

    Future<void> startOvertimeWithFeedback(AppCubit appCubit) async {
      if (_isStartingOvertime) return;

      setState(() => _isStartingOvertime = true);

      try {
        final errorMessage = await appCubit.startOvertime();
        if (!context.mounted) return;

        if (errorMessage == null) {
          AppSnackbar.showSuccess(context, 'Lembur dimulai');
        } else {
          AppBottomSheet.showError(
            context: context,
            titleText: 'Gagal',
            message: errorMessage,
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isStartingOvertime = false);
        }
      }
    }

    void onTapActionButton() async {
      final appCubit = context.read<AppCubit>();

      if (appState.isOvertimeActive) {
        // Akhiri Lembur
        _showAkhiriLemburBottomSheet(context, appCubit);
        return;
      }

      final isCompleted =
          activeAttendance != null && activeAttendance.jamPulang != null;
      if (activeAttendance != null && !isCompleted) {
        await onTapCheckOut();
        await appCubit.onRefresh();

        final nowHasAttendance = appCubit.state.activeAttendance.data != null;
        if (!nowHasAttendance) {
          appCubit.markCheckedOutToday();
        }
        return;
      }

      if (appState.canStartOvertime) {
        if (_canCheckInAfterCheckout(appState)) {
          await onTapCheckIn();
        } else {
          // Mulai Lembur
          await startOvertimeWithFeedback(appCubit);
        }
        return;
      }

      if (activeAttendance == null) {
        await onTapCheckIn();
        return;
      }

      await onTapCheckOut();
      await appCubit.onRefresh();

      final nowHasAttendance = appCubit.state.activeAttendance.data != null;
      if (!nowHasAttendance) {
        appCubit.markCheckedOutToday();
      }
    }

    void onTapSecondaryActionButton() async {
      await startOvertimeWithFeedback(context.read<AppCubit>());
    }

    return BlocConsumer<HomeCubit, HomeState>(
      listenWhen: (prev, current) =>
          prev.breakIn != current.breakIn || prev.breakOut != current.breakOut,
      listener: (context, state) {
        state.breakIn.maybeWhen(
          loading: () {
            attendanceSliderController.loading();
          },
          success: (_) async {
            AppSnackbar.showSuccess(context, 'Istirahat dimulai');
            attendanceSliderController.success();
            context.read<AppCubit>().onRefresh();

            await Future.delayed(const Duration(milliseconds: 1500));
            attendanceSliderController.reset();
          },
          failure: (v) async {
            AppBottomSheet.showError(
              context: context,
              titleText: 'Gagal Memulai Istirahat',
              message: v.message,
            );
            attendanceSliderController.failure();
            await Future.delayed(const Duration(milliseconds: 1500));
            attendanceSliderController.reset();
          },
          orElse: () {},
        );

        state.breakOut.maybeWhen(
          loading: () {
            attendanceSliderController.loading();
          },
          success: (_) {
            AppSnackbar.showSuccess(context, 'Istirahat selesai');
            attendanceSliderController.success();
            context.read<AppCubit>().onRefresh();

            Future.delayed(const Duration(seconds: 1), () {
              attendanceSliderController.reset();
            });
          },
          failure: (v) {
            AppBottomSheet.showError(
              context: context,
              titleText: 'Gagal Menyelesaikan Istirahat',
              message: v.message,
            );
            attendanceSliderController.failure();
            Future.delayed(const Duration(seconds: 1), () {
              attendanceSliderController.reset();
            });
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        return HomeAttendanceCard(
          isLoading: appState.user.isLoading,
          attendance: activeAttendance,
          effectiveSchedule: appState.effectiveSchedule.data,
          onTapActionButton: onTapActionButton,
          onTapSecondaryActionButton:
              getSecondaryActionButtonLabelText() != null
              ? onTapSecondaryActionButton
              : null,
          actionButtonLabel: getActionButtonLabelText(),
          secondaryActionButtonLabel: getSecondaryActionButtonLabelText(),
          overtimeStartTime: appState.overtimeStartTime,
          isStartingOvertime: _isStartingOvertime,
          sliderController: attendanceSliderController,
          sliderText: getSliderText(),
          setting: appState.setting.data,
          hasCheckedOutToday: appState.hasCheckedOutToday,
          onSliderAction: activeAttendance != null
              ? (controller) async => onSliderAction()
              : null,
        );
      },
    );
  }

  void _showAkhiriLemburBottomSheet(BuildContext context, AppCubit appCubit) {
    final TextEditingController reasonController = TextEditingController();
    final isAttachmentRequired =
        appCubit.state.setting.data?.isMandatorySupportingEvidence ?? false;
    List<PlatformFile> attachments = [];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Akhiri Lembur',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text('Alasan Lembur (Opsional)'),
                const SizedBox(height: 8),
                TextField(
                  controller: reasonController,
                  decoration: const InputDecoration(
                    hintText: 'Tuliskan alasan/kegiatan lembur...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                AppAttachmentField(
                  label: 'Bukti Pendukung',
                  isRequired: isAttachmentRequired,
                  hintText: 'Tambahkan foto atau dokumen pendukung',
                  value: attachments.map((file) => file.name).join(', '),
                  onDelete: () => setSheetState(() => attachments = []),
                  onTap: () async {
                    final result = await AppUtility.fileAttachment(
                      false,
                      const ['jpg', 'jpeg', 'png', 'pdf'],
                      FileType.custom,
                    );
                    if (result.isEmpty || !ctx.mounted) return;
                    setSheetState(() => attachments = [result.first]);
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (isAttachmentRequired && attachments.isEmpty) {
                        AppSnackbar.showError(
                          context,
                          'Bukti pendukung wajib diunggah',
                        );
                        return;
                      }

                      final reason = reasonController.text.trim().isEmpty
                          ? 'Lembur setelah presensi pulang'
                          : reasonController.text.trim();
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) =>
                            const Center(child: CircularProgressIndicator()),
                      );
                      final errorMessage = await appCubit.finishOvertime(
                        reason,
                        attachmentPaths: attachments
                            .map((file) => file.path)
                            .whereType<String>()
                            .toList(),
                      );
                      if (!context.mounted) return;
                      Navigator.pop(context); // close dialog
                      if (errorMessage == null) {
                        Navigator.pop(ctx); // close bottom sheet
                        AppSnackbar.showSuccess(
                          context,
                          'Berhasil mencatat lembur',
                        );
                      } else {
                        AppBottomSheet.showError(
                          context: context,
                          titleText: 'Gagal',
                          message: errorMessage,
                        );
                      }
                    },
                    child: const Text('Simpan Lembur'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                    onPressed: () async {
                      final shouldCancel = await showDialog<bool>(
                        context: context,
                        builder: (dialogContext) {
                          return AlertDialog(
                            title: const Text('Batalkan Lembur?'),
                            content: const Text(
                              'Mode lembur akan dihentikan tanpa menyimpan request lembur.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(dialogContext, false),
                                child: const Text('Tidak'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(dialogContext, true),
                                child: const Text('Ya, Batalkan'),
                              ),
                            ],
                          );
                        },
                      );

                      if (shouldCancel != true) return;

                      final errorMessage = await appCubit.cancelOvertime();
                      if (!mounted || !ctx.mounted) return;
                      if (errorMessage == null) {
                        Navigator.pop(ctx);
                        AppSnackbar.showSuccess(context, 'Lembur dibatalkan');
                      } else {
                        AppBottomSheet.showError(
                          context: context,
                          titleText: 'Gagal',
                          message: errorMessage,
                        );
                      }
                    },
                    child: const Text('Batalkan Lembur'),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}
