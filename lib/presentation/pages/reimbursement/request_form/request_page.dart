import 'package:auto_route/auto_route.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';
import 'package:presensi_mobile/presentation/widgets/global/text_field_custom/text_formatter.dart';

import 'bloc/request_state.dart';
import 'formz/inputs/attachment_input.dart';

@RoutePage()
class ReimbursementRequestFormPage extends StatelessWidget {
  final Reimbursement? request;
  const ReimbursementRequestFormPage({super.key, this.request});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ReimbursementRequestFormCubit>()..init(request),
      child: const ReimbursementRequestFormView(),
    );
  }
}

class ReimbursementRequestFormView extends StatelessWidget {
  const ReimbursementRequestFormView({super.key});

  @override
  Widget build(BuildContext context) {
    void onTapAttachment(BuildContext context) async {
      final result = await AppUtility.fileAttachment(
        true,
        ReimbursementAttachmentsInput.allowedExtensions,
        FileType.custom,
      );
      if (result.isEmpty) return;

      if (context.mounted) {
        context.read<ReimbursementRequestFormCubit>().onChangeAttachments(
          result.map((e) => e).toList(),
        );
      }
    }

    return BlocConsumer<
      ReimbursementRequestFormCubit,
      ReimbursementRequestFormState
    >(
      builder: (context, state) {
        final cubit = context.read<ReimbursementRequestFormCubit>();
        final categories = state.categories.data ?? [];
        final isLoadingCategories = state.categories.isLoading;

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
                      title: 'Ajukan Reimbursement',
                      useGradient: false,
                      backgroundColor: Colors.transparent,
                      titleColor: AppColors.white,
                    ),
                    Expanded(
                      child: isLoadingCategories
                          ? const Center(child: CircularProgressIndicator())
                          : SingleChildScrollView(
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
                                      color: Colors.black.withValues(
                                        alpha: 0.05,
                                      ),
                                      blurRadius: 16,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  spacing: AppDimens.h16,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    AppDropdownField<ReimbursementCategory>(
                                      label: 'Kategori',
                                      isRequired: true,
                                      hintText: 'Pilih Kategori',
                                      selectedItem: state.form.category.value,
                                      items: categories,
                                      onChanged: cubit.onChangeCategory,
                                      compareFn: (item, filter) =>
                                          item.value == filter.value,
                                      itemAsString: (item) => item.label,
                                    ),
                                    AppTextField(
                                      label: 'Judul',
                                      isRequired: true,
                                      hintText: 'Masukkan judul reimbursement',
                                      onChanged: cubit.onChangeTitle,
                                      errorText: state.form.title.errorMessage,
                                    ),
                                    AppTextField(
                                      label: 'Deskripsi',
                                      isRequired: true,
                                      hintText: 'Masukkan deskripsi',
                                      maxLines: 3,
                                      onChanged: cubit.onChangeDescription,
                                      errorText:
                                          state.form.description.errorMessage,
                                    ),
                                    AppDateTimeField(
                                      label: 'Tanggal',
                                      isRequired: true,
                                      hintText: 'Pilih Tanggal',
                                      value: state.form.date.value,
                                      onConfirmed: cubit.onChangeDate,
                                      errorText: state.form.date.errorMessage,
                                    ),
                                    AppDropdownField<CurrencySymbol>(
                                      label: 'Mata Uang',
                                      isRequired: true,
                                      hintText: 'Pilih Mata Uang',
                                      selectedItem: state.form.currency.value,
                                      items: CurrencySymbol.values,
                                      onChanged: cubit.onChangeCurrency,
                                      compareFn: (item, filter) =>
                                          item.name == filter.name,
                                      itemAsString: (item) => item.displayName,
                                    ),
                                    AppTextField(
                                      label: 'Nominal',
                                      isRequired: true,
                                      hintText: 'Masukkan nominal',
                                      keyboardType: TextInputType.number,
                                      initialValue:
                                          state.form.nominal.value == null
                                          ? null
                                          : IdrTextInputFormatter.formatNumber(
                                              state.form.nominal.value!,
                                            ),
                                      inputFormatters: [
                                        IdrTextInputFormatter(),
                                      ],
                                      onChanged: (v) {
                                        cubit.onChangeNominal(
                                          IdrTextInputFormatter.tryParse(v),
                                        );
                                      },
                                    ),
                                    AppAttachmentField(
                                      label: 'Bukti Pembayaran',
                                      isRequired: true,
                                      hintText: 'Tambahkan foto atau dokumen',
                                      value: state.form.attachments.value
                                          .map((e) => e.name)
                                          .join(', '),
                                      onDelete: () =>
                                          cubit.onChangeAttachments([]),
                                      onTap: () => onTapAttachment(context),
                                      errorText:
                                          state.form.attachments.errorMessage,
                                    ),
                                    AppTextField(
                                      label: 'Catatan Tambahan',
                                      isRequired: false,
                                      hintText: 'Tambahkan catatan (opsional)',
                                      maxLines: 2,
                                      onChanged: cubit.onChangeNotes,
                                      errorText: state.form.notes.errorMessage,
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
              onPressed: cubit.submit,
              isLoading: state.submit.isLoading,
            ),
          ),
        );
      },
      listenWhen: (prev, curr) => prev.submit != curr.submit,
      listener: (BuildContext context, ReimbursementRequestFormState state) {
        state.submit.maybeWhen(
          orElse: () {},
          success: (v) => {
            AppSnackbar.showSuccess(
              context,
              'Berhasil mengajukan reimbursement',
            ),
            context.pop(true),
          },
          failure: (e) => AppSnackbar.showError(context, 'Gagal: $e'),
        );
      },
    );
  }
}
