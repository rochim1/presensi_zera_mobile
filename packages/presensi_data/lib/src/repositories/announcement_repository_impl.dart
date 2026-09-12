import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:presensi_data/core/mapper/app_mappr.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class AnnouncementRepositoryImpl implements AnnouncementRepository {
  final AnnouncementRemoteDatasource remoteDatasource;
  final AppMappr mapper;
  final Logger logger;

  AnnouncementRepositoryImpl({
    required this.remoteDatasource,
    required this.mapper,
    required this.logger,
  });

  @override
  Future<Either<Failure, List<Announcement>>> getAnnouncements(
    GetAnnouncementsParams params,
  ) async {
    try {
      final pagination = PaginationRequest(
        page: params.page,
        limit: params.limit,
      );

      final response = await remoteDatasource.getAnnouncements(pagination);
      final announcements = response
          .map((v) => mapper.convert<AnnouncementResponse, Announcement>(v))
          .toList();

      return Right(announcements);
    } on GraphQlException catch (e, stackTrace) {
      if (e is! CacheException) logger.e(
        "AnnouncementRepositoryImpl.getAnnouncements graphQL",
        error: e,
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      if (e is! CacheException) logger.e(
        "AnnouncementRepositoryImpl.getAnnouncements unknown",
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure());
    }
  }
}
