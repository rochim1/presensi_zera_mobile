import 'package:dartz/dartz.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class BreakIn extends UseCase<PresensiEntity, BreakInParams> {
  final PresensiRepository repository;

  BreakIn({required this.repository});

  @override
  Future<Either<Failure, PresensiEntity>> call(BreakInParams params) {
    return repository.breakIn(params);
  }
}
