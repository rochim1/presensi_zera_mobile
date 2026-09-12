import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import '../formz/_formz.dart';

part 'request_state.freezed.dart';

@freezed
abstract class LeaveRequestState with _$LeaveRequestState {
  const factory LeaveRequestState({
    @Default(BaseState.initial())
    BaseState<List<LeaveCategory>> leaveCategories,
    @Default(BaseState.initial()) BaseState<List<User>> users,
    @Default(LeaveRequestForm()) LeaveRequestForm form,
    @Default(BaseState.initial()) BaseState<void> submit,
    @Default(BaseState.initial())
    BaseState<Map<String, dynamic>> cutiQuota,
  }) = _LeaveRequestState;
}
