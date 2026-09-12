import 'package:freezed_annotation/freezed_annotation.dart';

part 'loan_form_state.freezed.dart';

@freezed
abstract class LoanFormState with _$LoanFormState {
  const factory LoanFormState({
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    String? errorMessage,
  }) = _LoanFormState;
}
