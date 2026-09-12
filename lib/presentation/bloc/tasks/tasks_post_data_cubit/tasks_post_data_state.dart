part of 'tasks_post_data_cubit.dart';

class TasksPostDataState extends Equatable {
  final Failure? failure;
  final TypeState status;
  final TasksEntity? data;

  const TasksPostDataState({
    this.failure,
    this.status = TypeState.initial,
    this.data,
  });

  @override
  List<Object?> get props => [failure, status, data];

  TasksPostDataState copyWith({
    Failure? failure,
    TypeState? status,
    TasksEntity? data,
  }) {
    return TasksPostDataState(
      failure: failure ?? this.failure,
      status: status ?? this.status,
      data: data ?? this.data,
    );
  }
}
