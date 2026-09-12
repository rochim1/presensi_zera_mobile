import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';
import '../formz/_formz.dart';

part 'request_state.freezed.dart';

@freezed
abstract class ReimbursementRequestFormState
    with _$ReimbursementRequestFormState {
  const factory ReimbursementRequestFormState({
    @Default(ReimbursementRequestFormInputs())
    ReimbursementRequestFormInputs form,
    @Default(BaseState.initial()) BaseState<void> submit,
    @Default(BaseState.initial())
    BaseState<List<ReimbursementCategory>> categories,
  }) = _ReimbursementRequestFormState;
}
