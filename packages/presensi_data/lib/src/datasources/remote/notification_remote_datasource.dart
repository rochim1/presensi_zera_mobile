import 'package:logger/logger.dart';
import 'package:presensi_data/presensi_data.dart';

abstract class NotificationRemoteDatasource {
  Future<int> getUnreadNotificationsCount();

  Future<List<NotificationResponse>> getNotifications(
    GetNotificationsRequest request,
    PaginationRequest pagination,
  );

  Future<void> markAsReadById(String id);

  Future<void> deleteById(String id);
}

class NotificationRemoteDatasourceImpl
    with NotificationGrapql
    implements NotificationRemoteDatasource {
  final GraphQlService gql;
  final Logger logger;

  NotificationRemoteDatasourceImpl({required this.gql, required this.logger});

  @override
  Future<int> getUnreadNotificationsCount() async {
    final response = await gql.query(query: getUnreadNotificationsCountQuery);
    logger.d(
      "NotificationRemoteDatasourceImpl.getUnreadNotificationsCount response: $response",
    );

    return response["CountUnreadNotifikasi"] as int? ?? 0;
  }

  @override
  Future<List<NotificationResponse>> getNotifications(
    GetNotificationsRequest request,
    PaginationRequest pagination,
  ) async {
    logger.d(
      "NotificationRemoteDatasourceImpl.getNotifications request: ${request.toJson()}\n pagination: ${pagination.toJson()}",
    );

    final response = await gql.query(
      query: getNotificationsQuery,
      variables: {
        "filter": request.toJson(),
        "pagination": pagination.toJson(),
      },
    );
    logger.d(
      "NotificationRemoteDatasourceImpl.getNotifications response: $response",
    );

    final notifications =
        response["GetAllNotifikasi"]["notifikasi"] as List<dynamic>;

    return notifications.map((v) => NotificationResponse.fromJson(v)).toList();
  }

  @override
  Future<void> deleteById(String id) async {
    logger.d("NotificationRemoteDatasourceImpl.deleteById id: $id");

    final response = await gql.mutation(
      mutation: deleteByIdMutation,
      variables: {"id": id},
    );
    logger.d("NotificationRemoteDatasourceImpl.deleteById response: $response");
  }

  @override
  Future<void> markAsReadById(String id) async {
    logger.d("NotificationRemoteDatasourceImpl.markAsReadById id: $id");

    final response = await gql.mutation(
      mutation: markAsReadByIdMutation,
      variables: {"id": id},
    );
    logger.d(
      "NotificationRemoteDatasourceImpl.markAsReadById response: $response",
    );
  }
}
