import 'package:dartz/dartz.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class ApotekPostQuery extends UseCase<String?, GlobalQueryEntity> {
  final GlobalRepository globalRepository;

  ApotekPostQuery(this.globalRepository);

  @override
  Future<Either<Failure, String?>> call(GlobalQueryEntity params) async {
    final Either<Failure, String?> data = await globalRepository.postQuery(
      params,
      KEY_QUERY_APOTEK,
    );

    return data.fold((failure) => Left(failure), (value) => Right(value));
  }
}
