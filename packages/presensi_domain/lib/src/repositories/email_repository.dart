import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/src/entities/email/email_entity.dart';

abstract class EmailRepository {
  Future<Either<Failure, int>> countUnreadEmail();
  Future<Either<Failure, List<EmailEntity>>> getAllEmail({
    Map<String, dynamic>? filter,
    int? limit,
    int? offset,
  });
  Future<Either<Failure, void>> readEmail(String id);
}
