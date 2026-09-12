import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

part 'tasks_get_all_perjalanan_state.dart';

TasksFilterEntity get isPerjalanan => TasksFilterEntity(
  statusTasks: [StatusTask.done.toKey, StatusTask.cancel.toKey],
  taskDateAssigned: DateTime.now().toIso8601String(),
);

class TasksGetAllPerjalananCubit extends Cubit<TasksGetAllPerjalananState> {
  final TasksGetAllPerjalanan tasksGetAllPerjalanan;

  TasksGetAllPerjalananCubit(this.tasksGetAllPerjalanan)
    : super(TasksGetAllPerjalananState(filter: isPerjalanan));
  Future<void> getAllData([DateTime? date]) async {
    if (state.hasMax!) return;

    if (state.status.isInitial) emit(state.copyWith(status: TypeState.loading));

    if (state.status.isLoading) return initLoadAllData(date);

    final params = isPerjalanan.copyWith(
      taskDateAssigned: (date ?? DateTime.now()).toIso8601String(),
      pagination: GlobalPaginationEntity(
        page: ((state.tasks?.length ?? 0) - 1),
      ),
    );

    final Either<Failure, List<TasksEntity>> data = await tasksGetAllPerjalanan
        .call(params);

    data.fold(
      (failure) => emit(
        state.copyWith(
          status: TypeState.notLoaded,
          failure: failure,
          tasks: state.tasks,
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
    final params = isPerjalanan.copyWith(
      taskDateAssigned: (date ?? DateTime.now()).toIso8601String(),
    );

    final Either<Failure, List<TasksEntity>> data = await tasksGetAllPerjalanan
        .call(params);

    data.fold(
      (failure) => emit(
        state.copyWith(
          status: TypeState.notLoaded,
          failure: failure,
          filter: params,
        ),
      ),
      (value) {
        if (value.isEmpty) {
          return emit(
            state.copyWith(
              status: TypeState.notLoaded,
              failure: const NotFoundFailure(),
              filter: params,
            ),
          );
        }

        final newValue = value..insert(0, value.first);
        emit(
          state.copyWith(
            status: TypeState.loaded,
            tasks: newValue,
            filter: params,
            hasMax: value.length < LIMIT,
          ),
        );
      },
    );
  }
}
