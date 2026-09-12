import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

part 'survey_state.freezed.dart';

@freezed
abstract class SurveyState with _$SurveyState {
  const factory SurveyState({
    @Default(BasePaginatedState.initial()) BasePaginatedState<Survey> surveys,
  }) = _SurveyState;
}
