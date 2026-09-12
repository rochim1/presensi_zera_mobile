import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

part 'tasks_post_canceled_state.dart';

class TasksPostCanceledCubit extends Cubit<TasksPostCanceledState> {
  final TasksPostCanceled tasksPostCanceled;
  TasksPostCanceledCubit(this.tasksPostCanceled)
    : super(const TasksPostCanceledState());

  Future<void> postCanceled(TasksCanceledParamsEntity params) async {
    if (state.status == TypeState.loading) return;
    emit(state.copyWith(status: TypeState.loading));
    final Either<Failure, TasksEntity> data = await tasksPostCanceled.call(
      params,
    );

    data.fold(
      (failure) =>
          emit(state.copyWith(status: TypeState.notLoaded, failure: failure)),
      (value) => emit(state.copyWith(status: TypeState.loaded, data: value)),
    );
  }
}
