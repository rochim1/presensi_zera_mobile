import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class CreateAttendanceRequest
    extends UseCase<void, CreateAttendanceRequestParams> {
  final AttendanceRequestRepository repository;

  CreateAttendanceRequest({required this.repository});

  @override
  Future<Either<Failure, void>> call(params) {
    return repository.createAttendanceRequest(params);
  }
}
