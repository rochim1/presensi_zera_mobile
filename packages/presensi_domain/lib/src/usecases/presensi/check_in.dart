import 'package:dartz/dartz.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class CheckIn extends UseCase<PresensiEntity, CheckInParams> {
  final PresensiRepository repository;

  CheckIn({required this.repository});

  @override
  Future<Either<Failure, PresensiEntity>> call(CheckInParams params) async {
    return repository.checkIn(params);
  }
}
