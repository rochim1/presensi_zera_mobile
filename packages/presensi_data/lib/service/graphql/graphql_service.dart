import 'dart:developer';
import 'dart:io';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import 'package:presensi_data/presensi_data.dart';

class GraphQlService extends GraphQlException {
  final GraphqlLinkService linkService;
  late FlavorConfig flavor;

  late final GraphQLClient _graphQlConfig;

  GraphQlService({required this.flavor, required this.linkService}) {
    flavor = FlavorConfig.instance;
    log("BasApi info => ${flavor.env} > ${flavor.values!.baseApi}");
    log("FCM Token => ${flavor.appId}");

    _graphQlConfig = GraphQLClient(
      cache: GraphQLCache(store: InMemoryStore()),
      link: Link.from([linkService]),
      queryRequestTimeout: flavor.values?.delay ?? const Duration(minutes: 5),
      defaultPolicies: DefaultPolicies(
        query: Policies(
          cacheReread: CacheRereadPolicy.ignoreAll,
          fetch: FetchPolicy.noCache,
        ),
      ),
    );
  }

  GraphQLClient get client => _graphQlConfig;

  /// QUERY for fecth data like GET
  Future<dynamic> query({
    required String query,
    Map<String, dynamic>? variables,
  }) async {
    final queryOptions = QueryOptions(
      document: gql(query),
      variables: variables ?? {},
      queryRequestTimeout: flavor.values?.delay ?? const Duration(minutes: 5),
    );

    final QueryResult result = await _graphQlConfig.query(queryOptions);

    if (result.hasException) {
      throw fromGraphQlError(result.exception!);
    } else {
      return result.data;
    }
  }

  /// MUTATION for fetch data like POST, UPDATE, DELETE
  Future<dynamic> mutation({
    required String mutation,
    Map<String, dynamic>? variables,
  }) async {
    final mutationOptions = MutationOptions(
      document: gql(mutation),
      variables: variables ?? {},
      queryRequestTimeout: flavor.values?.delay ?? const Duration(minutes: 5),
    );

    final QueryResult result = await _graphQlConfig.mutate(mutationOptions);
    if (result.hasException) {
      throw fromGraphQlError(result.exception!);
    } else {
      return result.data;
    }
  }

  /// MUTATION WITH SINGLE FILE
  Future<dynamic> fileUpload({
    required String mutation,
    required String key,
    required File file,
  }) async {
    // get file name from [File]
    String fileName = file.path.split('/').last;
    var byteData = file.readAsBytesSync();

    // [File] convert to byte
    var multipartFile = MultipartFile.fromBytes(
      'file',
      byteData,
      filename: fileName,
    );

    final options = MutationOptions(
      document: gql(mutation),
      variables: {key: multipartFile},
      queryRequestTimeout: flavor.values?.delay ?? const Duration(minutes: 5),
    );

    final QueryResult result = await _graphQlConfig.mutate(options);

    if (result.hasException) {
      throw fromGraphQlError(result.exception!);
    } else {
      return result.data;
    }
  }
}
