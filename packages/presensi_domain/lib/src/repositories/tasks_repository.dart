import 'package:dartz/dartz.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

abstract class TasksRepository {
  /// get all tasks
  Future<Either<Failure, List<TasksEntity>>> getAllData(
    TasksFilterEntity params,
  );

  /// get all perjalanan
  Future<Either<Failure, List<TasksEntity>>> getAllPerjalaan(
    TasksFilterEntity params,
  );

  /// create new task
  Future<Either<Failure, TasksEntity>> postData(TasksParamsEntity params);

  /// get all apotek
  Future<Either<Failure, List<ApotekEntity>>> getAllApotek();

  /// checking task
  Future<Either<Failure, TasksEntity>> postCompleted(
    TasksCompletedParamsEntity params,
  );

  /// canceled task
  Future<Either<Failure, TasksEntity>> postCanceled(
    TasksCanceledParamsEntity params,
  );
}
