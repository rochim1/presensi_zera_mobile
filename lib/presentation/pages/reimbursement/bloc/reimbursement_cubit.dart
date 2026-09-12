import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';

import 'reimbursement_state.dart';

class ReimbursementCubit extends Cubit<ReimbursementState> {
  final Logger logger;

  ReimbursementCubit({required this.logger})
    : super(const ReimbursementState());

  void onChangeFilterDate(DateTime? value) {
    emit(state.copyWith(filterDate: value));
  }

  void applyFilters({DateTime? startDate, DateTime? endDate, String? status}) {
    emit(
      state.copyWith(
        startDate: startDate,
        endDate: endDate,
        filterStatus: status,
        filterDate: startDate,
      ),
    );
  }

  void triggerRefresh() {
    emit(state.copyWith(refreshCounter: state.refreshCounter + 1));
  }

  void init() {
    onChangeFilterDate(DateTime.now());
  }
}
