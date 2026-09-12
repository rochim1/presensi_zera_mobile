import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

abstract class OvertimeRemoteDatasource {
  Future<List<OvertimeRequestResponse>> getOvertimeRequests(
    GetOvertimeRequestsRequest request,
    PaginationRequest pagination,
  );

  Future<OvertimeRequestResponse> getOvertimeRequestById(String id);

  Future<OvertimeRequestResponse?> getActiveOvertimeSession();

  Future<void> createOvertimeRequest(
    CreateOvertimeRequestRequest request,
    List<MultipartFile?> attachments,
  );

  Future<void> updateOvertimeRequest(
    String id,
    CreateOvertimeRequestRequest request,
    List<MultipartFile?> attachments,
  );

  Future<void> deleteOvertimeRequest(String id);

  Future<OvertimeRequestResponse> startOvertimeSession(
    StartOvertimeSessionParams params,
  );

  Future<OvertimeRequestResponse> finishOvertimeSession(
    FinishOvertimeSessionParams params,
  );

  Future<void> cancelOvertimeSession(String overtimeId);
}

class OvertimeRemoteDatasourceImpl
    with OvertimeGraphQl
    implements OvertimeRemoteDatasource {
  final GraphQlService gql;
  final Logger logger;

  OvertimeRemoteDatasourceImpl({required this.gql, required this.logger});

  @override
  Future<List<OvertimeRequestResponse>> getOvertimeRequests(
    GetOvertimeRequestsRequest request,
    PaginationRequest pagination,
  ) async {
    logger.d(
      "OvertimeRemoteDatasourceImpl.getOvertimeRequests request: ${request.toJson()}\n pagination: ${pagination.toJson()}",
    );

    final response = await gql.query(
      query: getOvertimeRequestsQuery,
      variables: {
        "filter": request.toJson(),
        "pagination": pagination.toJson(),
      },
    );
    logger.d(
      "OvertimeRemoteDatasourceImpl.getOvertimeRequests response: $response",
    );

    final overtimeRequests =
        response["GetAllLembur"]["lembur"] as List<dynamic>;

    return overtimeRequests
        .map((v) => OvertimeRequestResponse.fromJson(v))
        .toList();
  }

  @override
  Future<OvertimeRequestResponse> getOvertimeRequestById(String id) async {
    logger.d(
      "OvertimeRemoteDatasourceImpl.getOvertimeRequestById request: $id",
    );

    final response = await gql.query(
      query: getOvertimeRequestByIdQuery,
      variables: {"lemburId": id},
    );
    logger.d(
      "OvertimeRemoteDatasourceImpl.getOvertimeRequestById response: $response",
    );

    return OvertimeRequestResponse.fromJson(
      response["GetOneLembur"] as Map<String, dynamic>,
    );
  }

  @override
  Future<void> createOvertimeRequest(
    CreateOvertimeRequestRequest request,
    List<MultipartFile?> attachments,
  ) async {
    logger.d(
      "OvertimeRemoteDatasourceImpl.createOvertimeRequest request: ${request.toJson()}\n attachments: ${attachments}",
    );

    final response = await gql.mutation(
      mutation: createOvertimeRequestMutation,
      variables: {
        "input": request.toJson(),
        "file": attachments.isNotEmpty ? attachments.first : null,
      },
    );
    logger.d(
      "OvertimeRemoteDatasourceImpl.createOvertimeRequest response: $response",
    );
    _requireMutationId(
      response,
      'CreateLembur',
      attachmentField: attachments.isNotEmpty ? 'bukti_lembur' : null,
    );
  }

  @override
  Future<void> updateOvertimeRequest(
    String id,
    CreateOvertimeRequestRequest request,
    List<MultipartFile?> attachments,
  ) async {
    final response = await gql.mutation(
      mutation: updateOvertimeRequestMutation,
      variables: {
        'lemburId': id,
        'input': request.toJson(),
        'file': attachments.isNotEmpty ? attachments.first : null,
      },
    );
    _requireMutationId(
      response,
      'UpdateLembur',
      attachmentField: attachments.isNotEmpty ? 'bukti_lembur' : null,
    );
  }

  @override
  Future<void> deleteOvertimeRequest(String id) async {
    final response = await gql.mutation(
      mutation: deleteOvertimeRequestMutation,
      variables: {'lemburId': id},
    );
    _requireMutationId(response, 'DeleteLembur');
  }

  @override
  Future<OvertimeRequestResponse?> getActiveOvertimeSession() async {
    final response = await gql.query(query: getActiveOvertimeSessionQuery);
    final data = response["GetActiveLembur"];
    if (data == null) return null;
    return OvertimeRequestResponse.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<OvertimeRequestResponse> startOvertimeSession(
    StartOvertimeSessionParams params,
  ) async {
    final input = {
      'tanggal': DateFormat('yyyy-MM-dd').format(params.date),
      'jam_mulai': DateFormat('HH:mm').format(params.startTime),
      'alasan': params.reason,
    };
    final response = await gql.mutation(
      mutation: startOvertimeSessionMutation,
      variables: {'input': input},
    );
    return OvertimeRequestResponse.fromJson(
      response["StartLemburSession"] as Map<String, dynamic>,
    );
  }

  @override
  Future<OvertimeRequestResponse> finishOvertimeSession(
    FinishOvertimeSessionParams params,
  ) async {
    final input = {
      if (params.overtimeId != null) 'lembur_id': params.overtimeId,
      'tanggal': DateFormat('yyyy-MM-dd').format(params.date),
      'jam_mulai': DateFormat('HH:mm').format(params.startTime),
      'jam_selesai': DateFormat('HH:mm').format(params.endTime),
      'alasan': params.reason,
    };
    final response = await gql.mutation(
      mutation: finishOvertimeSessionMutation,
      variables: {
        'input': input,
        'file': params.attachments.isNotEmpty ? params.attachments.first : null,
      },
    );
    return OvertimeRequestResponse.fromJson(
      response["FinishLemburSession"] as Map<String, dynamic>,
    );
  }

  @override
  Future<void> cancelOvertimeSession(String overtimeId) async {
    await gql.mutation(
      mutation: cancelOvertimeSessionMutation,
      variables: {'lemburId': overtimeId},
    );
  }

  void _requireMutationId(
    dynamic response,
    String operation, {
    String? attachmentField,
  }) {
    final payload = response is Map ? response[operation] : null;
    final id = payload is Map ? payload['_id']?.toString().trim() : null;
    if (id == null || id.isEmpty) {
      throw GraphQlException(
        code: 'INVALID_RESPONSE',
        message:
            'Server tidak mengonfirmasi pengajuan lembur berhasil diproses.',
      );
    }
    if (attachmentField != null &&
        (payload[attachmentField]?.toString().trim().isEmpty ?? true)) {
      throw GraphQlException(
        code: 'UPLOAD_NOT_CONFIRMED',
        message:
            'Data tersimpan, tetapi upload bukti lembur tidak terkonfirmasi.',
      );
    }
  }
}
