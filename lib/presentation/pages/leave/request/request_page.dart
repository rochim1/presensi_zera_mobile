import 'package:auto_route/auto_route.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

import 'bloc/request_state.dart';
import 'formz/_formz.dart';

@RoutePage()
class LeaveRequestPage extends StatelessWidget {
  final LeaveRequest? request;
  const LeaveRequestPage({super.key, this.request});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LeaveRequestCubit>()..init(request),
      child: _LeaveRequestView(request: request),
    );
  }
}

class _LeaveRequestView extends StatelessWidget {
  final LeaveRequest? request;

  const _LeaveRequestView({this.request});

  void onTapAttachment(BuildContext context, LeaveRequestCubit cubit) async {
    final result = await AppUtility.fileAttachment(
      true,
      AttachmentInput.allowedExtensions,
      FileType.custom,
    );
    if (result.isEmpty) return;

    if (context.mounted) {
      cubit.onChangeAttachment(result.map((e) => e).toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LeaveRequestCubit, LeaveRequestState>(
      builder: (context, state) {
        final cubit = context.read<LeaveRequestCubit>();
        final List<LeaveCategory> leaveCategories = state.leaveCategories
            .maybeWhen(success: (v) => v, orElse: () => []);
        final List<User> users = state.users.maybeWhen(
          success: (v) => v,
          orElse: () => [],
        );

        final selectedCategory = state.form.category.value;
        final showMode = selectedCategory?.isAllowHalfDay ?? false;
        final showEndDate = !state.form.isHalfDay;
        final needsAttachment = state.form.needsAttachment;

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
                      title: 'Request Cuti',
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
                              AppDropdownField<LeaveCategory>(
                                label: 'Jenis Cuti',
                                isRequired: true,
                                hintText: 'Pilih Jenis Cuti',
                                selectedItem: state.form.category.value,
                                items: leaveCategories,
                                compareFn: (item, filter) =>
                                    item.id == filter.id,
                                itemAsString: (item) => item.name,
                                onChanged: cubit.onChangeCategory,
                                errorText: state.form.category.errorMessage,
                              ),
                              if (showMode) ...[
                                AppDropdownField<LeaveMode>(
                                  label: 'Mode Cuti',
                                  isRequired: true,
                                  hintText: 'Pilih Mode Cuti',
                                  selectedItem: state.form.mode.value,
                                  items: LeaveMode.values,
                                  compareFn: (item, filter) => item == filter,
                                  itemAsString: (item) => item.label,
                                  onChanged: cubit.onChangeMode,
                                  errorText: state.form.mode.errorMessage,
                                ),
                              ],
                              AppDateTimeField(
                                label: 'Tanggal Mulai',
                                isRequired: true,
                                firstDate: DateTime.now(),
                                hintText: 'Pilih tanggal mulai',
                                value: state.form.startDate.value,
                                onConfirmed: cubit.onChangeStartDate,
                                errorText: state.form.startDate.errorMessage,
                              ),
                              if (showEndDate)
                                AppDateTimeField(
                                  label: 'Tanggal Selesai',
                                  isRequired: true,
                                  firstDate:
                                      state.form.startDate.value ??
                                      DateTime.now(),
                                  hintText: 'Pilih tanggal selesai',
                                  value: state.form.endDate.value,
                                  onConfirmed: cubit.onChangeEndDate,
                                  errorText: state.form.endDate.errorMessage,
                                ),
                              AppTextField(
                                label: 'Alasan',
                                isRequired: true,
                                hintText: 'Masukkan alasan untuk request ini',
                                maxLines: 3,
                                onChanged: cubit.onChangeReason,
                                errorText: state.form.reason.errorMessage,
                              ),
                              AppDropdownField<User>(
                                label: 'Delegasikan Tugas Kepada',
                                hintText: 'Pilih delegasi (opsional)',
                                selectedItem: state.form.delegation.value,
                                items: users,
                                compareFn: (item, filter) =>
                                    item.id == filter.id,
                                itemAsString: (item) =>
                                    '${item.name} - ${item.department?.name}',
                                onChanged: cubit.onChangeDelegation,
                                showSearchBox: true,
                                itemBuilder: (context, item, isDisabled, isSelected) {
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
                                            user: item,
                                            padding: EdgeInsets.zero,
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
                              ),
                              AppTextField(
                                label: 'Kontak Darurat (Opsional)',
                                hintText: 'Masukkan nomor kontak darurat',
                                onChanged: cubit.onChangeEmergencyContact,
                                errorText:
                                    state.form.emergencyContact.errorMessage,
                              ),
                              AppAttachmentField(
                                label: 'Bukti Pendukung',
                                isRequired: needsAttachment,
                                hintText:
                                    'Tambahkan foto atau dokumen pendukung',
                                value: state.form.attachment.value.isNotEmpty
                                    ? state.form.attachment.value
                                          .map((e) => e.name)
                                          .join(', ')
                                    : null,
                                onTap: () => onTapAttachment(context, cubit),
                                onDelete: () => cubit.onChangeAttachment([]),
                                errorText: needsAttachment
                                    ? state.form.attachment.errorMessage
                                    : null,
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: AppDimens.h16,
              children: [
                // Only show quota for Cuti Tahunan (Annual Leave)
                if (selectedCategory != null &&
                    const [
                      '6a212b5fe2d0352cba537221',
                    ].contains(selectedCategory.id))
                  Row(
                    spacing: AppDimens.w8,
                    children: [
                      Text("Max:"),
                      state.cutiQuota.maybeWhen(
                        success: (quota) => AppChip(
                          label: '${quota['kuota_cuti'] ?? '-'} Hari',
                          color: AppColors.primary,
                          borderRadius: AppDimens.r12,
                        ),
                        orElse: () => AppChip(
                          label: '${selectedCategory.maxDurationInDays} Hari',
                          color: AppColors.primary,
                          borderRadius: AppDimens.r12,
                        ),
                      ),
                      Text("Sisa:"),
                      state.cutiQuota.maybeWhen(
                        success: (quota) => AppChip(
                          label: '${quota['sisa_cuti'] ?? '-'} Hari',
                          color: (quota['sisa_cuti'] ?? 0) > 0
                              ? AppColors.success
                              : AppColors.danger,
                          borderRadius: AppDimens.r12,
                        ),
                        orElse: () => AppChip(
                          label: '- Hari',
                          color: AppColors.labelSecondary,
                          borderRadius: AppDimens.r12,
                        ),
                      ),
                    ],
                  ),
                if (selectedCategory != null &&
                    const [
                      '6a212b5fe2d0352cba537221',
                    ].contains(selectedCategory.id))
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.warning.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.warning,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Info: Jika durasi pengajuan Anda melebihi sisa cuti, maka hari yang berlebih akan dihitung sebagai Unpaid Leave (Potong Gaji).',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.warning.withValues(alpha: 0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                AppButtonNew(
                  text: 'Buat Request',
                  isLoading: state.submit.isLoading,
                  onPressed: cubit.submit,
                ),
              ],
            ),
          ),
        );
      },
      listenWhen: (prev, curr) => prev.submit != curr.submit,
      listener: (BuildContext context, LeaveRequestState state) {
        state.submit.maybeWhen(
          orElse: () {},
          success: (_) {
            AppSnackbar.showSuccess(
              context,
              request == null
                  ? 'Request Cuti berhasil diajukan'
                  : 'Request Cuti berhasil diperbarui',
            );
            // Return the requested date so the list can switch to the month
            // containing the newly created/updated leave request.
            context.router.maybePop(state.form.startDate.value ?? true);
          },
          failure: (e) => AppSnackbar.showError(context, 'Gagal: ${e.message}'),
        );
      },
    );
  }
}
