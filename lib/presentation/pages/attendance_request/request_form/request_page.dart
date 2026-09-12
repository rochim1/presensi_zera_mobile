import 'package:auto_route/auto_route.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

import 'bloc/request_state.dart';
import 'formz/inputs/attachment_input.dart';

@RoutePage()
class AttendanceRequestFormPage extends StatelessWidget {
  final Attendance? attendance;
  final AttendanceRequest? request;
  const AttendanceRequestFormPage({super.key, this.attendance, this.request});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<AttendanceRequestFormCubit>()..init(attendance, request),
      child: AttendanceRequestFormView(hasAttendance: attendance != null),
    );
  }
}

class AttendanceRequestFormView extends StatelessWidget {
  final bool hasAttendance;
  const AttendanceRequestFormView({super.key, required this.hasAttendance});

  @override
  Widget build(BuildContext context) {
    void onTapAttachment(BuildContext context) async {
      final result = await AppUtility.fileAttachment(
        false,
        AttachmentsInput.allowedExtensions,
        FileType.custom,
      );
      if (result.isEmpty) return;

      if (context.mounted) {
        context.read<AttendanceRequestFormCubit>().onChangeAttachments(
          result.map((e) => e).toList(),
        );
      }
    }

    return BlocConsumer<AttendanceRequestFormCubit, AttendanceRequestFormState>(
      builder: (context, state) {
        final cubit = context.read<AttendanceRequestFormCubit>();
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
                      title: 'Ajukan Request Presensi',
                      useGradient: false,
                      backgroundColor: Colors.transparent,
                      titleColor: AppColors.white,
                    ),
                    Expanded(
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
                              AppDropdownField<AttendanceType>(
                                compareFn: (a, b) => a.name == b.name,
                                label: 'Jenis Presensi',
                                isRequired: true,
                                hintText: 'Pilih Jenis Presensi',
                                itemAsString: (v) => v.toName,
                                items: AttendanceType.values,
                                selectedItem: state.form.attendanceType.value,
                                onChanged: cubit.onChangeAttendanceType,
                                errorText:
                                    state.form.attendanceType.errorMessage,
                                enabled: !hasAttendance,
                              ),
                              AppDropdownField<AttendanceRequestType>(
                                compareFn: (a, b) => a.name == b.name,
                                label: 'Jenis Request Presensi',
                                isRequired: true,
                                hintText: 'Pilih Jenis Request Presensi',
                                itemAsString: (v) => v.displayName,
                                items: hasAttendance
                                    ? [
                                        AttendanceRequestType.koreksi_masuk,
                                        AttendanceRequestType.koreksi_pulang,
                                        AttendanceRequestType
                                            .koreksi_masuk_dan_pulang,
                                        AttendanceRequestType
                                            .koreksi_waktu_istirahat,
                                      ]
                                    : [
                                        AttendanceRequestType
                                            .lupa_presensi_masuk,
                                        AttendanceRequestType
                                            .lupa_presensi_pulang,
                                        AttendanceRequestType.dinas_luar,
                                        AttendanceRequestType.wfh,
                                      ],
                                selectedItem:
                                    state.form.attendanceRequestType.value,
                                onChanged: cubit.onChangeAttendanceRequestType,
                                errorText: state
                                    .form
                                    .attendanceRequestType
                                    .errorMessage,
                              ),
                              AppDateTimeField(
                                label: 'Tanggal Presensi',
                                isRequired: true,
                                lastDate: DateTime.now(),
                                hintText: 'Pilih Tanggal Presensi',
                                value: state.form.attendanceDate.value,
                                onConfirmed: cubit.onChangeAttendanceDate,
                                errorText:
                                    state.form.attendanceDate.errorMessage,
                                enabled: !hasAttendance,
                              ),
                              if (state.form.shiftSchedule.isRequired) ...[
                                AppDropdownField<ShiftSchedule>(
                                  compareFn: (a, b) => a.id == b.id,
                                  label: 'Jadwal Shift',
                                  isRequired:
                                      state.form.shiftSchedule.isRequired,
                                  hintText: 'Pilih Jadwal Shift',
                                  itemAsString: (v) =>
                                      '${v.shift.name} (${v.shift.jamMasuk?.format(pattern: 'HH:mm')} - ${v.shift.jamPulang?.format(pattern: 'HH:mm')})',
                                  items: state.shiftSchedules.maybeWhen(
                                    orElse: () => [],
                                    success: (v) => v,
                                  ),
                                  selectedItem: state.form.shiftSchedule.value,
                                  onChanged: cubit.onChangeShiftSchedule,
                                  errorText: state
                                      .form
                                      .attendanceRequestType
                                      .errorMessage,
                                ),
                              ],
                              if (state.form.checkInTime.isRequired) ...[
                                AppDateTimeField(
                                  label: 'Jam Check In',
                                  isRequired: state.form.checkInTime.isRequired,
                                  firstDate: DateTime.now(),
                                  mode: AppDateTimeFieldMode.time,
                                  hintText: 'Masukkan Jam Check In',
                                  value: state.form.checkInTime.value,
                                  onConfirmed: cubit.onChangeCheckInTime,
                                  errorText:
                                      state.form.checkInTime.errorMessage,
                                ),
                              ],
                              if (state.form.checkOutTime.isRequired) ...[
                                AppDateTimeField(
                                  label: 'Jam Check Out',
                                  isRequired:
                                      state.form.checkOutTime.isRequired,
                                  firstDate: DateTime.now(),
                                  mode: AppDateTimeFieldMode.time,
                                  hintText: 'Masukkan Jam Check Out',
                                  value: state.form.checkOutTime.value,
                                  onConfirmed: cubit.onChangeCheckOutTime,
                                  errorText:
                                      state.form.checkOutTime.errorMessage,
                                ),
                              ],
                              AppTextField(
                                label: 'Alasan',
                                isRequired: true,
                                hintText: 'Masukkan alasan untuk request ini',
                                maxLines: 3,
                                onChanged: cubit.onChangeReason,
                                errorText: state.form.reason.errorMessage,
                              ),
                              AppAttachmentField(
                                label: 'Bukti Pendukung',
                                hintText:
                                    'Tambahkan foto atau dokumen pendukung',
                                value: state.form.attachments.value
                                    .map((e) => e.name)
                                    .join(', '),
                                onDelete: () {
                                  cubit.onChangeAttachments([]);
                                },
                                onTap: () => onTapAttachment(context),
                                errorText: state.form.attachments.errorMessage,
                              ),
                            ],
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
              text: 'Buat Request',
              onPressed: () => cubit.submit(),
              isLoading: state.submit.isLoading,
            ),
          ),
        );
      },
      listenWhen: (prev, curr) => prev.submit != curr.submit,
      listener: (BuildContext context, AttendanceRequestFormState state) {
        state.submit.maybeWhen(
          orElse: () {},
          success: (v) => {
            AppSnackbar.showSuccess(
              context,
              'Berhasil mengajukan request presensi',
            ),
            context.pop(true),
          },
          failure: (e) => {
            AppSnackbar.showError(
              context,
              'Gagal mengajukan request presensi: $e',
            ),
          },
        );
      },
    );
  }
}
