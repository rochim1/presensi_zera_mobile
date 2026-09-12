part of 'tasks_post_completed_cubit.dart';

class TasksPostCompletedState extends Equatable {
  final Failure? failure;
  final TypeState status;
  final TasksEntity? data;

  const TasksPostCompletedState({
    this.failure,
    this.status = TypeState.initial,
    this.data,
  });

  @override
  List<Object?> get props => [failure, status, data];

  TasksPostCompletedState copyWith({
    Failure? failure,
    TypeState? status,
    TasksEntity? data,
  }) {
    return TasksPostCompletedState(
      failure: failure ?? this.failure,
      status: status ?? this.status,
      data: data ?? this.data,
    );
  }
}
