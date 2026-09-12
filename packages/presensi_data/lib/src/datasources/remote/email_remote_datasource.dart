import 'package:presensi_data/core/failure/failure.dart';
import 'package:presensi_data/graphql/email_graphql.dart';
import 'package:presensi_data/src/models/email/email_model.dart';
import 'package:presensi_data/service/graphql/graphql_service.dart';

abstract class EmailRemoteDataSource {
  Future<int> countUnreadEmail();
  Future<List<EmailModel>> getAllEmail({
    Map<String, dynamic>? filter,
    int? limit,
    int? offset,
  });
  Future<void> readEmail(String id);
}

class EmailRemoteDataSourceImpl implements EmailRemoteDataSource {
  final GraphQlService graphQlService;

  EmailRemoteDataSourceImpl({required this.graphQlService});

  @override
  Future<int> countUnreadEmail() async {
    try {
      final data = await graphQlService.query(
        query: EmailGraphQL.countUnreadEmail,
      );
      return data['CountUnreadEmail'] as int? ?? 0;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<List<EmailModel>> getAllEmail({
    Map<String, dynamic>? filter,
    int? limit,
    int? offset,
  }) async {
    try {
      final data = await graphQlService.query(
        query: EmailGraphQL.getAllEmail,
        variables: {
          if (filter != null) 'filter': filter,
          if (limit != null) 'limit': limit,
          if (offset != null) 'offset': offset,
        },
      );

      final listData = data['GetAllEmail'] as List?;
      if (listData == null) return [];

      return listData.map((e) => EmailModel.fromJson(e)).toList();
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<void> readEmail(String id) async {
    try {
      await graphQlService.mutation(
        mutation: EmailGraphQL.readEmail,
        variables: {
          '_id': id,
        },
      );
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}
