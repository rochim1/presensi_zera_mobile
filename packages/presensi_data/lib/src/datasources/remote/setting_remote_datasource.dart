import 'package:logger/logger.dart';
import 'package:presensi_data/presensi_data.dart';

abstract class SettingRemoteDatasource {
  Future<SettingResponse> getSettingByOrganizationId(
    String organizationId,
    String userId,
  );
}

class SettingRemoteDatasourceImpl
    with SettingGrapql, AttendanceGraphQl
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

    // The server selects special hours, shift dates and the tenant timezone.
    // Device weekday/timezone must not select a different work schedule.
    try {
      final response = await gql.query(
        query: getEffectiveScheduleTodayQuery,
        variables: {"userId": userId},
      );
      final schedule =
          response["GetEffectiveScheduleToday"] as Map<String, dynamic>?;
      if (schedule != null) {
        setting["jam_masuk"] = schedule["effective_jam_masuk"];
        setting["jam_pulang"] = schedule["effective_jam_pulang"];
      }
    } catch (e) {
      logger.e("Error fetching effective work schedule: $e");
    }

    return SettingResponse.fromJson(setting);
  }
}
