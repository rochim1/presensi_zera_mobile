import 'package:logger/logger.dart';
import 'package:presensi_data/presensi_data.dart';

abstract class AnnouncementRemoteDatasource {
  Future<void> createAnnouncement(Map<String, dynamic> input);
  Future<void> updateAnnouncement(String id, Map<String, dynamic> input);
  Future<void> deleteAnnouncement(String id);

  Future<List<AnnouncementResponse>> getAnnouncements(
    PaginationRequest pagination,
  );
}

class AnnouncementRemoteDatasourceImpl
    with AnnouncementGraphql
    implements AnnouncementRemoteDatasource {
  final GraphQlService gql;
  final Logger logger;

  AnnouncementRemoteDatasourceImpl({required this.gql, required this.logger});

  @override
  Future<void> createAnnouncement(Map<String, dynamic> input) async {
    await gql.mutation(
      mutation: createAnnouncementMutation,
      variables: {'input': input},
    );
  }

  @override
  Future<void> updateAnnouncement(String id, Map<String, dynamic> input) async {
    await gql.mutation(
      mutation: updateAnnouncementMutation,
      variables: {'id': id, 'input': input},
    );
  }

  @override
  Future<void> deleteAnnouncement(String id) async {
    await gql.mutation(
      mutation: deleteAnnouncementMutation,
      variables: {'id': id},
    );
  }

  @override
  Future<List<AnnouncementResponse>> getAnnouncements(
    PaginationRequest pagination,
  ) async {
    logger.d(
      "AnnouncementRemoteDatasourceImpl.getAnnouncements pagination: ${pagination.toJson()}",
    );

    final response = await gql.query(
      query: getAnnouncementsQuery,
      variables: {"pagination": pagination.toJson()},
    );
    logger.d(
      "AnnouncementRemoteDatasourceImpl.getAnnouncements response: $response",
    );

    final getAllPengumuman = response?["GetAllPengumuman"];
    if (getAllPengumuman == null) return [];

    final pengumuman = getAllPengumuman["pengumuman"];
    if (pengumuman == null) return [];

    final announcements = pengumuman as List<dynamic>;

    return announcements.map((v) => AnnouncementResponse.fromJson(v)).toList();
  }
}
