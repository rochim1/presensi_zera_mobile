import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

part 'tasks_get_all_pending_state.dart';

TasksFilterEntity get isPending =>
    TasksFilterEntity(statusTask: StatusTask.pending.toKey);

class TasksGetAllPendingCubit extends Cubit<TasksGetAllPendingState> {
  final TasksGetAllData tasksGetAllData;

  TasksGetAllPendingCubit(this.tasksGetAllData)
    : super(const TasksGetAllPendingState());

  Future<void> getAllData() async {
    if (state.hasMax!) return;

    if (state.status.isInitial) emit(state.copyWith(status: TypeState.loading));

    if (state.status.isLoading) return initLoadAllData();

    final params = isPending.copyWith(
      taskDateAssigned: DateTime.now().toIso8601String(),
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
          tasks: [],
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

  Future<void> initLoadAllData() async {
    final params = isPending.copyWith(
      taskDateAssigned: DateTime.now().toIso8601String(),
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
          tasks: [],
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
