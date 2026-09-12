part of 'tasks_get_all_success_cubit.dart';

class TasksGetAllSuccessState extends Equatable {
  final Failure? failure;
  final TypeState status;
  final List<TasksEntity>? tasks;
  final TasksFilterEntity? filter;
  final bool? hasMax;

  const TasksGetAllSuccessState({
    this.failure,
    this.status = TypeState.initial,
    this.tasks,
    this.filter,
    this.hasMax = false,
  });

  @override
  List<Object?> get props => [failure, status, tasks, filter, hasMax];

  TasksGetAllSuccessState copyWith({
    Failure? failure,
    TypeState? status,
    List<TasksEntity>? tasks,
    TasksFilterEntity? filter,
    bool? hasMax,
  }) {
    return TasksGetAllSuccessState(
      failure: failure ?? this.failure,
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      filter: filter ?? this.filter,
      hasMax: hasMax ?? this.hasMax,
    );
  }
}
