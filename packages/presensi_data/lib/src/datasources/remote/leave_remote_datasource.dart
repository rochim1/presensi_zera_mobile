import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:presensi_data/presensi_data.dart';

abstract class LeaveRemoteDatasource {
  Future<List<LeaveCategoryResponse>> getLeaveCategories();

  Future<List<LeaveRequestResponse>> getLeaveRequests(
    GetLeaveRequestsRequest request,
    PaginationRequest pagination,
  );

  Future<LeaveRequestResponse> getLeaveRequestById(String id);

  Future<void> createLeaveRequest(
    CreateLeaveRequestRequest request, {
    MultipartFile? attachment,
  });

  Future<void> updateLeaveRequest(
    String id,
    CreateLeaveRequestRequest request, {
    MultipartFile? attachment,
  });

  Future<void> deleteLeaveRequest(String id);

  Future<Map<String, dynamic>> getMyCutiQuota();
}

class LeaveRemoteDatasourceImpl
    with LeaveGraphQl
    implements LeaveRemoteDatasource {
  final GraphQlService gql;
  final Logger logger;

  LeaveRemoteDatasourceImpl({required this.gql, required this.logger});

  @override
  Future<List<LeaveCategoryResponse>> getLeaveCategories() async {
    final response = await gql.query(query: getLeaveCategoriesQuery);
    logger.d(
      "LeaveRemoteDatasourceImpl.getLeaveCategories response: $response",
    );

    final categoriesResponse =
        response["GetAllKategoriCuti"]["kategoriCuti"] as List<dynamic>;

    return categoriesResponse
        .map((v) => LeaveCategoryResponse.fromJson(v))
        .toList();
  }

  @override
  Future<List<LeaveRequestResponse>> getLeaveRequests(
    GetLeaveRequestsRequest request,
    PaginationRequest pagination,
  ) async {
    final response = await gql.query(
      query: getLeaveRequestsQuery,
      variables: {
        "filter": request.toJson(),
        "pagination": pagination.toJson(),
      },
    );
    logger.d("LeaveRemoteDatasourceImpl.getLeaveRequests response: $response");

    final leaveRequests = response["GetAllCuti"]["cuti"] as List<dynamic>;

    return leaveRequests.map((v) => LeaveRequestResponse.fromJson(v)).toList();
  }

  @override
  Future<LeaveRequestResponse> getLeaveRequestById(String id) async {
    logger.d("LeaveRemoteDatasourceImpl.getLeaveRequestById id: $id");

    final response = await gql.query(
      query: getLeaveRequestByIdQuery,
      variables: {"cutiId": id},
    );
    logger.d(
      "LeaveRemoteDatasourceImpl.getLeaveRequestById response: $response",
    );

    return LeaveRequestResponse.fromJson(response["GetOneCuti"]);
  }

  @override
  Future<void> createLeaveRequest(
    CreateLeaveRequestRequest request, {
    MultipartFile? attachment,
  }) async {
    logger.d(
      "LeaveRemoteDatasourceImpl.createLeaveRequest request: ${request.toJson()}",
    );

    final response = await gql.mutation(
      mutation: createLeaveRequestMutation,
      variables: {"input": request.toJson(), "file": attachment},
    );
    logger.d("LeaveRemoteDatasourceImpl.createLeaveRequest response $response");
    _requireMutationId(
      response,
      'CreateCuti',
      attachmentField: attachment != null ? 'file_izin' : null,
    );
  }

  @override
  Future<void> updateLeaveRequest(
    String id,
    CreateLeaveRequestRequest request, {
    MultipartFile? attachment,
  }) async {
    final response = await gql.mutation(
      mutation: updateLeaveRequestMutation,
      variables: {'id': id, 'input': request.toJson(), 'file': attachment},
    );
    _requireMutationId(
      response,
      'UpdateCuti',
      attachmentField: attachment != null ? 'file_izin' : null,
    );
  }

  @override
  Future<void> deleteLeaveRequest(String id) async {
    final response = await gql.mutation(
      mutation: deleteLeaveRequestMutation,
      variables: {'id': id},
    );
    _requireMutationId(response, 'DeleteCuti');
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
            'Server tidak mengonfirmasi bahwa data cuti berhasil disimpan.',
      );
    }
    if (attachmentField != null &&
        (payload[attachmentField]?.toString().trim().isEmpty ?? true)) {
      throw GraphQlException(
        code: 'UPLOAD_NOT_CONFIRMED',
        message:
            'Data tersimpan, tetapi upload dokumen cuti tidak terkonfirmasi.',
      );
    }
  }

  @override
  Future<Map<String, dynamic>> getMyCutiQuota() async {
    final response = await gql.query(query: getMyCutiQuotaQuery);
    logger.d("LeaveRemoteDatasourceImpl.getMyCutiQuota response: $response");
    return response["GetMyCutiQuota"] as Map<String, dynamic>;
  }
}
