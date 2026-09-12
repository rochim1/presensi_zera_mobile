import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

import '../formz/reason_input.dart';
import 'approval_state.dart';

class AttendanceRequestApprovalCubit
    extends Cubit<AttendanceRequestApprovalState> {
  final GetMyPendingApprovals getMyPendingApprovalsUseCase;
  final CreateApproval createApprovalUseCase;
  final Logger logger;

  AttendanceRequestApprovalCubit({
    required this.logger,
    required this.getMyPendingApprovalsUseCase,
    required this.createApprovalUseCase,
  }) : super(const AttendanceRequestApprovalState());

  static const int _limit = 10;

  void getAttendanceRequests() async {
    if (state.approvals.isLoading) return;

    emit(state.copyWith(approvals: const BasePaginatedState.loading()));

    final params = GetMyPendingApprovalsParams(
      requestType: ApprovalRequestType.request_presensi,
      startDate: state.filterDate?.startOfMonth,
      endDate: state.filterDate?.endOfMonth,
      page: 0,
      limit: _limit,
    );
    final result = await getMyPendingApprovalsUseCase.call(params);

    result.fold(
      (failure) {
        emit(state.copyWith(approvals: BasePaginatedState.failure(failure)));
      },
      (approvals) {
        final validApprovals = _onlyCompleteApprovals(approvals);
        emit(
          state.copyWith(
            approvals: BasePaginatedState.success(
              data: validApprovals,
              page: 1,
              hasReachedMax: approvals.length < _limit,
            ),
          ),
        );
      },
    );
  }

  void fetchNextPage() async {
    final current = state.approvals;
    if (current.hasReachedMax || current.isLoadingNext || current.isLoading) {
      return;
    }
    if (current.data.isEmpty) return;

    final nextPage = current.currentPage + 1;

    emit(
      state.copyWith(
        approvals: BasePaginatedState.loadingNext(
          data: current.data,
          page: nextPage,
          hasReachedMax: current.hasReachedMax,
        ),
      ),
    );

    final params = GetMyPendingApprovalsParams(
      requestType: ApprovalRequestType.request_presensi,
      startDate: state.filterDate?.startOfMonth,
      endDate: state.filterDate?.endOfMonth,
      page: nextPage,
      limit: _limit,
    );
    final result = await getMyPendingApprovalsUseCase.call(params);

    result.fold(
      (failure) {
        // Revert to success without advancing the page
        emit(
          state.copyWith(
            approvals: BasePaginatedState.success(
              data: current.data,
              page: current.currentPage,
              hasReachedMax: current.hasReachedMax,
            ),
          ),
        );
      },
      (approvals) {
        final validApprovals = _onlyCompleteApprovals(approvals);
        final newList = List<ApprovalHistory>.from(current.data)
          ..addAll(validApprovals);
        emit(
          state.copyWith(
            approvals: BasePaginatedState.success(
              data: newList,
              page: nextPage,
              hasReachedMax: approvals.length < _limit,
            ),
          ),
        );
      },
    );
  }

  void submitApproval(AttendanceRequest request) async {
    final approvalAction = state.approvalAction;
    final reasonInput = ReasonInput.dirty(
      state.reasonInput.value,
      action: approvalAction,
    );

    if (!approvalAction.isNone && reasonInput.isNotValid) return;

    emit(state.copyWith(approvalSubmit: BaseState.loading()));

    final params = CreateApprovalParams(
      requestId: request.id,
      requestType: ApprovalRequestType.request_presensi,
      action: approvalAction,
      reason: reasonInput.value,
    );
    final result = await createApprovalUseCase.call(params);

    result.fold(
      (failure) {
        emit(state.copyWith(approvalSubmit: BaseState.failure(failure)));
      },
      (_) {
        emit(state.copyWith(approvalSubmit: BaseState.success(null)));
        getAttendanceRequests();
      },
    );
  }

  void onChangeFilterDate(DateTime? date) {
    emit(state.copyWith(filterDate: date));
    getAttendanceRequests();
  }

  void onChangeApprovalAction(AttendanceRequestApprovalAction value) {
    emit(state.copyWith(approvalAction: value));
  }

  void onChangeReason(String? value) {
    emit(
      state.copyWith(
        reasonInput: ReasonInput.dirty(value, action: state.approvalAction),
      ),
    );
  }

  void init() {
    onChangeFilterDate(DateTime.now());
  }

  void onRefresh() {
    getAttendanceRequests();
  }

  List<ApprovalHistory> _onlyCompleteApprovals(
    List<ApprovalHistory> approvals,
  ) {
    final incomplete = approvals.where(
      (approval) => approval.attendanceRequest == null,
    );
    for (final approval in incomplete) {
      logger.w(
        'AttendanceRequestApprovalCubit skip approval=${approval.id} '
        'requestId=${approval.requestId}: request_presensi is null',
      );
    }
    return approvals
        .where((approval) => approval.attendanceRequest != null)
        .toList();
  }
}
