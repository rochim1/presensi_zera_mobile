import 'package:dartz/dartz.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class TasksPostCompleted
    extends UseCase<TasksEntity, TasksCompletedParamsEntity> {
  final TasksRepository tasksRepository;

  TasksPostCompleted(this.tasksRepository);

  @override
  Future<Either<Failure, TasksEntity>> call(
    TasksCompletedParamsEntity params,
  ) async {
    final Either<Failure, TasksEntity> data = await tasksRepository
        .postCompleted(params);

    return data.fold((failure) => Left(failure), (value) => Right(value));
  }
}
