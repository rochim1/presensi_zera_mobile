import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'incidental_report_form_state.freezed.dart';

@freezed
abstract class IncidentalReportFormState with _$IncidentalReportFormState {
  const factory IncidentalReportFormState({
    @Default(false) bool isLoadingItems,
    @Default([]) List<InventarisItem> items,
    @Default(false) bool isSubmitting,
    @Default(false) bool isSuccess,
    Failure? failure,
  }) = _IncidentalReportFormState;
}
