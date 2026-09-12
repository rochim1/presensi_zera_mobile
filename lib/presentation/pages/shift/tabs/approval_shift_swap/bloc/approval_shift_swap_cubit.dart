import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

import '../formz/reason_input.dart';
import 'approval_shift_swap_state.dart';

class ApprovalShiftSwapCubit extends Cubit<ApprovalShiftSwapState> {
  final Logger logger;
  final GetShiftSwapRequests getShiftSwapRequestsUseCase;
  final CreateShiftSwapRequestApproval createShiftSwapRequestApprovalUseCase;

  ApprovalShiftSwapCubit({
    required this.logger,
    required this.getShiftSwapRequestsUseCase,
    required this.createShiftSwapRequestApprovalUseCase,
  }) : super(const ApprovalShiftSwapState());

  static const int _limit = 10;

  GetShiftSwapRequestsParams _params({int page = 1}) {
    return GetShiftSwapRequestsParams(
      startDate: state.filterDate?.startOfMonth,
      endDate: state.filterDate?.endOfMonth,
      page: page,
      limit: _limit,
      status: RequestStatus.pending,
    );
  }

  Future<void> getShiftSwapRequests() async {
    if (state.swapRequests.isLoading) return;

    emit(state.copyWith(swapRequests: const BasePaginatedState.loading()));

    final result = await getShiftSwapRequestsUseCase.call(_params());

    result.fold(
      (failure) {
        emit(state.copyWith(swapRequests: BasePaginatedState.failure(failure)));
      },
      (value) {
        emit(
          state.copyWith(
            swapRequests: BasePaginatedState.success(
              data: value,
              page: 1,
              hasReachedMax: value.length < _limit,
            ),
          ),
        );
      },
    );
  }

  Future<void> fetchNextPage() async {
    final current = state.swapRequests;
    if (current.hasReachedMax || current.isLoadingNext || current.isLoading) {
      return;
    }
    if (current.data.isEmpty) return;

    final nextPage = current.currentPage + 1;

    emit(
      state.copyWith(
        swapRequests: BasePaginatedState.loadingNext(
          data: current.data,
          page: nextPage,
          hasReachedMax: current.hasReachedMax,
        ),
      ),
    );

    final result = await getShiftSwapRequestsUseCase.call(
      _params(page: nextPage),
    );

    result.fold(
      (failure) {
        // Revert to success without advancing the page
        emit(
          state.copyWith(
            swapRequests: BasePaginatedState.success(
              data: current.data,
              page: current.currentPage,
              hasReachedMax: current.hasReachedMax,
            ),
          ),
        );
      },
      (value) {
        final newList = List<ShiftSwapRequest>.from(current.data)
          ..addAll(value);
        emit(
          state.copyWith(
            swapRequests: BasePaginatedState.success(
              data: newList,
              page: nextPage,
              hasReachedMax: value.length < _limit,
            ),
          ),
        );
      },
    );
  }

  Future<void> submitApproval(ShiftSwapRequest request) async {
    final approvalAction = state.approvalAction;
    if (approvalAction == null) return;

    final reasonInput = ReasonInput.dirty(
      state.reasonInput.value,
      action: approvalAction,
    );
    final rejectedReason = reasonInput.value?.trim();
    emit(state.copyWith(reasonInput: reasonInput));
    if (reasonInput.isNotValid) return;

    emit(state.copyWith(approvalSubmit: BaseState.loading()));

    final params = CreateShiftSwapRequestApprovalParams(
      swapRequestId: request.id,
      status: approvalAction,
      rejectedReason: approvalAction == RequestStatus.rejected
          ? rejectedReason
          : null,
    );
    final result = await createShiftSwapRequestApprovalUseCase.call(params);

    result.fold(
      (failure) {
        emit(state.copyWith(approvalSubmit: BaseState.failure(failure)));
      },
      (_) {
        emit(state.copyWith(approvalSubmit: BaseState.success(null)));
        getShiftSwapRequests();
      },
    );
  }

  void onChangeFilterDate(DateTime? value) {
    emit(state.copyWith(filterDate: value));
    getShiftSwapRequests();
  }

  void onChangeApprovalAction(RequestStatus? value) {
    emit(
      state.copyWith(
        approvalAction: value,
        reasonInput: ReasonInput.pure(action: value),
        approvalSubmit: const BaseState.initial(),
      ),
    );
  }

  void onChangeReason(String? value) {
    emit(
      state.copyWith(
        reasonInput: ReasonInput.dirty(value, action: state.approvalAction),
      ),
    );
  }

  void init() {
    emit(state.copyWith(filterDate: DateTime.now()));
    getShiftSwapRequests();
  }

  Future<void> onRefresh() async {
    await getShiftSwapRequests();
  }
}
