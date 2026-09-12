import 'package:dartz/dartz.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class UserGetAllInventaris
    extends UseCase<List<InventarisEntity>, InventarisFilterEntity?> {
  final UserRepository userRepository;

  UserGetAllInventaris(this.userRepository);

  @override
  Future<Either<Failure, List<InventarisEntity>>> call(
    InventarisFilterEntity? params,
  ) async {
    final Either<Failure, List<InventarisEntity>> data = await userRepository
        .getAllInventaris(params);

    return data.fold((failure) => Left(failure), (value) => Right(value));
  }
}
