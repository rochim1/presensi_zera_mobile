import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

import '../formz/_formz.dart';
import 'request_state.dart';

class ReimbursementRequestFormCubit
    extends Cubit<ReimbursementRequestFormState> {
  final CreateReimbursement createReimbursementUseCase;
  final GetReimbursementCategories getReimbursementCategoriesUseCase;
  final Logger logger;
  final ReimbursementRepository repository;
  Reimbursement? _request;

  ReimbursementRequestFormCubit({
    required this.logger,
    required this.createReimbursementUseCase,
    required this.getReimbursementCategoriesUseCase,
    required this.repository,
  }) : super(const ReimbursementRequestFormState());

  void init([Reimbursement? request]) async {
    _request = request;
    emit(state.copyWith(categories: const BaseState.loading()));

    final result = await getReimbursementCategoriesUseCase.call(NoParams());
    result.fold(
      (failure) {
        logger.e('Failed to load categories: $failure');
        emit(state.copyWith(categories: BaseState.failure(failure)));
      },
      (categories) {
        var form = state.form.copyWith(
          currency: const CurrencyInput.dirty(CurrencySymbol.IDR),
        );
        if (_request != null) {
          final category = categories
              .where((v) => v.value == _request!.kategori)
              .firstOrNull;
          form = form.copyWith(
            category: CategoryInput.dirty(category),
            title: TitleInput.dirty(_request!.judul),
            description: DescriptionInput.dirty(_request!.deskripsi),
            date: ReimbursementDateInput.dirty(_request!.tanggal),
            currency: CurrencyInput.dirty(_request!.mataUang),
            nominal: NominalInput.dirty(_request!.nominal),
            notes: NotesInput.dirty(_request!.catatanPengaju),
          );
        }
        emit(
          state.copyWith(categories: BaseState.success(categories), form: form),
        );
      },
    );
  }

  void submit() async {
    final form = state.form.copyWith(
      category: CategoryInput.dirty(state.form.category.value),
      title: TitleInput.dirty(state.form.title.value),
      description: DescriptionInput.dirty(state.form.description.value),
      date: ReimbursementDateInput.dirty(state.form.date.value),
      currency: CurrencyInput.dirty(state.form.currency.value),
      nominal: NominalInput.dirty(state.form.nominal.value),
      attachments: ReimbursementAttachmentsInput.dirty(
        state.form.attachments.value,
        isRequired: _request?.buktiPembayaran?.isNotEmpty != true,
      ),
      notes: NotesInput.dirty(state.form.notes.value),
    );
    emit(state.copyWith(form: form));

    if (form.isNotValid) return;

    emit(state.copyWith(submit: BaseState.loading()));

    late final List<MultipartFile> attachments;
    try {
      attachments = form.attachments.value
          .map(AppUtility.toPickedMultipartFile)
          .toList();
    } on Failure catch (failure) {
      emit(state.copyWith(submit: BaseState.failure(failure)));
      return;
    }

    final params = CreateReimbursementParams(
      kategori: form.category.value!.value,
      judul: form.title.value ?? '',
      deskripsi: form.description.value,
      tanggal: form.date.value,
      nominal: form.nominal.value,
      mataUang: form.currency.value?.name,
      catatanPengaju: form.notes.value,
      attachments: attachments,
    );
    final result = _request == null
        ? await createReimbursementUseCase.call(params)
        : await repository.updateReimbursement(_request!.id, params);

    result.fold(
      (failure) => emit(state.copyWith(submit: BaseState.failure(failure))),
      (_) => emit(state.copyWith(submit: BaseState.success(null))),
    );
  }

  void onChangeCategory(ReimbursementCategory? value) {
    final form = state.form.copyWith(category: CategoryInput.dirty(value));
    emit(state.copyWith(form: form));
  }

  void onChangeTitle(String? value) {
    final form = state.form.copyWith(title: TitleInput.dirty(value));
    emit(state.copyWith(form: form));
  }

  void onChangeDescription(String? value) {
    final form = state.form.copyWith(
      description: DescriptionInput.dirty(value),
    );
    emit(state.copyWith(form: form));
  }

  void onChangeDate(DateTime? value) {
    final form = state.form.copyWith(date: ReimbursementDateInput.dirty(value));
    emit(state.copyWith(form: form));
  }

  void onChangeCurrency(CurrencySymbol? value) {
    final form = state.form.copyWith(currency: CurrencyInput.dirty(value));
    emit(state.copyWith(form: form));
  }

  void onChangeNominal(double? value) {
    final form = state.form.copyWith(nominal: NominalInput.dirty(value));
    emit(state.copyWith(form: form));
  }

  void onChangeAttachments(List<PlatformFile> value) {
    final form = state.form.copyWith(
      attachments: ReimbursementAttachmentsInput.dirty(
        value,
        isRequired: _request?.buktiPembayaran?.isNotEmpty != true,
      ),
    );
    emit(state.copyWith(form: form));
  }

  void onChangeNotes(String? value) {
    final form = state.form.copyWith(notes: NotesInput.dirty(value));
    emit(state.copyWith(form: form));
  }
}
