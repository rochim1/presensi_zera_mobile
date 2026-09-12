import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class GetAttendanceRequests
    extends UseCase<List<AttendanceRequest>, GetAttendanceRequestsParams> {
  final AttendanceRequestRepository repository;

  GetAttendanceRequests({required this.repository});

  @override
  Future<Either<Failure, List<AttendanceRequest>>> call(params) async {
    final data = await repository.getAttendanceRequests(params);

    return data.fold((failure) => Left(failure), (value) => Right(value));
  }
}
