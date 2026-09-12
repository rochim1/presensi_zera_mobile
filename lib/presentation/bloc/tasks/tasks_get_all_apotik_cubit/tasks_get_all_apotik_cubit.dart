import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

part 'tasks_get_all_apotik_state.dart';

class TasksGetAllApotikCubit extends Cubit<TasksGetAllApotikState> {
  final TasksGetAllApotek tasksGetAllApotik;

  TasksGetAllApotikCubit(this.tasksGetAllApotik)
    : super(const TasksGetAllApotikState());

  Future<void> getAllDataSearch() async {
    emit(state.copyWith(status: TypeState.loading));

    final Either<Failure, List<ApotekEntity>> data = await tasksGetAllApotik
        .call(NoParams());

    data.fold(
      (failure) => emit(
        state.copyWith(
          status: TypeState.notLoaded,
          failure: failure,
          lstApotik: [],
        ),
      ),
      (value) =>
          emit(state.copyWith(status: TypeState.loaded, lstApotik: value)),
    );
  }
}
