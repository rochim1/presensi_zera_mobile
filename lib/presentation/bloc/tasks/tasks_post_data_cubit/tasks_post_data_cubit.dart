import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

part 'tasks_post_data_state.dart';

class TasksPostDataCubit extends Cubit<TasksPostDataState> {
  final TasksPostData tasksPostData;
  TasksPostDataCubit(this.tasksPostData) : super(const TasksPostDataState());

  Future<void> postData(TasksParamsEntity params) async {
    if (state.status.isLoading) return;

    emit(state.copyWith(status: TypeState.loading));
    final Either<Failure, TasksEntity> data = await tasksPostData.call(params);

    data.fold(
      (failure) =>
          emit(state.copyWith(status: TypeState.notLoaded, failure: failure)),
      (value) => emit(state.copyWith(status: TypeState.loaded, data: value)),
    );
  }
}
