import 'package:auto_route/auto_route.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_cubit.dart';
import 'package:presensi_domain/presensi_domain.dart';

import 'bloc/request_state.dart';
import 'formz/inputs/attachment_input.dart';

@RoutePage()
class OvertimeRequestFormPage extends StatelessWidget {
  final OvertimeRequest? request;

  const OvertimeRequestFormPage({super.key, this.request});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OvertimeRequestFormCubit>()..init(request),
      child: OvertimeRequestFormView(request: request),
    );
  }
}

class OvertimeRequestFormView extends StatelessWidget {
  final OvertimeRequest? request;

  const OvertimeRequestFormView({super.key, this.request});

  @override
  Widget build(BuildContext context) {
    final isAttachmentRequired = context.select<AppCubit, bool>(
      (cubit) =>
          cubit.state.setting.data?.isMandatorySupportingEvidence ?? false,
    );

    void onTapAttachment(BuildContext context) async {
      final result = await AppUtility.fileAttachment(
        false,
        AttachmentsInput.allowedExtensions,
        FileType.custom,
      );
      if (result.isEmpty) return;

      if (context.mounted) {
        context.read<OvertimeRequestFormCubit>().onChangeAttachments(
          result.map((e) => e).toList(),
        );
      }
    }

    return BlocConsumer<OvertimeRequestFormCubit, OvertimeRequestFormState>(
      builder: (context, state) {
        final cubit = context.read<OvertimeRequestFormCubit>();
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
                      title: request == null ? 'Ajukan Lembur' : 'Ubah Lembur',
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
                              AppDateTimeField(
                                label: 'Tanggal',
                                isRequired: true,
                                firstDate: DateTime.now(),
                                hintText: 'Pilih Tanggal',
                                value: state.form.date.value,
                                onConfirmed: cubit.onChangeDate,
                                errorText: state.form.date.errorMessage,
                              ),
                              AppDateTimeField(
                                label: 'Jam Mulai',
                                isRequired: true,
                                mode: AppDateTimeFieldMode.time,
                                hintText: 'Masukkan Jam Mulai',
                                value: state.form.startTime.value,
                                onConfirmed: cubit.onChangeStartTime,
                                errorText: state.form.startTime.errorMessage,
                              ),
                              AppDateTimeField(
                                label: 'Jam Selesai',
                                isRequired: true,
                                mode: AppDateTimeFieldMode.time,
                                hintText: 'Masukkan Jam Selesai',
                                value: state.form.endTime.value,
                                onConfirmed: cubit.onChangeEndTime,
                                errorText: state.form.endTime.errorMessage,
                              ),
                              AppTextField(
                                label: 'Alasan',
                                isRequired: true,
                                hintText:
                                    'Masukkan alasan lembur dan deskripsi pekerjaan yang akan dilakukan',
                                maxLines: 3,
                                initialValue: request?.reason,
                                onChanged: cubit.onChangeReason,
                                errorText: state.form.reason.errorMessage,
                              ),
                              AppAttachmentField(
                                label: 'Bukti Pendukung',
                                isRequired:
                                    isAttachmentRequired && request == null,
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
              text: request == null ? 'Buat Request' : 'Simpan Perubahan',
              onPressed: () => cubit.submit(
                isAttachmentRequired: isAttachmentRequired && request == null,
              ),
              isLoading: state.submit.isLoading,
            ),
          ),
        );
      },
      listenWhen: (prev, curr) => prev.submit != curr.submit,
      listener: (BuildContext context, OvertimeRequestFormState state) {
        state.submit.maybeWhen(
          orElse: () {},
          success: (v) => {
            AppSnackbar.showSuccess(
              context,
              request == null
                  ? 'Berhasil mengajukan request lembur'
                  : 'Berhasil mengubah request lembur',
            ),
            context.pop(true),
          },
          failure: (e) => {
            AppSnackbar.showError(
              context,
              'Gagal menyimpan request lembur: ${e.message}',
            ),
          },
        );
      },
    );
  }
}
