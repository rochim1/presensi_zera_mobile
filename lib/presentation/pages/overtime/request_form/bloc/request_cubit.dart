import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

import '../formz/_formz.dart';
import 'request_state.dart';

class OvertimeRequestFormCubit extends Cubit<OvertimeRequestFormState> {
  final CreateOvertimeRequest createOvertimeRequestUseCase;
  final UpdateOvertimeRequest updateOvertimeRequestUseCase;
  final Logger logger;
  OvertimeRequest? _request;

  OvertimeRequestFormCubit({
    required this.logger,
    required this.createOvertimeRequestUseCase,
    required this.updateOvertimeRequestUseCase,
  }) : super(const OvertimeRequestFormState());

  void submit({bool isAttachmentRequired = false}) async {
    final form = state.form.copyWith(
      date: DateInput.dirty(state.form.date.value),
      startTime: StartTimeInput.dirty(state.form.startTime.value),
      endTime: EndTimeInput.dirty(state.form.endTime.value),
      reason: ReasonInput.dirty(state.form.reason.value),
      attachments: AttachmentsInput.dirty(
        state.form.attachments.value,
        isRequired: isAttachmentRequired,
      ),
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

    final params = CreateOvertimeRequestParams(
      date: form.date.value,
      startTime: form.startTime.value,
      endTime: form.endTime.value,
      reason: form.reason.value ?? '',
      attachments: attachments,
    );
    final result = _request == null
        ? await createOvertimeRequestUseCase.call(params)
        : await updateOvertimeRequestUseCase.call(_request!.id, params);

    result.fold(
      (failure) {
        emit(state.copyWith(submit: BaseState.failure(failure)));
      },
      (_) {
        emit(state.copyWith(submit: BaseState.success(null)));
      },
    );
  }

  void onChangeDate(DateTime? value) async {
    final form = state.form.copyWith(date: DateInput.dirty(value));

    emit(state.copyWith(form: form));
  }

  void onChangeStartTime(DateTime? value) {
    final form = state.form.copyWith(startTime: StartTimeInput.dirty(value));

    emit(state.copyWith(form: form));
  }

  void onChangeEndTime(DateTime? value) {
    final form = state.form.copyWith(endTime: EndTimeInput.dirty(value));

    emit(state.copyWith(form: form));
  }

  void onChangeReason(String? value) {
    final form = state.form.copyWith(reason: ReasonInput.dirty(value));
    emit(state.copyWith(form: form));
  }

  void onChangeAttachments(List<PlatformFile> value) {
    final form = state.form.copyWith(
      attachments: AttachmentsInput.dirty(
        value,
        isRequired: state.form.attachments.isRequired,
      ),
    );

    emit(state.copyWith(form: form));
  }

  void init(OvertimeRequest? request) {
    _request = request;
    if (request == null) return;

    emit(
      state.copyWith(
        form: state.form.copyWith(
          date: DateInput.dirty(request.date),
          startTime: StartTimeInput.dirty(request.startTime),
          endTime: EndTimeInput.dirty(request.endTime),
          reason: ReasonInput.dirty(request.reason),
        ),
      ),
    );
  }
}
