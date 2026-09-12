import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_domain/presensi_domain.dart';

import 'approval_payroll_state.dart';

class ApprovalPayrollCubit extends Cubit<ApprovalPayrollState> {
  final GetMyPendingApprovals getMyPendingApprovalsUseCase;
  final CreateApproval createApprovalUseCase;

  ApprovalPayrollCubit({
    required this.getMyPendingApprovalsUseCase,
    required this.createApprovalUseCase,
  }) : super(const ApprovalPayrollState());

  Future<void> load() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await getMyPendingApprovalsUseCase.call(
      const GetMyPendingApprovalsParams(
        requestType: ApprovalRequestType.payroll_batch,
        page: 0,
        limit: 50,
      ),
    );
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (items) => emit(
        state.copyWith(isLoading: false, approvals: items, clearError: true),
      ),
    );
  }

  Future<bool> process({
    required ApprovalHistory approval,
    required AttendanceRequestApprovalAction action,
    String? reason,
  }) async {
    final requestId = approval.requestId;
    if (requestId == null || requestId.isEmpty || state.isSubmitting)
      return false;
    emit(state.copyWith(isSubmitting: true, clearError: true));
    final result = await createApprovalUseCase.call(
      CreateApprovalParams(
        requestId: requestId,
        requestType: ApprovalRequestType.payroll_batch,
        action: action,
        reason: reason?.trim(),
      ),
    );
    return result.fold(
      (failure) {
        emit(
          state.copyWith(isSubmitting: false, errorMessage: failure.message),
        );
        return false;
      },
      (_) {
        emit(
          state.copyWith(
            isSubmitting: false,
            approvals: state.approvals
                .where((item) => item.id != approval.id)
                .toList(),
            clearError: true,
          ),
        );
        return true;
      },
    );
  }
}
