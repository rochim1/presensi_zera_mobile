import 'package:dartz/dartz.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class BreakOut extends UseCase<PresensiEntity, BreakOutParams> {
  final PresensiRepository repository;

  BreakOut({required this.repository});

  @override
  Future<Either<Failure, PresensiEntity>> call(BreakOutParams params) {
    return repository.breakOut(params);
  }
}
