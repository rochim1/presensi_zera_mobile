import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:presensi_data/presensi_data.dart';

abstract class AttendanceRequestRemoteDatasource {
  Future<List<AttendanceRequestResponse>> getAttendanceRequests(
    GetAttendanceRequestsRequest request,
    PaginationRequest pagination,
  );

  Future<void> createAttendanceRequest(
    CreateAttendanceRequestRequest request,
    List<MultipartFile?> attachments,
  );
  Future<void> updateAttendanceRequest(
    String id,
    CreateAttendanceRequestRequest request,
    List<MultipartFile?> attachments,
  );
  Future<void> deleteAttendanceRequest(String id);
}

class AttendanceRequestRemoteDatasourceImpl
    with AttendanceRequestGraphQl
    implements AttendanceRequestRemoteDatasource {
  final GraphQlService gql;
  final Logger logger;

  AttendanceRequestRemoteDatasourceImpl({
    required this.gql,
    required this.logger,
  });

  @override
  Future<List<AttendanceRequestResponse>> getAttendanceRequests(
    GetAttendanceRequestsRequest request,
    PaginationRequest pagination,
  ) async {
    final response = await gql.query(
      query: getAttendanceRequestsQuery,
      variables: {
        "filter": request.toJson(),
        "pagination": pagination.toJson(),
      },
    );
    logger.d(
      "AttendanceRequestRemoteDatasourceImpl.getAttendanceRequests response: $response",
    );

    final attendanceRequests =
        response["getListRequestPresensi"]["data"] as List<dynamic>;

    return attendanceRequests
        .map((v) => AttendanceRequestResponse.fromJson(v))
        .toList();
  }

  @override
  Future<void> createAttendanceRequest(
    CreateAttendanceRequestRequest request,
    List<MultipartFile?> attachments,
  ) async {
    final response = await gql.mutation(
      mutation: createAttendanceRequestMutation,
      variables: {"input": request.toJson(), "files": attachments},
    );
    logger.d(
      "AttendanceRequestRemoteDatasourceImpl.createAttendanceRequest response: $response",
    );
    _requireMutationId(
      response,
      'createRequestPresensi',
      requireAttachments: attachments.isNotEmpty,
    );
  }

  @override
  Future<void> updateAttendanceRequest(
    String id,
    CreateAttendanceRequestRequest request,
    List<MultipartFile?> attachments,
  ) async {
    final input = request.toJson()..remove('bukti_pendukung');
    final response = await gql.mutation(
      mutation: updateAttendanceRequestMutation,
      variables: {'id': id, 'input': input, 'files': attachments},
    );
    _requireMutationId(
      response,
      'updateRequestPresensi',
      requireAttachments: attachments.isNotEmpty,
    );
  }

  @override
  Future<void> deleteAttendanceRequest(String id) async {
    final response = await gql.mutation(
      mutation: deleteAttendanceRequestMutation,
      variables: {'id': id},
    );
    if (response is! Map || response['deleteRequestPresensi'] != true) {
      throw GraphQlException(
        code: 'INVALID_RESPONSE',
        message: 'Server tidak mengonfirmasi perubahan request presensi.',
      );
    }
  }

  void _requireMutationId(
    dynamic response,
    String operation, {
    bool requireAttachments = false,
  }) {
    final payload = response is Map ? response[operation] : null;
    final id = payload is Map ? payload['_id']?.toString().trim() : null;
    if (id == null || id.isEmpty) {
      throw GraphQlException(
        code: 'INVALID_RESPONSE',
        message:
            'Server tidak mengonfirmasi request presensi berhasil disimpan.',
      );
    }
    final uploaded = payload is Map ? payload['bukti_pendukung'] : null;
    if (requireAttachments && (uploaded is! List || uploaded.isEmpty)) {
      throw GraphQlException(
        code: 'UPLOAD_NOT_CONFIRMED',
        message:
            'Data tersimpan, tetapi upload bukti presensi tidak terkonfirmasi.',
      );
    }
  }
}
