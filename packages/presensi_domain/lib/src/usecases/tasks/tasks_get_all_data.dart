import 'package:dartz/dartz.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class TasksGetAllData extends UseCase<List<TasksEntity>, TasksFilterEntity> {
  final TasksRepository tasksRepository;

  TasksGetAllData(this.tasksRepository);

  @override
  Future<Either<Failure, List<TasksEntity>>> call(
    TasksFilterEntity params,
  ) async {
    final Either<Failure, List<TasksEntity>> data = await tasksRepository
        .getAllData(params);

    return data.fold((failure) => Left(failure), (value) => Right(value));
  }
}
