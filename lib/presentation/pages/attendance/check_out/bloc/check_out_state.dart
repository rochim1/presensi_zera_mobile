import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

import '../form/check_out_form.dart';

part 'check_out_state.freezed.dart';

@freezed
abstract class CheckOutState with _$CheckOutState {
  const factory CheckOutState({
    @Default(CheckOutForm()) CheckOutForm form,
    @Default(BaseState.initial()) BaseState<void> checkOut,
    @Default(false) bool queuedOffline,
    @Default(BaseState.initial()) BaseState<AppAddress> currentAddress,
    @Default(AttendanceType.daily) AttendanceType type,
    @Default('') String currentTime,
    @Default(SettingAttendanceMode.foto) SettingAttendanceMode attendanceMode,
    @Default(BaseState.initial())
    BaseState<LogbookCheckoutPolicyTestResult> policyState,
    LogbookCheckoutPolicyTestResult? logbookPolicyResult,
  }) = _CheckOutState;
}
