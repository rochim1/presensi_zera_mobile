import 'package:presensi_data/presensi_data.dart';

abstract class LogbookRemoteDatasource {
  Future<List<LogbookEntry>> getAllLogbook({
    int page,
    int limit,
    String? startDate,
    String? endDate,
    String? userId,
    bool allUsers = false,
  });

  Future<List<LogbookUserSummary>> getUserSummaries({
    String? startDate,
    String? endDate,
  });

  Future<void> createLogbook(Map<String, dynamic> input);

  Future<void> updateLogbook(Map<String, dynamic> input);

  Future<void> deleteLogbook(String id);

  Future<List<String>> getCategories();

  Future<String> createCategory(String name);

  Future<LogbookCheckoutPolicyTestResult> testUserLogbookCheckoutPolicy(
    String userId,
  );
}

class LogbookRemoteDatasourceImpl
    with LogbookGraphQl
    implements LogbookRemoteDatasource {
  final GraphQlService gql;

  LogbookRemoteDatasourceImpl({required this.gql});

  @override
  Future<List<LogbookEntry>> getAllLogbook({
    int page = 1,
    int limit = 30,
    String? startDate,
    String? endDate,
    String? userId,
    bool allUsers = false,
  }) async {
    final variables = <String, dynamic>{'page': page, 'limit': limit};
    if (startDate != null) variables['startDate'] = startDate;
    if (endDate != null) variables['endDate'] = endDate;
    if (userId != null && userId.isNotEmpty) variables['userId'] = userId;
    if (allUsers) variables['allUsers'] = true;

    final response = await gql.query(
      query: getAllLogbookQuery,
      variables: variables,
    );

    final data = response['GetAllLogbook']['data'] as List<dynamic>;
    return data.map((e) => LogbookEntry.fromJson(e)).toList();
  }

  @override
  Future<List<LogbookUserSummary>> getUserSummaries({
    String? startDate,
    String? endDate,
  }) async {
    final variables = <String, dynamic>{};
    if (startDate != null) variables['startDate'] = startDate;
    if (endDate != null) variables['endDate'] = endDate;
    final response = await gql.query(
      query: getLogbookUserSummariesQuery,
      variables: variables,
    );
    final data = response['GetLogbookUserSummaries'] as List<dynamic>? ?? [];
    return data
        .whereType<Map<String, dynamic>>()
        .map(LogbookUserSummary.fromJson)
        .where((summary) => summary.userId.isNotEmpty)
        .toList();
  }

  @override
  Future<void> createLogbook(Map<String, dynamic> input) async {
    await gql.mutation(
      mutation: createLogbookMutation,
      variables: {'input': input},
    );
  }

  @override
  Future<void> updateLogbook(Map<String, dynamic> input) async {
    await gql.mutation(
      mutation: updateLogbookMutation,
      variables: {'input': input},
    );
  }

  @override
  Future<void> deleteLogbook(String id) async {
    await gql.mutation(mutation: deleteLogbookMutation, variables: {'id': id});
  }

  @override
  Future<List<String>> getCategories() async {
    final response = await gql.query(
      query: getAllKategoriLogbookQuery,
      variables: {'limit': 100, 'page': 1, 'status': 'active'},
    );
    final data =
        response['GetAllKategoriLogbook']?['data'] as List<dynamic>? ?? [];
    return data
        .map((e) => e is Map<String, dynamic> ? e['nama_kategori'] : null)
        .whereType<String>()
        .map((name) => name.trim())
        .where((name) => name.isNotEmpty)
        .toSet()
        .toList();
  }

  @override
  Future<String> createCategory(String name) async {
    final response = await gql.mutation(
      mutation: createKategoriLogbookMutation,
      variables: {
        'input': {'nama_kategori': name.trim()},
      },
    );
    final created = response['CreateKategoriLogbook'] as Map<String, dynamic>?;
    final categoryName = created?['nama_kategori']?.toString().trim();
    if (categoryName == null || categoryName.isEmpty) {
      throw Exception('Kategori logbook gagal dibuat');
    }
    return categoryName;
  }

  @override
  Future<LogbookCheckoutPolicyTestResult> testUserLogbookCheckoutPolicy(
    String userId,
  ) async {
    final response = await gql.query(
      query: testUserLogbookCheckoutPolicyQuery,
      variables: {'userId': userId},
    );
    final data =
        response['TestUserLogbookCheckoutPolicy'] as Map<String, dynamic>;
    return LogbookCheckoutPolicyTestResult.fromJson(data);
  }
}
