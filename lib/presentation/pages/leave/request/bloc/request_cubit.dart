import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

import '../formz/_formz.dart';
import 'request_state.dart';

class LeaveRequestCubit extends Cubit<LeaveRequestState> {
  final GetLeaveCategories getLeaveCategoriesUseCase;
  final GetUsers getUsersUseCase;
  final CreateLeaveRequest createLeaveRequestUseCase;
  final LeaveRepository leaveRepository;
  final Logger logger;
  LeaveRequest? _request;

  LeaveRequestCubit({
    required this.logger,
    required this.getLeaveCategoriesUseCase,
    required this.getUsersUseCase,
    required this.createLeaveRequestUseCase,
    required this.leaveRepository,
  }) : super(const LeaveRequestState());

  void init([LeaveRequest? request]) async {
    _request = request;
    getLeaveCategories();
    getUsers();
    getCutiQuota();
  }

  void getLeaveCategories() async {
    emit(state.copyWith(leaveCategories: BaseState.loading()));

    final result = await getLeaveCategoriesUseCase.call(NoParams());

    result.fold(
      (failure) {
        emit(state.copyWith(leaveCategories: BaseState.failure(failure)));
      },
      (value) {
        var form = state.form;
        if (_request != null) {
          final category = value
              .where((v) => v.id == _request!.category?.id)
              .firstOrNull;
          final mode = _request!.isHalfDay == true
              ? (_request!.halfDayType == 'siang'
                    ? LeaveMode.halfDaySiang
                    : LeaveMode.halfDayPagi)
              : LeaveMode.fullDay;
          form = form.copyWith(
            category: LeaveCategoryInput.dirty(category),
            mode: LeaveModeInput.dirty(
              mode,
              isRequired: category?.isAllowHalfDay ?? false,
            ),
            startDate: StartDateInput.dirty(_request!.tanggalIzin),
            endDate: EndDateInput.dirty(
              _request!.tanggalMasuk,
              startDate: _request!.tanggalIzin,
              isRequired: _request!.isHalfDay != true,
            ),
            reason: ReasonInput.dirty(_request!.alasan),
          );
        }
        emit(
          state.copyWith(leaveCategories: BaseState.success(value), form: form),
        );
      },
    );
  }

  void getUsers() async {
    emit(state.copyWith(users: BaseState.loading()));

    final result = await getUsersUseCase.call(GetUsersParams());

    result.fold(
      (failure) {
        logger.e('Failed to load users: $failure');
        emit(state.copyWith(users: BaseState.failure(failure)));
      },
      (value) {
        emit(state.copyWith(users: BaseState.success(value)));
      },
    );
  }

  void getCutiQuota() async {
    emit(state.copyWith(cutiQuota: BaseState.loading()));

    final result = await leaveRepository.getMyCutiQuota();

    result.fold(
      (failure) {
        logger.e('Failed to load cuti quota: $failure');
        emit(state.copyWith(cutiQuota: BaseState.failure(failure)));
      },
      (value) {
        emit(state.copyWith(cutiQuota: BaseState.success(value)));
      },
    );
  }

  void submit() async {
    final form = state.form;
    final dirtyForm = form.copyWith(
      category: LeaveCategoryInput.dirty(form.category.value),
      mode: LeaveModeInput.dirty(form.mode.value, isRequired: form.needsMode),
      startDate: StartDateInput.dirty(form.startDate.value),
      endDate: EndDateInput.dirty(
        form.endDate.value,
        startDate: form.startDate.value,
        isRequired: !form.isHalfDay,
      ),
      reason: ReasonInput.dirty(form.reason.value),
      emergencyContact: EmergencyContactInput.dirty(
        form.emergencyContact.value,
      ),
      attachment: AttachmentInput.dirty(
        form.attachment.value,
        isRequired:
            form.needsAttachment && (_request?.fileIzin?.isNotEmpty != true),
      ),
    );
    emit(state.copyWith(form: dirtyForm));

    if (dirtyForm.isNotValid) return;

    emit(state.copyWith(submit: BaseState.loading()));

    MultipartFile? attachment;
    try {
      attachment = form.attachment.value.isNotEmpty
          ? AppUtility.toPickedMultipartFile(form.attachment.value.first)
          : null;
    } on Failure catch (failure) {
      emit(state.copyWith(submit: BaseState.failure(failure)));
      return;
    }

    final params = CreateLeaveRequestParams(
      tipeCuti: form.category.value!.id,
      alasan: form.reason.value ?? '',
      tanggalIzin: form.startDate.value!,
      tanggalMasuk: form.isHalfDay
          ? form.startDate.value!
          : form.endDate.value!,
      isHalfDay: form.isHalfDay,
      halfDayType: form.mode.value?.toHalfDayType(),
      delegasiKepada: form.delegation.value?.id,
      attachment: attachment,
    );

    final result = _request == null
        ? await createLeaveRequestUseCase.call(params)
        : await leaveRepository.updateLeaveRequest(_request!.id, params);

    result.fold(
      (failure) => emit(state.copyWith(submit: BaseState.failure(failure))),
      (_) => emit(state.copyWith(submit: BaseState.success(null))),
    );
  }

  void onChangeCategory(LeaveCategory? value) {
    final isHalfDay = state.form.isHalfDay;
    final needsAttachment = value?.isNeedAttachment ?? false;
    final needsMode = value?.isAllowHalfDay ?? false;

    final form = state.form.copyWith(
      category: LeaveCategoryInput.dirty(value),
      mode: LeaveModeInput.pure(isRequired: needsMode),
      attachment: AttachmentInput.pure(isRequired: needsAttachment),
      endDate: EndDateInput.pure(
        startDate: state.form.startDate.value,
        isRequired: !isHalfDay,
      ),
    );
    emit(state.copyWith(form: form));
  }

  void onChangeMode(LeaveMode? value) {
    final isHalfDay = value?.isHalfDay ?? false;
    final form = state.form.copyWith(
      mode: LeaveModeInput.dirty(value, isRequired: state.form.needsMode),
      endDate: EndDateInput.pure(
        startDate: state.form.startDate.value,
        isRequired: !isHalfDay,
      ),
    );
    emit(state.copyWith(form: form));
  }

  void onChangeStartDate(DateTime? value) {
    final isHalfDay = state.form.isHalfDay;
    final form = state.form.copyWith(
      startDate: StartDateInput.dirty(value),
      endDate: EndDateInput.pure(startDate: value, isRequired: !isHalfDay),
    );
    emit(state.copyWith(form: form));
  }

  void onChangeEndDate(DateTime? value) {
    final form = state.form.copyWith(
      endDate: EndDateInput.dirty(
        value,
        startDate: state.form.startDate.value,
        isRequired: !state.form.isHalfDay,
      ),
    );
    emit(state.copyWith(form: form));
  }

  void onChangeReason(String? value) {
    final form = state.form.copyWith(reason: ReasonInput.dirty(value));
    emit(state.copyWith(form: form));
  }

  void onChangeDelegation(User? value) {
    final form = state.form.copyWith(delegation: DelegationInput.dirty(value));
    emit(state.copyWith(form: form));
  }

  void onChangeEmergencyContact(String? value) {
    final form = state.form.copyWith(
      emergencyContact: EmergencyContactInput.dirty(value),
    );
    emit(state.copyWith(form: form));
  }

  void onChangeAttachment(List<PlatformFile> value) {
    final form = state.form.copyWith(
      attachment: AttachmentInput.dirty(
        value,
        isRequired: state.form.needsAttachment,
      ),
    );
    emit(state.copyWith(form: form));
  }
}
