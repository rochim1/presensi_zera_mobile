import 'package:equatable/equatable.dart';
import 'package:presensi_domain/presensi_domain.dart';

class ApprovalPayrollState extends Equatable {
  final bool isLoading;
  final bool isSubmitting;
  final List<ApprovalHistory> approvals;
  final String? errorMessage;

  const ApprovalPayrollState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.approvals = const [],
    this.errorMessage,
  });

  ApprovalPayrollState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    List<ApprovalHistory>? approvals,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ApprovalPayrollState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      approvals: approvals ?? this.approvals,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, isSubmitting, approvals, errorMessage];
}
