import 'package:dartz/dartz.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class TasksPostData extends UseCase<TasksEntity, TasksParamsEntity> {
  final TasksRepository tasksRepository;

  TasksPostData(this.tasksRepository);

  @override
  Future<Either<Failure, TasksEntity>> call(TasksParamsEntity params) async {
    final Either<Failure, TasksEntity> data = await tasksRepository.postData(
      params,
    );

    return data.fold((failure) => Left(failure), (value) => Right(value));
  }
}
