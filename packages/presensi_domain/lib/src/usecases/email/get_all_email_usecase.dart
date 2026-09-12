import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/src/entities/email/email_entity.dart';
import 'package:presensi_domain/src/params/email/get_all_email_params.dart';
import 'package:presensi_domain/src/repositories/email_repository.dart';

class GetAllEmailUsecase implements UseCase<List<EmailEntity>, GetAllEmailParams> {
  final EmailRepository repository;

  GetAllEmailUsecase(this.repository);

  @override
  Future<Either<Failure, List<EmailEntity>>> call(GetAllEmailParams params) async {
    return await repository.getAllEmail(
      filter: params.filter,
      limit: params.limit,
      offset: params.offset,
    );
  }
}
