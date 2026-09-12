import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_data/core/_core.dart';

import 'leave_state.dart';

class LeaveCubit extends Cubit<LeaveState> {
  final Logger logger;
  final TestWorkflowUserUseCase testWorkflowUserUseCase;
  final GetAuthSession getAuthSessionUseCase;

  LeaveCubit({
    required this.logger,
    required this.testWorkflowUserUseCase,
    required this.getAuthSessionUseCase,
  }) : super(const LeaveState());

  void onChangeFilterDate(DateTime? value) {
    emit(state.copyWith(filterDate: value));
  }

  void applyFilters({DateTime? startDate, DateTime? endDate}) {
    emit(
      state.copyWith(
        startDate: startDate,
        endDate: endDate,
        filterDate: startDate,
      ),
    );
  }

  void triggerRefresh() {
    emit(state.copyWith(refreshCounter: state.refreshCounter + 1));
  }

  void init() {
    final now = DateTime.now();
    applyFilters(
      startDate: DateTime(now.year, now.month, 1),
      endDate: DateTime(now.year, now.month + 1, 0),
    );
    _checkIfApprover();
  }

  Future<void> _checkIfApprover() async {
    try {
      final sessionResult = await getAuthSessionUseCase.call(NoParams());
      await sessionResult.fold((_) async {}, (session) async {
        if (session.userId.isEmpty) return;
        final result = await testWorkflowUserUseCase.call(
          TestWorkflowUserParams(module: 'cuti', testUserId: session.userId),
        );
        result.fold((_) {}, (response) {
          final isApprover =
              response.levels?.any((level) => level.userIsApprover == true) ??
              false;
          if (isApprover) emit(state.copyWith(isApprover: true));
        });
      });
    } catch (error, stackTrace) {
      logger.e(
        'Gagal memeriksa akses approval cuti',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
