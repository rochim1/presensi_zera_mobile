import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class GetSettingByOrganizationId extends UseCase<Setting, GetSettingParams> {
  final SettingRepository repository;

  GetSettingByOrganizationId({required this.repository});

  @override
  Future<Either<Failure, Setting>> call(params) {
    return repository.getSettingByOrganizationId(params);
  }
}
