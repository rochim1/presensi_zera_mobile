import 'package:logger/logger.dart';
import 'package:presensi_data/presensi_data.dart';

abstract class SettingRemoteDatasource {
  Future<SettingResponse> getSettingByOrganizationId(
    String organizationId,
    String userId,
  );
}

class SettingRemoteDatasourceImpl
    with SettingGrapql
    implements SettingRemoteDatasource {
  final GraphQlService gql;
  final Logger logger;

  SettingRemoteDatasourceImpl({required this.gql, required this.logger});

  @override
  Future<SettingResponse> getSettingByOrganizationId(
    String organizationId,
    String userId,
  ) async {
    logger.d(
      "SettingRemoteDatasourceImpl.getSettingByOrganizationId organizationId: $organizationId, userId: $userId",
    );

    final response = await gql.query(
      query: getSettingQuery,
      variables: {"instansiId": organizationId},
    );
    logger.d(
      "SettingRemoteDatasourceImpl.getSettingByOrganizationId response: $response",
    );

    final setting = response["GetOneSetting"] as Map<String, dynamic>;

    // 1. Check Jam Kerja Khusus (TestUserAgainstJamKerja)
    try {
      final khususResponse = await gql.query(
        query: testUserAgainstJamKerjaQuery,
        variables: {"userId": userId},
      );

      final todayDayNumber = DateTime.now().weekday % 7; // Sunday=0
      final allKhusus =
          khususResponse["TestUserAgainstJamKerja"] as List<dynamic>? ?? [];
      final todayKhusus = allKhusus.cast<Map<String, dynamic>>().firstWhere(
        (jk) => jk["day_number"] == todayDayNumber,
        orElse: () => <String, dynamic>{},
      );

      if (todayKhusus.isNotEmpty &&
          todayKhusus["jam_masuk"] != null &&
          todayKhusus["jam_pulang"] != null) {
        setting["jam_masuk"] = todayKhusus["jam_masuk"];
        setting["jam_pulang"] = todayKhusus["jam_pulang"];
      } else {
        // 2. Fallback to Jam Kerja Umum
        final regularResponse = await gql.query(
          query: getAllJamKerjaQuery,
          variables: {
            "filter": {"is_default": true},
            "pagination": {"limit": 10, "page": 0},
            "sorting": {},
          },
        );

        final allRegular =
            regularResponse["getAllJamKerja"]?["jam_kerja"] as List<dynamic>? ??
            [];
        final todayRegular = allRegular.cast<Map<String, dynamic>>().firstWhere(
          (jk) => jk["day_number"] == todayDayNumber,
          orElse: () => <String, dynamic>{},
        );

        if (todayRegular.isNotEmpty &&
            todayRegular["jam_masuk"] != null &&
            todayRegular["jam_pulang"] != null) {
          setting["jam_masuk"] = todayRegular["jam_masuk"];
          setting["jam_pulang"] = todayRegular["jam_pulang"];
        }
      }
    } catch (e) {
      logger.e("Error fetching jam kerja: $e");
    }

    return SettingResponse.fromJson(setting);
  }
}
