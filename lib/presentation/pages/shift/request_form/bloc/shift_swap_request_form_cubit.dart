import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

import '../formz/_formz.dart';
import 'shift_swap_request_form_state.dart';

class ShiftSwapRequestFormCubit extends Cubit<ShiftSwapRequestFormState> {
  final Logger logger;
  final GetShiftScheduleById getShiftScheduleByIdUseCase;
  final GetAvailableShiftsForSwap getAvailableShiftsForSwapUseCase;
  final CreateShiftSwapRequest createShiftSwapRequestUseCase;
  final ShiftRepository repository;
  ShiftSwapRequest? _request;

  ShiftSwapRequestFormCubit({
    required this.logger,
    required this.getShiftScheduleByIdUseCase,
    required this.getAvailableShiftsForSwapUseCase,
    required this.createShiftSwapRequestUseCase,
    required this.repository,
  }) : super(const ShiftSwapRequestFormState());

  Future<void> init([ShiftSwapRequest? request]) async {
    _request = request;
    await getShiftScheduleById(
      request?.requesterSchedule.id ?? state.shiftScheduleId,
    );
  }

  void setShiftScheduleId(String id) {
    emit(state.copyWith(shiftScheduleId: id));
  }

  Future<void> onRefresh() async {
    await getShiftScheduleById(state.shiftScheduleId);
  }

  Future<void> getShiftScheduleById(String shiftScheduleId) async {
    emit(state.copyWith(shiftSchedule: BaseState.loading()));

    final result = await getShiftScheduleByIdUseCase.call(shiftScheduleId);

    await result.fold(
      (failure) async {
        emit(state.copyWith(shiftSchedule: BaseState.failure(failure)));
      },
      (value) async {
        emit(
          state.copyWith(
            shiftSchedule: BaseState.success(value),
            form: state.form.copyWith(
              shiftSchedule: ShiftScheduleInput.dirty(value),
              date: DateInput.dirty(value.assignedDate),
              targetShiftSchedule: const TargetShiftScheduleInput.pure(),
            ),
            targetShiftSchedules: const BaseState.initial(),
          ),
        );

        final shiftDate = value.assignedDate;
        if (shiftDate != null) {
          await getAvailableTargetShiftSchedules(shiftDate, value.id);
        }
      },
    );
  }

  Future<void> getAvailableTargetShiftSchedules(
    DateTime shiftDate,
    String sourceShiftScheduleId,
  ) async {
    emit(state.copyWith(targetShiftSchedules: BaseState.loading()));

    final result = await getAvailableShiftsForSwapUseCase.call(
      GetAvailableShiftsForSwapParams(shiftDate: shiftDate),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(targetShiftSchedules: BaseState.failure(failure)),
      ),
      (value) {
        final filtered = value
            .where((v) => v.currentShift.id != sourceShiftScheduleId)
            .toList();
        var form = state.form;
        if (_request != null) {
          final selected =
              filtered
                  .where(
                    (v) => v.currentShift.id == _request!.targetSchedule.id,
                  )
                  .firstOrNull ??
              AvailableShiftForSwap(
                id: _request!.targetUser.id,
                currentShift: _request!.targetSchedule,
                user: _request!.targetUser,
              );
          if (!filtered.any((v) => v.currentShift.id == selected.currentShift.id)) {
            filtered.add(selected);
          }
          form = form.copyWith(
            targetShiftSchedule: TargetShiftScheduleInput.dirty(selected),
            reason: ReasonInput.dirty(_request!.alasan),
          );
        }
        emit(
          state.copyWith(
            targetShiftSchedules: BaseState.success(filtered),
            form: form,
          ),
        );
      },
    );
  }

  Future<void> onChangeDate(DateTime? value) async {
    emit(
      state.copyWith(
        form: state.form.copyWith(
          date: DateInput.dirty(value),
          targetShiftSchedule: const TargetShiftScheduleInput.pure(),
        ),
        targetShiftSchedules: const BaseState.initial(),
      ),
    );

    final shiftSchedule = state.form.shiftSchedule.value;
    if (value != null && shiftSchedule != null) {
      await getAvailableTargetShiftSchedules(value, shiftSchedule.id);
    }
  }

  void onChangeTargetShiftSchedule(AvailableShiftForSwap? value) {
    emit(
      state.copyWith(
        form: state.form.copyWith(
          targetShiftSchedule: TargetShiftScheduleInput.dirty(value),
        ),
      ),
    );
  }

  void onChangeReason(String? value) {
    emit(
      state.copyWith(
        form: state.form.copyWith(reason: ReasonInput.dirty(value)),
      ),
    );
  }

  Future<void> submit() async {
    final form = state.form.copyWith(
      shiftSchedule: ShiftScheduleInput.dirty(state.form.shiftSchedule.value),
      date: DateInput.dirty(state.form.date.value),
      targetShiftSchedule: TargetShiftScheduleInput.dirty(
        state.form.targetShiftSchedule.value,
      ),
      reason: ReasonInput.dirty(state.form.reason.value),
    );
    emit(state.copyWith(form: form));

    if (!form.isValid) return;

    emit(state.copyWith(submit: const BaseState.loading()));
    final source = form.shiftSchedule.value!;
    final target = form.targetShiftSchedule.value!;
    final params = CreateShiftSwapRequestParams(
      shiftScheduleId: source.id,
      targetUserId: target.user.id,
      targetScheduleId: target.currentShift.id,
      shiftDate: form.date.value!,
      targetShiftDate: target.currentShift.assignedDate,
      reason: form.reason.value!.trim(),
    );
    final result = _request == null
        ? await createShiftSwapRequestUseCase(params)
        : await repository.updateShiftSwapRequest(_request!.id, params);
    result.fold(
      (failure) => emit(state.copyWith(submit: BaseState.failure(failure))),
      (_) => emit(state.copyWith(submit: const BaseState.success(null))),
    );
  }
}
