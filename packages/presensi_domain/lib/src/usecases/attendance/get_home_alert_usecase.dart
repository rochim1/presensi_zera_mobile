import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class GetHomeAlertUseCase implements UseCase<HomeAlert, NoParams> {
  final AttendanceRepository repository;

  GetHomeAlertUseCase(this.repository);

  @override
  Future<Either<Failure, HomeAlert>> call(NoParams params) async {
    return await repository.getHomeAlert();
  }
}
