import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:presensi_data/presensi_data.dart';

class GraphqlLinkService extends Link {
  final FlavorConfig flavor;
  GraphqlLinkService(this.flavor);

  late LoginLocalDatasourceImpl localDatasource = LoginLocalDatasourceImpl();

  @override
  Stream<Response> request(Request request, [NextLink? forward]) async* {
    String? baseApi;
    if (flavor.env! == Env.DEVELOPMENT) baseApi = flavor.baseApi;
    final http.Client client = kDebugMode
        ? ChuckerHttpClient(http.Client())
        : http.Client();
    final httpLink = HttpLink(
      baseApi ?? flavor.values!.baseApi!,
      httpClient: client,
    );

    // TIP: do not forget getting new Request instance!
    try {
      final token = flavor.token?.trim();
      final Request req = request.updateContextEntry<HttpLinkHeaders>(
        (HttpLinkHeaders? headers) => HttpLinkHeaders(
          headers: <String, String>{
            ...headers?.headers ?? <String, String>{},
            if (token != null && token.isNotEmpty)
              'Authorization': 'Bearer $token',
            'apps_id': flavor.appId ?? '',
            // Never ship the shared mobile credential to browser clients: all
            // web assets and requests can be inspected by the end user. Web
            // access is authenticated by the user token and backend CORS.
            if (!kIsWeb) 'X-API-Key': dotenv.env['MOBILE_API_KEY'] ?? '',
          },
        ),
      );

      //! and "return" new Request with updated headers
      yield* httpLink.request(req, forward);
    } catch (e) {
      yield* httpLink.request(request, forward);
    }
  }
}
