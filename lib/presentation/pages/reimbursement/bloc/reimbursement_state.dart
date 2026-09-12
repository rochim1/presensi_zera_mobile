import 'package:freezed_annotation/freezed_annotation.dart';

part 'reimbursement_state.freezed.dart';

@freezed
abstract class ReimbursementState with _$ReimbursementState {
  const factory ReimbursementState({
    DateTime? filterDate,
    DateTime? startDate,
    DateTime? endDate,
    String? filterStatus,
    @Default(0) int refreshCounter,
  }) = _ReimbursementState;
}
