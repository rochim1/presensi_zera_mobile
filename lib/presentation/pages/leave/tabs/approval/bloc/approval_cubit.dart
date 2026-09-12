import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/pages/leave/tabs/approval/formz/reason_input.dart';

import 'approval_state.dart';

class LeaveApprovalCubit extends Cubit<LeaveApprovalState> {
  final GetMyPendingApprovals getMyPendingApprovalsUseCase;
  final GetLeaveRequestById getLeaveRequestByIdUseCase;
  final CreateApproval createApprovalUseCase;
  final Logger logger;

  LeaveApprovalCubit({
    required this.logger,
    required this.getMyPendingApprovalsUseCase,
    required this.getLeaveRequestByIdUseCase,
    required this.createApprovalUseCase,
  }) : super(const LeaveApprovalState());

  static const int _limit = 10;

  Future<void> getLeaveRequests() async {
    if (state.leaveRequests.isLoading) return;

    emit(state.copyWith(leaveRequests: const BasePaginatedState.loading()));

    final params = GetMyPendingApprovalsParams(
      requestType: ApprovalRequestType.cuti,
      startDate: state.filterDate?.startOfMonth,
      endDate: state.filterDate?.endOfMonth,
      page: 0,
      limit: _limit,
    );
    final result = await getMyPendingApprovalsUseCase.call(params);

    final failure = result.fold((f) => f, (_) => null);
    if (failure != null) {
      emit(state.copyWith(leaveRequests: BasePaginatedState.failure(failure)));
      return;
    }

    final approvalHeaders = result.getOrElse(() => const []);
    final leaveRequests = await _resolveLeaveRequests(approvalHeaders);
    emit(
      state.copyWith(
        leaveRequests: BasePaginatedState.success(
          data: leaveRequests,
          page: 0,
          hasReachedMax: approvalHeaders.length < _limit,
        ),
      ),
    );
  }

  Future<void> fetchNextPage() async {
    final current = state.leaveRequests;
    if (current.hasReachedMax || current.isLoadingNext || current.isLoading) {
      return;
    }
    if (current.data.isEmpty) return;

    final nextPage = current.currentPage + 1;

    emit(
      state.copyWith(
        leaveRequests: BasePaginatedState.loadingNext(
          data: current.data,
          page: nextPage,
          hasReachedMax: current.hasReachedMax,
        ),
      ),
    );

    final params = GetMyPendingApprovalsParams(
      requestType: ApprovalRequestType.cuti,
      startDate: state.filterDate?.startOfMonth,
      endDate: state.filterDate?.endOfMonth,
      page: nextPage,
      limit: _limit,
    );
    final result = await getMyPendingApprovalsUseCase.call(params);

    final failure = result.fold((f) => f, (_) => null);
    if (failure != null) {
      emit(
        state.copyWith(
          leaveRequests: BasePaginatedState.success(
            data: current.data,
            page: current.currentPage,
            hasReachedMax: current.hasReachedMax,
          ),
        ),
      );
      return;
    }

    final approvalHeaders = result.getOrElse(() => const []);
    final resolvedRequests = await _resolveLeaveRequests(approvalHeaders);
    final newList = List<LeaveRequest>.from(current.data)
      ..addAll(resolvedRequests);
    emit(
      state.copyWith(
        leaveRequests: BasePaginatedState.success(
          data: newList,
          page: nextPage,
          hasReachedMax: approvalHeaders.length < _limit,
        ),
      ),
    );
  }

  void submitApproval(LeaveRequest request) async {
    final approvalAction = state.approvalAction;
    final reasonInput = ReasonInput.dirty(
      state.reasonInput.value,
      approvalAction: approvalAction,
    );

    if (!approvalAction.isNone && reasonInput.isNotValid) return;

    emit(state.copyWith(approvalSubmit: BaseState.loading()));

    final params = CreateApprovalParams(
      requestId: request.id,
      requestType: ApprovalRequestType.cuti,
      action: approvalAction.toAttendanceRequestApprovalAction(),
      reason: reasonInput.value,
    );
    final result = await createApprovalUseCase.call(params);

    result.fold(
      (failure) {
        emit(state.copyWith(approvalSubmit: BaseState.failure(failure)));
      },
      (_) {
        emit(state.copyWith(approvalSubmit: BaseState.success(null)));
        getLeaveRequests();
      },
    );
  }

  void onChangeFilterDate(DateTime? date) {
    emit(state.copyWith(filterDate: date));
    getLeaveRequests();
  }

  void onChangeApprovalAction(LeaveApprovalAction value) {
    emit(
      state.copyWith(approvalAction: value, reasonInput: ReasonInput.pure()),
    );
  }

  void onChangeReason(String? value) {
    emit(
      state.copyWith(
        reasonInput: ReasonInput.dirty(
          value,
          approvalAction: state.approvalAction,
        ),
      ),
    );
  }

  void init() {
    onChangeFilterDate(DateTime.now());
  }

  Future<void> onRefresh() async {
    await getLeaveRequests();
  }

  Future<List<LeaveRequest>> _resolveLeaveRequests(
    List<ApprovalHistory> approvalHeaders,
  ) async {
    final resolved = await Future.wait(
      approvalHeaders.map((approval) async {
        final requestId = approval.requestId;
        if (requestId == null || requestId.isEmpty) return null;

        final result = await getLeaveRequestByIdUseCase.call(requestId);
        return result.fold((failure) {
          logger.w(
            "LeaveApprovalCubit.getLeaveRequests skip requestId=$requestId failure=$failure",
          );
          return null;
        }, (value) => value);
      }),
    );

    return resolved.whereType<LeaveRequest>().toList();
  }
}
