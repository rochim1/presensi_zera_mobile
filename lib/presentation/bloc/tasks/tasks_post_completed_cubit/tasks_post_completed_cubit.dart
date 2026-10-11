import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

part 'tasks_post_completed_state.dart';

class TasksPostCompletedCubit extends Cubit<TasksPostCompletedState> {
  final TasksPostCompleted tasksPostCompleted;
  TasksPostCompletedCubit(this.tasksPostCompleted)
    : super(const TasksPostCompletedState());

  Future<void> postCompleted(TasksCompletedParamsEntity params) async {
    if (isClosed ||
        state.status == TypeState.loading ||
        state.status == TypeState.loaded) {
      return;
    }
    try {
      emit(state.copyWith(status: TypeState.loading));
      final Either<Failure, TasksEntity> data = await tasksPostCompleted.call(
        params,
      );

      if (isClosed) return;
      data.fold(
        (failure) =>
            emit(state.copyWith(status: TypeState.notLoaded, failure: failure)),
        (value) => emit(state.copyWith(status: TypeState.loaded, data: value)),
      );
    } catch (_) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: TypeState.notLoaded,
            failure: UnknownFailure(
              message: 'Kunjungan gagal diproses, silakan coba lagi',
            ),
          ),
        );
      }
    }
  }
}
