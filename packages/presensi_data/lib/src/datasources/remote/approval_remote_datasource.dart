import 'package:logger/logger.dart';
import 'package:presensi_data/presensi_data.dart';

abstract class ApprovalRemoteDatasource {
  Future<void> createApproval(CreateApprovalRequest request);

  Future<List<ApprovalHistoryResponse>> getMyPendingApprovals(
    GetMyPendingApprovalsRequest request,
    PaginationRequest pagination,
  );

  Future<TestWorkflowUserResponse> testWorkflowUser(
    TestWorkflowUserRequest request,
  );
}

class ApprovalRemoteDatasourceImpl
    with ApprovalGraphQl
    implements ApprovalRemoteDatasource {
  final GraphQlService gql;
  final Logger logger;

  ApprovalRemoteDatasourceImpl({required this.gql, required this.logger});

  @override
  Future<void> createApproval(CreateApprovalRequest request) async {
    final response = await gql.mutation(
      mutation: createApprovalMutation,
      variables: {"input": request.toJson()},
    );
    logger.d("ApprovalRemoteDatasourceImpl.createApproval response: $response");
  }

  @override
  Future<List<ApprovalHistoryResponse>> getMyPendingApprovals(
    GetMyPendingApprovalsRequest request,
    PaginationRequest pagination,
  ) async {
    logger.d(
      "ApprovalRemoteDatasourceImpl.getMyPendingApprovals request: ${request.toJson()}\n pagination: ${pagination.toJson()}",
    );

    final response = await gql.query(
      query: getMyPendingApprovalsQuery,
      variables: {
        "requestType": request.requestType?.name,
        "startDate": request.startDate?.toIso8601String(),
        "endDate": request.endDate?.toIso8601String(),
        "pagination": pagination.toJson(),
      },
    );
    logger.d(
      "ApprovalRemoteDatasourceImpl.getMyPendingApprovals response: $response",
    );

    final approvals = response["GetMyPendingApprovals"] as List<dynamic>;

    return approvals.map((v) => ApprovalHistoryResponse.fromJson(v)).toList();
  }

  @override
  Future<TestWorkflowUserResponse> testWorkflowUser(
    TestWorkflowUserRequest request,
  ) async {
    logger.d(
      "ApprovalRemoteDatasourceImpl.testWorkflowUser request: ${request.toJson()}",
    );

    final response = await gql.query(
      query: testWorkflowUserQuery,
      variables: request.toJson(),
    );
    logger.d(
      "ApprovalRemoteDatasourceImpl.testWorkflowUser response: $response",
    );

    return TestWorkflowUserResponse.fromJson(response["TestWorkflowUser"]);
  }
}
