part of 'tasks_get_all_pending_cubit.dart';

class TasksGetAllPendingState extends Equatable {
  final Failure? failure;
  final TypeState status;
  final List<TasksEntity>? tasks;
  final TasksFilterEntity? filter;
  final bool? hasMax;

  const TasksGetAllPendingState({
    this.failure,
    this.status = TypeState.initial,
    this.tasks,
    this.filter,
    this.hasMax = false,
  });

  @override
  List<Object?> get props => [failure, status, tasks, filter, hasMax];

  TasksGetAllPendingState copyWith({
    Failure? failure,
    TypeState? status,
    List<TasksEntity>? tasks,
    TasksFilterEntity? filter,
    bool? hasMax,
  }) {
    return TasksGetAllPendingState(
      failure: failure ?? this.failure,
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      filter: filter ?? this.filter,
      hasMax: hasMax ?? this.hasMax,
    );
  }
}
