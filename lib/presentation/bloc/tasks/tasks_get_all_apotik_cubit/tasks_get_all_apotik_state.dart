part of 'tasks_get_all_apotik_cubit.dart';

class TasksGetAllApotikState extends Equatable {
  final Failure? failure;
  final TypeState status;
  final List<ApotekEntity>? lstApotik;

  const TasksGetAllApotikState({
    this.failure,
    this.status = TypeState.initial,
    this.lstApotik,
  });

  @override
  List<Object?> get props => [failure, status, lstApotik];

  TasksGetAllApotikState copyWith({
    Failure? failure,
    TypeState? status,
    List<ApotekEntity>? lstApotik,
  }) {
    return TasksGetAllApotikState(
      failure: failure ?? this.failure,
      status: status ?? this.status,
      lstApotik: lstApotik ?? this.lstApotik,
    );
  }
}
