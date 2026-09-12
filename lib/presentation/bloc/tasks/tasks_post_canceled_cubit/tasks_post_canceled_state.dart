part of 'tasks_post_canceled_cubit.dart';

class TasksPostCanceledState extends Equatable {
  final Failure? failure;
  final TypeState status;
  final TasksEntity? data;

  const TasksPostCanceledState({
    this.failure,
    this.status = TypeState.initial,
    this.data,
  });

  @override
  List<Object?> get props => [failure, status, data];

  TasksPostCanceledState copyWith({
    Failure? failure,
    TypeState? status,
    TasksEntity? data,
  }) {
    return TasksPostCanceledState(
      failure: failure ?? this.failure,
      status: status ?? this.status,
      data: data ?? this.data,
    );
  }
}
