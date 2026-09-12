import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

import '../formz/reason_input.dart';
import 'approval_state.dart';

class OvertimeRequestApprovalCubit extends Cubit<OvertimeRequestApprovalState> {
  final GetMyPendingApprovals getMyPendingApprovalsUseCase;
  final GetOvertimeRequestById getOvertimeRequestByIdUseCase;
  final CreateApproval createApprovalUseCase;
  final Logger logger;

  OvertimeRequestApprovalCubit({
    required this.logger,
    required this.getMyPendingApprovalsUseCase,
    required this.getOvertimeRequestByIdUseCase,
    required this.createApprovalUseCase,
  }) : super(const OvertimeRequestApprovalState());

  static const int _limit = 10;

  Future<void> getOvertimeRequests() async {
    if (state.overtimeRequests.isLoading) return;

    emit(state.copyWith(overtimeRequests: const BasePaginatedState.loading()));

    final params = GetMyPendingApprovalsParams(
      requestType: ApprovalRequestType.lembur,
      startDate: state.filterDate?.startOfMonth,
      endDate: state.filterDate?.endOfMonth,
      page: 0,
      limit: _limit,
    );
    final result = await getMyPendingApprovalsUseCase.call(params);
    final failure = result.fold((failure) => failure, (_) => null);
    if (failure != null) {
      emit(
        state.copyWith(overtimeRequests: BasePaginatedState.failure(failure)),
      );
      return;
    }

    final approvalHeaders = result.getOrElse(() => const []);
    final overtimeRequests = await _resolveOvertimeRequests(approvalHeaders);
    emit(
      state.copyWith(
        overtimeRequests: BasePaginatedState.success(
          data: overtimeRequests,
          page: 0,
          hasReachedMax: approvalHeaders.length < _limit,
        ),
      ),
    );
  }

  void fetchNextPage() async {
    final current = state.overtimeRequests;
    if (current.hasReachedMax || current.isLoadingNext || current.isLoading) {
      return;
    }

    final nextPage = current.currentPage + 1;

    emit(
      state.copyWith(
        overtimeRequests: BasePaginatedState.loadingNext(
          data: current.data,
          page: nextPage,
          hasReachedMax: current.hasReachedMax,
        ),
      ),
    );

    final params = GetMyPendingApprovalsParams(
      requestType: ApprovalRequestType.lembur,
      startDate: state.filterDate?.startOfMonth,
      endDate: state.filterDate?.endOfMonth,
      page: nextPage,
      limit: _limit,
    );
    final result = await getMyPendingApprovalsUseCase.call(params);
    final failure = result.fold((failure) => failure, (_) => null);
    if (failure != null) {
      emit(
        state.copyWith(
          overtimeRequests: BasePaginatedState.success(
            data: current.data,
            page: current.currentPage,
            hasReachedMax: current.hasReachedMax,
          ),
        ),
      );
      return;
    }

    final approvalHeaders = result.getOrElse(() => const []);
    final resolvedRequests = await _resolveOvertimeRequests(approvalHeaders);
    final newList = List<OvertimeRequest>.from(current.data)
      ..addAll(resolvedRequests);
    emit(
      state.copyWith(
        overtimeRequests: BasePaginatedState.success(
          data: newList,
          page: nextPage,
          hasReachedMax: approvalHeaders.length < _limit,
        ),
      ),
    );
  }

  void submitApproval(OvertimeRequest request) async {
    final approvalAction = state.approvalAction;
    final reasonInput = ReasonInput.dirty(
      state.reasonInput.value,
      action: approvalAction,
    );

    if (!approvalAction.isNone && reasonInput.isNotValid) return;

    emit(state.copyWith(approvalSubmit: BaseState.loading()));

    final params = CreateApprovalParams(
      requestId: request.id,
      requestType: ApprovalRequestType.lembur,
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
        getOvertimeRequests();
      },
    );
  }

  void onChangeFilterDate(DateTime? date) {
    emit(state.copyWith(filterDate: date));
    getOvertimeRequests();
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

  Future<void> onRefresh() async {
    await getOvertimeRequests();
  }

  Future<List<OvertimeRequest>> _resolveOvertimeRequests(
    List<ApprovalHistory> approvalHeaders,
  ) async {
    final resolved = await Future.wait(
      approvalHeaders.map((approval) async {
        final requestId = approval.requestId;
        if (requestId == null || requestId.isEmpty) return null;

        final result = await getOvertimeRequestByIdUseCase.call(requestId);
        return result.fold((failure) {
          logger.w(
            "OvertimeRequestApprovalCubit.getOvertimeRequests skip requestId=$requestId failure=$failure",
          );
          return null;
        }, (value) => value);
      }),
    );

    return resolved.whereType<OvertimeRequest>().toList();
  }
}
