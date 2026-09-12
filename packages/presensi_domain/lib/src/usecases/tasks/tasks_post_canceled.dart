import 'package:dartz/dartz.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class TasksPostCanceled
    extends UseCase<TasksEntity, TasksCanceledParamsEntity> {
  final TasksRepository tasksRepository;

  TasksPostCanceled(this.tasksRepository);

  @override
  Future<Either<Failure, TasksEntity>> call(
    TasksCanceledParamsEntity params,
  ) async {
    final Either<Failure, TasksEntity> data = await tasksRepository
        .postCanceled(params);

    return data.fold((failure) => Left(failure), (value) => Right(value));
  }
}
