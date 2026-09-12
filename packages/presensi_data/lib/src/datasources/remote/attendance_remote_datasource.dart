import 'package:logger/logger.dart';
import 'package:presensi_data/presensi_data.dart';

abstract class AttendanceRemoteDatasource {
  Future<AttendanceResponse> getActiveAttendance(
    GetActiveAttendanceRequest request,
  );

  Future<List<AttendanceResponse>> getAttendances(
    GetAttendancesRequest request,
    PaginationRequest pagination,
  );

  Future<AttendanceResponse> getAttendanceById(String id);

  Future<List<AttendanceStatisticResponse>> getAttendanceStatistics(
    GetAttendancesRequest request,
  );

  Future<HomeAlertResponse> getHomeAlert(String userId);

  Future<EffectiveScheduleModel> getEffectiveScheduleToday(String userId);
}

class AttendanceRemoteDatasourceImpl
    with AttendanceGraphQl
    implements AttendanceRemoteDatasource {
  final GraphQlService gql;
  final Logger logger;

  AttendanceRemoteDatasourceImpl({required this.gql, required this.logger});

  @override
  Future<AttendanceResponse> getActiveAttendance(
    GetActiveAttendanceRequest request,
  ) async {
    logger.d(
      "AttendanceRemoteDatasourceImpl.getActiveAttendance request: ${request.toJson()}",
    );

    final response = await gql.query(
      query: getActiveAttendanceQuery,
      variables: request.toJson(),
    );
    logger.d(
      "AttendanceRemoteDatasourceImpl.getActiveAttendance response: $response",
    );

    final attendance = response["GetActiveAttendance"];
    if (attendance == null) {
      throw NotFoundException(message: 'Tidak ada presensi aktif');
    }

    return AttendanceResponse.fromJson(attendance);
  }

  @override
  Future<List<AttendanceResponse>> getAttendances(
    GetAttendancesRequest request,
    PaginationRequest pagination,
  ) async {
    logger.d(
      "AttendanceRemoteDatasourceImpl.getAttendances request: ${request.toJson()}\n pagination: ${pagination.toJson()}",
    );

    final response = await gql.query(
      query: getAttendancesQuery,
      variables: {
        'filter': request.toJson(),
        'pagination': pagination.toJson(),
      },
    );
    logger.d(
      "AttendanceRemoteDatasourceImpl.getAttendances response: $response",
    );

    final listAsMap = response['GetAllPresensi']['presensi'] as List<dynamic>;

    return listAsMap.map((e) => AttendanceResponse.fromJson(e)).toList();
  }

  @override
  Future<AttendanceResponse> getAttendanceById(String id) async {
    logger.d("AttendanceRemoteDatasourceImpl.getAttendanceById id: $id");

    final response = await gql.query(
      query: getAttendanceByIdQuery,
      variables: {"presensiId": id},
    );
    logger.d(
      "AttendanceRemoteDatasourceImpl.getAttendanceById response: $response",
    );

    return AttendanceResponse.fromJson(
      response['GetOnePresensi'] as Map<String, dynamic>,
    );
  }

  @override
  Future<List<AttendanceStatisticResponse>> getAttendanceStatistics(
    GetAttendancesRequest request,
  ) async {
    logger.d(
      "AttendanceRemoteDatasourceImpl.getAttendanceStatistics request: ${request.toJson()}",
    );

    final response = await gql.query(
      query: getAttendanceStatisticsQuery,
      variables: {'filter': request.toJson()},
    );
    logger.d(
      "AttendanceRemoteDatasourceImpl.getAttendanceStatistics response: $response",
    );

    final listAsMap = response['GetPresensiStatisticByType'] as List<dynamic>;

    return listAsMap
        .map((e) => AttendanceStatisticResponse.fromJson(e))
        .toList();
  }

  @override
  Future<HomeAlertResponse> getHomeAlert(String userId) async {
    logger.d("AttendanceRemoteDatasourceImpl.getHomeAlert userId: $userId");

    final response = await gql.query(
      query: getHomeAlertQuery,
      variables: {'userId': userId},
    );
    logger.d("AttendanceRemoteDatasourceImpl.getHomeAlert response: $response");

    final homeAlert = response["GetHomeAlert"];

    return HomeAlertResponse.fromJson(homeAlert ?? {});
  }

  @override
  Future<EffectiveScheduleModel> getEffectiveScheduleToday(String userId) async {
    logger.d("AttendanceRemoteDatasourceImpl.getEffectiveScheduleToday userId: $userId");

    final response = await gql.query(
      query: getEffectiveScheduleTodayQuery,
      variables: {"userId": userId},
    );

    final schedule = response["GetEffectiveScheduleToday"];
    if (schedule == null) {
      throw NotFoundException(message: 'Tidak ada jadwal efektif hari ini');
    }

    return EffectiveScheduleModel.fromJson(schedule);
  }
}
