import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_mobile/core/_core.dart';
import '../formz/_formz.dart';

part 'request_state.freezed.dart';

@freezed
abstract class OvertimeRequestFormState with _$OvertimeRequestFormState {
  const factory OvertimeRequestFormState({
    @Default(OvertimeRequestFormInputs()) OvertimeRequestFormInputs form,
    @Default(BaseState.initial()) BaseState<void> submit,
  }) = _OvertimeRequestFormState;
}
