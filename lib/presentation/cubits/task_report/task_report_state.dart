part of 'task_report_cubit.dart';

abstract class TaskReportState extends Equatable {
  const TaskReportState();

  @override
  List<Object?> get props => [];
}

class TaskReportInitial extends TaskReportState {}

class TaskReportLoading extends TaskReportState {}

class TaskReportLoaded extends TaskReportState {
  final TaskReportSummary summary;
  final String periode;

  const TaskReportLoaded(this.summary, this.periode);

  @override
  List<Object?> get props => [summary, periode];
}

class TaskReportEmpty extends TaskReportState {
  final String periode;

  const TaskReportEmpty(this.periode);

  @override
  List<Object?> get props => [periode];
}

class TaskReportError extends TaskReportState {
  final String message;

  const TaskReportError(this.message);

  @override
  List<Object?> get props => [message];
}
