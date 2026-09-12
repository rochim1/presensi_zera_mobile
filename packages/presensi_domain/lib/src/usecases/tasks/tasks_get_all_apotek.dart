import 'package:dartz/dartz.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class TasksGetAllApotek extends UseCase<List<ApotekEntity>, NoParams> {
  final TasksRepository tasksRepository;

  TasksGetAllApotek(this.tasksRepository);

  @override
  Future<Either<Failure, List<ApotekEntity>>> call(NoParams params) async {
    final Either<Failure, List<ApotekEntity>> data = await tasksRepository
        .getAllApotek();

    return data.fold((failure) => Left(failure), (value) => Right(value));
  }
}
