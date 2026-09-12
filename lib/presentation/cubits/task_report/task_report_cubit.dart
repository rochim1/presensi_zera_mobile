import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_domain/src/entities/task_report/task_report.dart';
import 'package:presensi_domain/src/repositories/task_report_repository.dart';
import 'package:intl/intl.dart';

part 'task_report_state.dart';

class TaskReportCubit extends Cubit<TaskReportState> {
  final TaskReportRepository repository;

  TaskReportCubit(this.repository) : super(TaskReportInitial());

  Future<void> loadMyReport({String? periode}) async {
    emit(TaskReportLoading());
    try {
      // Default to current month "YYYY-MM"
      final targetPeriode = periode ?? DateFormat('yyyy-MM').format(DateTime.now());
      final result = await repository.getMyTaskReportSummary(
        tipeLaporan: 'bulanan',
        periode: targetPeriode,
      );

      if (result != null) {
        emit(TaskReportLoaded(result, targetPeriode));
      } else {
        emit(TaskReportEmpty(targetPeriode));
      }
    } catch (e) {
      emit(TaskReportError(e.toString()));
    }
  }
}
