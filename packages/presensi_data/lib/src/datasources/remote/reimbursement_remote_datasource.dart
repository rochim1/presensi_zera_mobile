import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:presensi_data/presensi_data.dart';

abstract class ReimbursementRemoteDatasource {
  Future<List<ReimbursementResponse>> getReimbursements(
    GetReimbursementsRequest request,
    PaginationRequest pagination,
  );

  Future<ReimbursementResponse> getReimbursementById(String reimbursementId);

  Future<List<ReimbursementCategoryResponse>> getReimbursementCategories(
    Map<String, dynamic> filter,
  );

  Future<ReimbursementResponse> createReimbursement(
    CreateReimbursementRequest request,
    List<MultipartFile?> attachments,
  );
  Future<ReimbursementResponse> updateReimbursement(
    String id,
    CreateReimbursementRequest request,
    List<MultipartFile?> attachments,
  );
  Future<void> deleteReimbursement(String id);
}

class ReimbursementRemoteDatasourceImpl
    with ReimbursementGraphQl
    implements ReimbursementRemoteDatasource {
  final GraphQlService gql;
  final Logger logger;

  ReimbursementRemoteDatasourceImpl({required this.gql, required this.logger});

  @override
  Future<List<ReimbursementResponse>> getReimbursements(
    GetReimbursementsRequest request,
    PaginationRequest pagination,
  ) async {
    logger.d(
      "ReimbursementRemoteDatasourceImpl.getReimbursements request: ${request.toJson()}",
    );

    final response = await gql.query(
      query: getReimbursementsQuery,
      variables: {
        "filter": request.toJson(),
        "pagination": pagination.toJson(),
      },
    );
    logger.d(
      "ReimbursementRemoteDatasourceImpl.getReimbursements response: $response",
    );

    final reimbursements =
        response["GetAllReimbursement"]["reimbursement"] as List<dynamic>;
    return reimbursements
        .map((v) => ReimbursementResponse.fromJson(v))
        .toList();
  }

  @override
  Future<ReimbursementResponse> getReimbursementById(
    String reimbursementId,
  ) async {
    logger.d(
      "ReimbursementRemoteDatasourceImpl.getReimbursementById id: $reimbursementId",
    );

    final response = await gql.query(
      query: getReimbursementByIdQuery,
      variables: {"reimbursementId": reimbursementId},
    );
    logger.d(
      "ReimbursementRemoteDatasourceImpl.getReimbursementById response: $response",
    );

    return ReimbursementResponse.fromJson(response["GetOneReimbursement"]);
  }

  @override
  Future<List<ReimbursementCategoryResponse>> getReimbursementCategories(
    Map<String, dynamic> filter,
  ) async {
    logger.d(
      "ReimbursementRemoteDatasourceImpl.getReimbursementCategories filter: $filter",
    );

    final response = await gql.query(
      query: getReimbursementCategoriesQuery,
      variables: {"filter": filter},
    );
    logger.d(
      "ReimbursementRemoteDatasourceImpl.getReimbursementCategories response: $response",
    );

    final categories =
        response["GetAllJenisReimbursement"]["jenisReimbursement"]
            as List<dynamic>;
    return categories
        .map((v) => ReimbursementCategoryResponse.fromJson(v))
        .toList();
  }

  @override
  Future<ReimbursementResponse> createReimbursement(
    CreateReimbursementRequest request,
    List<MultipartFile?> attachments,
  ) async {
    logger.d(
      "ReimbursementRemoteDatasourceImpl.createReimbursement request: ${request.toJson()}",
    );

    final response = await gql.mutation(
      mutation: createReimbursementMutation,
      variables: {
        "input": request.toJson(),
        "file": attachments.isNotEmpty ? attachments.first : null,
      },
    );
    logger.d(
      "ReimbursementRemoteDatasourceImpl.createReimbursement response: $response",
    );

    final payload = _requireMutationPayload(response, 'CreateReimbursement');
    _requireUploadedFile(payload, attachments);
    return ReimbursementResponse.fromJson(payload);
  }

  @override
  Future<ReimbursementResponse> updateReimbursement(
    String id,
    CreateReimbursementRequest request,
    List<MultipartFile?> attachments,
  ) async {
    final response = await gql.mutation(
      mutation: updateReimbursementMutation,
      variables: {
        'id': id,
        'input': request.toJson(),
        'file': attachments.isNotEmpty ? attachments.first : null,
      },
    );
    final payload = _requireMutationPayload(response, 'UpdateReimbursement');
    _requireUploadedFile(payload, attachments);
    return ReimbursementResponse.fromJson(payload);
  }

  @override
  Future<void> deleteReimbursement(String id) async {
    final response = await gql.mutation(
      mutation: deleteReimbursementMutation,
      variables: {'id': id},
    );
    _requireMutationPayload(response, 'DeleteReimbursement');
  }

  Map<String, dynamic> _requireMutationPayload(
    dynamic response,
    String operation,
  ) {
    final payload = response is Map ? response[operation] : null;
    final id = payload is Map ? payload['_id']?.toString().trim() : null;
    if (payload is! Map<String, dynamic> || id == null || id.isEmpty) {
      throw GraphQlException(
        code: 'INVALID_RESPONSE',
        message: 'Server tidak mengonfirmasi reimbursement berhasil diproses.',
      );
    }
    return payload;
  }

  void _requireUploadedFile(
    Map<String, dynamic> payload,
    List<MultipartFile?> attachments,
  ) {
    if (attachments.isNotEmpty &&
        (payload['bukti_pembayaran']?.toString().trim().isEmpty ?? true)) {
      throw GraphQlException(
        code: 'UPLOAD_NOT_CONFIRMED',
        message:
            'Data tersimpan, tetapi upload bukti pembayaran tidak terkonfirmasi.',
      );
    }
  }
}
