import 'package:dartz/dartz.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class ApotekGetQuery extends UseCase<List<GlobalQueryEntity>, NoParams> {
  final GlobalRepository globalRepository;

  ApotekGetQuery(this.globalRepository);

  @override
  Future<Either<Failure, List<GlobalQueryEntity>>> call(NoParams params) async {
    Either<Failure, List<GlobalQueryEntity>> data = await globalRepository
        .getQuery(KEY_QUERY_APOTEK);

    return data.fold((failure) => Left(failure), (value) => Right(value));
  }
}
