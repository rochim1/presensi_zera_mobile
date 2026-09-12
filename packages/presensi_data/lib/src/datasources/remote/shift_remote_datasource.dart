import 'package:logger/logger.dart';
import 'package:presensi_data/presensi_data.dart';

abstract class ShiftRemoteDatasource {
  Future<void> createShiftSwapRequest(CreateShiftSwapRequestRequest request);
  Future<void> cancelShiftSwapRequest(String id);
  Future<void> updateShiftSwapRequest(
    String id,
    CreateShiftSwapRequestRequest request,
  );

  Future<void> createShiftSwapRequestApproval(
    CreateShiftSwapRequestApprovalRequest request,
  );

  Future<List<AvailableShiftForSwapResponse>> getAvailableShiftsForSwap(
    GetAvailableShiftsForSwapRequest request,
  );

  Future<ShiftScheduleResponse> getShiftScheduleById(String id);

  Future<List<ShiftScheduleResponse>> getShiftSchedules(
    GetShiftSchedulesRequest request,
  );

  Future<List<ShiftSwapRequestResponse>> getShiftSwapRequests(
    GetShiftSwapRequestsRequest request,
  );

  Future<List<ShiftScheduleResponse>> getMyShiftSchedules(
    GetMyShiftSchedulesRequest request,
  );

  Future<List<ShiftSwapRequestResponse>> getMyShiftSwapRequests(
    GetMyShiftSwapRequestsRequest request,
  );
}

class ShiftRemoteDatasourceImpl
    with ShiftGraphQl
    implements ShiftRemoteDatasource {
  final GraphQlService gql;
  final Logger logger;

  ShiftRemoteDatasourceImpl({required this.gql, required this.logger});

  @override
  Future<void> createShiftSwapRequest(
    CreateShiftSwapRequestRequest request,
  ) async {
    final response = await gql.mutation(
      mutation: createShiftSwapRequestMutation,
      variables: {'input': request.toJson()},
    );
    logger.d(
      'ShiftRemoteDatasourceImpl.createShiftSwapRequest response: $response',
    );
    _requireMutationId(response, 'createShiftSwapRequest');
  }

  @override
  Future<void> cancelShiftSwapRequest(String id) async {
    final response = await gql.mutation(
      mutation: cancelShiftSwapRequestMutation,
      variables: {'id': id},
    );
    _requireMutationId(response, 'cancelShiftSwapRequest');
  }

  @override
  Future<void> updateShiftSwapRequest(
    String id,
    CreateShiftSwapRequestRequest request,
  ) async {
    final response = await gql.mutation(
      mutation: updateShiftSwapRequestMutation,
      variables: {'id': id, 'input': request.toJson()},
    );
    _requireMutationId(response, 'updateShiftSwapRequest');
  }

  @override
  Future<void> createShiftSwapRequestApproval(
    CreateShiftSwapRequestApprovalRequest request,
  ) async {
    final response = await gql.mutation(
      mutation: createShiftSwapRequestApprovalMutation,
      variables: {"input": request.toJson()},
    );
    logger.d(
      "ShiftRemoteDatasourceImpl.createShiftSwapRequestApproval response: $response",
    );
  }

  @override
  Future<List<AvailableShiftForSwapResponse>> getAvailableShiftsForSwap(
    GetAvailableShiftsForSwapRequest request,
  ) async {
    logger.d(
      "ShiftRemoteDatasourceImpl.getAvailableShiftsForSwap request: ${request.toJson()}",
    );

    final response = await gql.query(
      query: getAvailableShiftsForSwapQuery,
      variables: request.toJson(),
    );
    logger.d(
      "ShiftRemoteDatasourceImpl.getAvailableShiftsForSwap response: $response",
    );

    final availableShifts =
        response["getAvailableUsersForSwap"] as List<dynamic>;
    return availableShifts
        .map((v) => AvailableShiftForSwapResponse.fromJson(v))
        .toList();
  }

  @override
  Future<ShiftScheduleResponse> getShiftScheduleById(String id) async {
    logger.d("ShiftRemoteDatasourceImpl.getShiftScheduleById id: $id");

    final response = await gql.query(
      query: getShiftScheduleByIdQuery,
      variables: {"shiftScheduleId": id},
    );
    logger.d(
      "ShiftRemoteDatasourceImpl.getShiftScheduleById response: $response",
    );

    return ShiftScheduleResponse.fromJson(
      response["GetOneShiftSchedule"] as Map<String, dynamic>,
    );
  }

  @override
  Future<List<ShiftScheduleResponse>> getShiftSchedules(
    GetShiftSchedulesRequest request,
  ) async {
    logger.d(
      "ShiftRemoteDatasourceImpl.getShiftSchedules request: ${request.toJson()}",
    );

    final response = await gql.query(
      query: getShiftSchedulesQuery,
      variables: request.toJson(),
    );
    logger.d("ShiftRemoteDatasourceImpl.getShiftSchedules response: $response");

    final shiftSchedules = response["GetUserShiftSchedule"] as List<dynamic>;
    return shiftSchedules
        .map((v) => ShiftScheduleResponse.fromJson(v))
        .toList();
  }

  @override
  Future<List<ShiftScheduleResponse>> getMyShiftSchedules(
    GetMyShiftSchedulesRequest request,
  ) async {
    logger.d(
      "ShiftRemoteDatasourceImpl.getMyShiftSchedules request: ${request.toJson()}",
    );

    final response = await gql.query(
      query: getMyShiftSchedulesQuery,
      variables: request.toJson(),
    );
    logger.d(
      "ShiftRemoteDatasourceImpl.getMyShiftSchedules response: $response",
    );

    final shiftSchedules =
        response["GetMyShiftSchedules"]["shift_schedules"] as List<dynamic>;
    return shiftSchedules
        .map((v) => ShiftScheduleResponse.fromJson(v))
        .toList();
  }

  @override
  Future<List<ShiftSwapRequestResponse>> getShiftSwapRequests(
    GetShiftSwapRequestsRequest request,
  ) async {
    logger.d(
      "ShiftRemoteDatasourceImpl.getShiftSwapRequests request: ${request.toJson()}",
    );

    final response = await gql.query(
      query: getShiftSwapRequestsQuery,
      variables: request.toJson(),
    );
    logger.d(
      "ShiftRemoteDatasourceImpl.getShiftSwapRequests response: $response",
    );

    final shiftSwapRequests =
        response["getAllShiftSwapRequests"] as List<dynamic>;
    return shiftSwapRequests
        .map((v) => ShiftSwapRequestResponse.fromJson(v))
        .toList();
  }

  @override
  Future<List<ShiftSwapRequestResponse>> getMyShiftSwapRequests(
    GetMyShiftSwapRequestsRequest request,
  ) async {
    logger.d(
      "ShiftRemoteDatasourceImpl.getShiftSwapRequests request: ${request.toJson()}",
    );

    final response = await gql.query(
      query: getMyShiftSwapRequestsQuery,
      variables: request.toJson(),
    );
    logger.d(
      "ShiftRemoteDatasourceImpl.getShiftSwapRequests response: $response",
    );

    final shiftSchedules =
        response["getMyShiftSwapRequests"]["data"] as List<dynamic>;
    return shiftSchedules
        .map((v) => ShiftSwapRequestResponse.fromJson(v))
        .toList();
  }

  void _requireMutationId(dynamic response, String operation) {
    final payload = response is Map ? response[operation] : null;
    final id = payload is Map ? payload['_id']?.toString().trim() : null;
    if (id == null || id.isEmpty) {
      throw GraphQlException(
        code: 'INVALID_RESPONSE',
        message:
            'Server tidak mengonfirmasi request tukar shift berhasil diproses.',
      );
    }
  }
}
