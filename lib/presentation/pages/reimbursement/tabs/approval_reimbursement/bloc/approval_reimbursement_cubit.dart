import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

import '../formz/reason_input.dart';
import 'approval_reimbursement_state.dart';

class ApprovalReimbursementCubit extends Cubit<ApprovalReimbursementState> {
  final Logger logger;
  final GetMyPendingApprovals getMyPendingApprovalsUseCase;
  final GetReimbursementById getReimbursementByIdUseCase;
  final CreateApproval createApprovalUseCase;

  ApprovalReimbursementCubit({
    required this.logger,
    required this.getMyPendingApprovalsUseCase,
    required this.getReimbursementByIdUseCase,
    required this.createApprovalUseCase,
  }) : super(const ApprovalReimbursementState());

  static const int _limit = 10;

  GetMyPendingApprovalsParams _params({int page = 0}) {
    return GetMyPendingApprovalsParams(
      requestType: ApprovalRequestType.reimbursement,
      startDate: state.filterDate?.startOfMonth,
      endDate: state.filterDate?.endOfMonth,
      page: page,
      limit: _limit,
    );
  }

  Future<void> getReimbursements() async {
    if (state.reimbursements.isLoading) return;

    emit(state.copyWith(reimbursements: const BasePaginatedState.loading()));

    final params = _params();
    final result = await getMyPendingApprovalsUseCase.call(params);
    final failure = result.fold((failure) => failure, (_) => null);
    if (failure != null) {
      emit(state.copyWith(reimbursements: BasePaginatedState.failure(failure)));
      return;
    }

    final approvalHeaders = result.getOrElse(() => const []);
    final reimbursements = await _resolveReimbursements(approvalHeaders);
    emit(
      state.copyWith(
        reimbursements: BasePaginatedState.success(
          data: reimbursements,
          page: 0,
          hasReachedMax: approvalHeaders.length < _limit,
        ),
      ),
    );
  }

  Future<void> fetchNextPage() async {
    final current = state.reimbursements;
    if (current.hasReachedMax || current.isLoadingNext || current.isLoading) {
      return;
    }
    if (current.data.isEmpty) return;

    final nextPage = current.currentPage + 1;

    emit(
      state.copyWith(
        reimbursements: BasePaginatedState.loadingNext(
          data: current.data,
          page: nextPage,
          hasReachedMax: current.hasReachedMax,
        ),
      ),
    );

    final params = _params(page: nextPage);
    final result = await getMyPendingApprovalsUseCase.call(params);
    final failure = result.fold((failure) => failure, (_) => null);
    if (failure != null) {
      emit(
        state.copyWith(
          reimbursements: BasePaginatedState.success(
            data: current.data,
            page: current.currentPage,
            hasReachedMax: current.hasReachedMax,
          ),
        ),
      );
      return;
    }

    final approvalHeaders = result.getOrElse(() => const []);
    final resolvedRequests = await _resolveReimbursements(approvalHeaders);
    final newList = List<Reimbursement>.from(current.data)
      ..addAll(resolvedRequests);
    emit(
      state.copyWith(
        reimbursements: BasePaginatedState.success(
          data: newList,
          page: nextPage,
          hasReachedMax: approvalHeaders.length < _limit,
        ),
      ),
    );
  }

  void submitApproval(Reimbursement reimbursement) async {
    final approvalAction = state.approvalAction;
    final reasonInput = ReasonInput.dirty(
      state.reasonInput.value,
      action: approvalAction,
    );

    if (!approvalAction.isNone && reasonInput.isNotValid) return;

    emit(state.copyWith(approvalSubmit: BaseState.loading()));

    final params = CreateApprovalParams(
      requestId: reimbursement.id,
      requestType: ApprovalRequestType.reimbursement,
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
        getReimbursements();
      },
    );
  }

  void onChangeFilterDate(DateTime? value) {
    emit(state.copyWith(filterDate: value));
    getReimbursements();
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
    emit(state.copyWith(filterDate: DateTime.now()));
    getReimbursements();
  }

  Future<void> onRefresh() async {
    await getReimbursements();
  }

  Future<List<Reimbursement>> _resolveReimbursements(
    List<ApprovalHistory> approvalHeaders,
  ) async {
    final resolved = await Future.wait(
      approvalHeaders.map((approval) async {
        final requestId = approval.requestId;
        if (requestId == null || requestId.isEmpty) return null;

        final result = await getReimbursementByIdUseCase.call(requestId);
        return result.fold((failure) {
          logger.w(
            "ApprovalReimbursementCubit.getReimbursements skip requestId=$requestId failure=$failure",
          );
          return null;
        }, (value) => value);
      }),
    );

    return resolved.whereType<Reimbursement>().toList();
  }
}
