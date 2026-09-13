import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

part 'tasks_get_all_success_state.dart';

TasksFilterEntity get isDone =>
    TasksFilterEntity(statusTask: StatusTask.done.toKey);

class TasksGetAllSuccessCubit extends Cubit<TasksGetAllSuccessState> {
  final TasksGetAllData tasksGetAllData;

  TasksGetAllSuccessCubit(this.tasksGetAllData)
    : super(const TasksGetAllSuccessState());

  Future<void> getAllData([DateTime? date]) async {
    if (state.hasMax!) return;

    if (state.status.isInitial) emit(state.copyWith(status: TypeState.loading));

    if (state.status.isLoading) return initLoadAllData(date);

    final params = isDone.copyWith(
      taskDateAssigned:
          date?.toIso8601String() ??
          state.filter?.taskDateAssigned ??
          DateTime.now().toIso8601String(),
      pagination: GlobalPaginationEntity(page: state.tasks?.length),
    );

    final Either<Failure, List<TasksEntity>> data = await tasksGetAllData.call(
      params,
    );

    data.fold(
      (failure) => emit(
        state.copyWith(
          status: TypeState.notLoaded,
          failure: failure,
          filter: params,
        ),
      ),
      (value) => emit(
        state.copyWith(
          status: TypeState.loaded,
          tasks: [...state.tasks ?? [], ...value],
          filter: params,
          hasMax: value.isEmpty,
        ),
      ),
    );
  }

  Future<void> initLoadAllData([DateTime? date]) async {
    final params = isDone.copyWith(
      taskDateAssigned: (date ?? DateTime.now()).toIso8601String(),
    );

    emit(state.copyWith(status: TypeState.loading, filter: params, tasks: []));

    final Either<Failure, List<TasksEntity>> data = await tasksGetAllData.call(
      params,
    );

    data.fold(
      (failure) => emit(
        state.copyWith(
          status: TypeState.notLoaded,
          failure: failure,
          filter: params,
        ),
      ),
      (value) => emit(
        state.copyWith(
          status: TypeState.loaded,
          tasks: value,
          filter: params,
          hasMax: value.length < LIMIT,
        ),
      ),
    );
  }
}
