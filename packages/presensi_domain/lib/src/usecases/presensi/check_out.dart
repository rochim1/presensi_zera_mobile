import 'package:dartz/dartz.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class CheckOut extends UseCase<PresensiEntity, CheckOutParams> {
  final PresensiRepository repository;

  CheckOut({required this.repository});

  @override
  Future<Either<Failure, PresensiEntity>> call(CheckOutParams params) {
    return repository.checkOut(params);
  }
}
