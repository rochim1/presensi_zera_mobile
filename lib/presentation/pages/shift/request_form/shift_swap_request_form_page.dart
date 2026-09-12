import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

@RoutePage()
class ShiftSwapRequestFormPage extends StatelessWidget {
  final String shiftScheduleId;
  final ShiftSwapRequest? request;

  const ShiftSwapRequestFormPage({
    super.key,
    required this.shiftScheduleId,
    this.request,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ShiftSwapRequestFormCubit>()
        ..setShiftScheduleId(shiftScheduleId)
        ..init(request),
      child: const ShiftSwapRequestFormView(),
    );
  }
}

class ShiftSwapRequestFormView extends StatelessWidget {
  const ShiftSwapRequestFormView({super.key});

  String _targetShiftScheduleLabel(AvailableShiftForSwap value) {
    final assignedDate =
        value.currentShift.assignedDate?.format(pattern: 'dd MMM yyyy') ?? '-';
    final jamMasuk =
        value.currentShift.shift.jamMasuk?.format(pattern: 'HH:mm') ?? '--:--';
    final jamPulang =
        value.currentShift.shift.jamPulang?.format(pattern: 'HH:mm') ?? '--:--';
    return '${value.user.name} • $assignedDate • ${value.currentShift.shift.name} ($jamMasuk - $jamPulang)';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShiftSwapRequestFormCubit, ShiftSwapRequestFormState>(
      listenWhen: (prev, curr) => prev.submit != curr.submit,
      listener: (context, state) {
        state.submit.maybeWhen(
          orElse: () {},
          success: (_) {
            AppSnackbar.showSuccess(
              context,
              'submit request tukar shift berhasil',
            );
            context.pop(true);
          },
          failure: (e) {
            AppSnackbar.showError(
              context,
              'Gagal mengirim request tukar shift: $e',
            );
          },
        );

        state.shiftSchedule.maybeWhen(
          orElse: () {},
          failure: (e) =>
              AppSnackbar.showError(context, 'Gagal memuat jadwal shift: $e'),
        );
      },
      builder: (context, state) {
        final cubit = context.read<ShiftSwapRequestFormCubit>();
        final shiftSchedule = state.shiftSchedule.data;

        return Scaffold(
          backgroundColor: const Color(0xFFF5F7F9),
          body: Stack(
            children: [
              Container(
                height: 220,
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
                  child: Image.asset(AppImages.geometricBg, fit: BoxFit.cover),
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    AppTopBar(
                      title: 'Ajukan Tukar Shift',
                      useGradient: false,
                      backgroundColor: Colors.transparent,
                      titleColor: AppColors.white,
                    ),
                    Expanded(
                      child: AppSmartRefresher(
                        onRefresh: () => cubit.onRefresh(),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.fromLTRB(
                            AppDimens.w16,
                            0,
                            AppDimens.w16,
                            AppDimens.w16,
                          ),
                          child: Container(
                            padding: EdgeInsets.all(AppDimens.w16),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(
                                AppDimens.radiusLarge,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              spacing: AppDimens.h16,
                              children: [
                                if (state.shiftSchedule.isLoading)
                                  _buildShimmer(context)
                                else if (shiftSchedule != null)
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    spacing: AppDimens.h16,
                                    children: [
                                      _buildShiftDetails(
                                        context,
                                        title: 'Shift Saya (Requester)',
                                        schedule: state.shiftSchedule.data,
                                        user: state.shiftSchedule.data?.user,
                                      ),
                                      _buildDividerIcon(context),
                                      _buildShiftDetails(
                                        context,
                                        title: 'Shift Tujuan (Target)',
                                        schedule: state
                                            .form
                                            .targetShiftSchedule
                                            .value
                                            ?.currentShift,
                                        user: state
                                            .form
                                            .targetShiftSchedule
                                            .value
                                            ?.user,
                                        isTarget: true,
                                      ),
                                    ],
                                  ),
                                AppDateTimeField(
                                  label: 'Tanggal Shift Tujuan',
                                  isRequired: true,
                                  mode: AppDateTimeFieldMode.date,
                                  hintText: 'Pilih Tanggal Shift Tujuan',
                                  value: state.form.date.value,
                                  onConfirmed: cubit.onChangeDate,
                                  errorText: state.form.date.errorMessage,
                                ),
                                AppDropdownField<AvailableShiftForSwap>(
                                  compareFn: (a, b) => a.id == b.id,
                                  label: 'Jadwal Shift Tujuan',
                                  isRequired: true,
                                  hintText: state.targetShiftSchedules.isLoading
                                      ? 'Memuat jadwal shift tujuan...'
                                      : 'Pilih Jadwal Shift Tujuan',
                                  itemBuilder: (context, item, isDisabled, isSelected) {
                                    final shift = item.currentShift;
                                    final jamMasuk =
                                        shift.shift.jamMasuk?.format(
                                          pattern: 'HH:mm',
                                        ) ??
                                        '--:--';
                                    final jamPulang =
                                        shift.shift.jamPulang?.format(
                                          pattern: 'HH:mm',
                                        ) ??
                                        '--:--';

                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: AppDimens.paddingMediumX,
                                        vertical: AppDimens.h10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppColors.primary.withValues(
                                                alpha: 0.05,
                                              )
                                            : Colors.transparent,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: AppUserInfoTile(
                                              user: item.user,
                                              padding: EdgeInsets.zero,
                                              subtitle:
                                                  '${shift.shift.name} • $jamMasuk - $jamPulang',
                                            ),
                                          ),
                                          Icon(
                                            isSelected
                                                ? Icons
                                                      .radio_button_checked_rounded
                                                : Icons
                                                      .radio_button_unchecked_rounded,
                                            color: isSelected
                                                ? AppColors.primary
                                                : AppColors.labelTertiary,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  itemAsString: _targetShiftScheduleLabel,
                                  items: state.targetShiftSchedules.maybeWhen(
                                    orElse: () => [],
                                    success: (v) => v,
                                  ),
                                  selectedItem:
                                      state.form.targetShiftSchedule.value,
                                  onChanged: cubit.onChangeTargetShiftSchedule,
                                  errorText: state
                                      .form
                                      .targetShiftSchedule
                                      .errorMessage,
                                  showSearchBox: false,
                                ),
                                AppTextField(
                                  label: 'Alasan',
                                  isRequired: true,
                                  hintText: 'Masukkan alasan tukar shift',
                                  maxLines: 3,
                                  onChanged: cubit.onChangeReason,
                                  errorText: state.form.reason.errorMessage,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            color: context.theme.scaffoldBackgroundColor,
            padding: EdgeInsets.all(AppDimens.w16),
            child: AppButtonNew(
              text: 'Kirim Request',
              onPressed: shiftSchedule == null ? null : cubit.submit,
              isLoading: state.submit.isLoading,
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmer(BuildContext context) {
    return Column(
      spacing: AppDimens.h16,
      children: [
        AppShimmer.box(
          width: double.infinity,
          height: 180,
          radius: AppDimens.r16,
        ),
        _buildDividerIcon(context),
        AppShimmer.box(
          width: double.infinity,
          height: 180,
          radius: AppDimens.r16,
        ),
      ],
    );
  }

  Widget _buildDividerIcon(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimens.w12),
          child: Icon(
            PhosphorIcons.arrowsDownUpBold,
            size: 16,
            color: AppColors.labelTertiary,
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildShiftDetails(
    BuildContext context, {
    required String title,
    ShiftSchedule? schedule,
    User? user,
    bool isTarget = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppDimens.h8,
      children: [
        Text(
          title,
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.labelSecondary,
          ),
        ),
        AppCard(
          leadingIndicatorColor: isTarget
              ? AppColors.warning
              : AppColors.primary,
          padding: EdgeInsets.all(AppDimens.w12),
          header: user != null
              ? AppUserInfoTile(user: user, padding: EdgeInsets.zero)
              : null,
          content: Column(
            spacing: AppDimens.h8,
            children: [
              AppLabeledValue(
                label: 'Tanggal',
                value:
                    schedule?.assignedDate?.format(
                      pattern: 'EEEE, dd MMMM yyyy',
                    ) ??
                    '-',
                icon: PhosphorIcons.calendarBlank,
              ),
              AppLabeledValue(
                label: 'Nama Shift',
                value: schedule?.shift.name ?? '-',
                icon: PhosphorIcons.calendarCheck,
              ),
              Row(
                children: [
                  Expanded(
                    child: AppLabeledValue(
                      label: 'Jam Masuk',
                      value:
                          schedule?.shift.jamMasuk?.format(pattern: 'HH:mm') ??
                          '--:--',
                      icon: PhosphorIcons.signIn,
                    ),
                  ),
                  Expanded(
                    child: AppLabeledValue(
                      label: 'Jam Pulang',
                      value:
                          schedule?.shift.jamPulang?.format(pattern: 'HH:mm') ??
                          '--:--',
                      icon: PhosphorIcons.signOut,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
