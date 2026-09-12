import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class RestService extends RestException {
  final FlavorConfig env;

  RestService(this.env) {
    FlavorConfig? env = FlavorConfig.instance;
    log("FlavorConfig info => ${env.env},[${env.values!.baseApi}] ");
  }

  static String authToken = '';

  static final PrettyDioLogger _logger = PrettyDioLogger(
    responseBody: false,
    request: false,
    requestBody: false,
    responseHeader: false,
    compact: false,
  );

  Future<dynamic> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final BaseOptions option = BaseOptions(
        baseUrl: FlavorConfig.instance.values!.baseApi!,
        headers: {
          'Content-Type': 'application/json',
          'authorization': authToken,
        },
      );

      final Dio dio = Dio(option)..interceptors.add(_logger);

      final Response response = await dio.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
      if (e is DioException) {
        throw fromDioError(e);
      } else {
        rethrow;
      }
    }
  }

  Future<dynamic> post(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final BaseOptions option = BaseOptions(
        baseUrl: FlavorConfig.instance.values!.baseApi!,
        receiveTimeout: FlavorConfig.instance.values!.delay,
        connectTimeout: FlavorConfig.instance.values!.delay,
        sendTimeout: FlavorConfig.instance.values!.delay,
        headers: {
          'Content-Type': 'application/json',
          'authorization': authToken,
        },
      );

      final Dio dio = Dio(option)..interceptors.add(_logger);

      final Response response = await dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
      if (e is DioException) {
        throw fromDioError(e);
      } else {
        rethrow;
      }
    }
  }

  Future<dynamic> delete(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final BaseOptions option = BaseOptions(
        baseUrl: FlavorConfig.instance.values!.baseApi!,
        receiveTimeout: FlavorConfig.instance.values!.delay,
        connectTimeout: FlavorConfig.instance.values!.delay,
        sendTimeout: FlavorConfig.instance.values!.delay,
        headers: {
          'Content-Type': 'application/json',
          'authorization': authToken,
        },
      );

      final Dio dio = Dio(option)..interceptors.add(_logger);

      final Response response = await dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
      if (e is DioException) {
        throw fromDioError(e);
      } else {
        rethrow;
      }
    }
  }

  Future<dynamic> put(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final BaseOptions option = BaseOptions(
        baseUrl: FlavorConfig.instance.values!.baseApi!,
        receiveTimeout: FlavorConfig.instance.values!.delay,
        connectTimeout: FlavorConfig.instance.values!.delay,
        sendTimeout: FlavorConfig.instance.values!.delay,
        headers: {
          'Content-Type': 'application/json',
          'authorization': authToken,
        },
      );

      final Dio dio = Dio(option)..interceptors.add(_logger);

      final Response response = await dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
      if (e is DioException) {
        throw fromDioError(e);
      } else {
        rethrow;
      }
    }
  }

  Future<dynamic> postLogin(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      BaseOptions option = BaseOptions(
        baseUrl: FlavorConfig.instance.values!.baseApi!,
        receiveTimeout: FlavorConfig.instance.values!.delay,
        connectTimeout: FlavorConfig.instance.values!.delay,
        sendTimeout: FlavorConfig.instance.values!.delay,
        headers: {'Content-Type': 'application/json'},
      );

      final dio = Dio(option)..interceptors.add(_logger);

      final Response response = await dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
      if (e is DioException) {
        throw RestAuthException.fromDioError(e);
      } else {
        rethrow;
      }
    }
  }

  /// for [fileName] please write e.g 'country_20230125_1102',
  /// for [fileType] please write e.g 'xlsx', `pdf`, `doc` etc.
  Future<dynamic> download(
    String uri, {
    required String fileName,
    required bool isWeb,
    required String fileType,
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      BaseOptions option = BaseOptions(
        baseUrl: FlavorConfig.instance.values!.baseApi!,
        receiveTimeout: FlavorConfig.instance.values!.delay,
        connectTimeout: FlavorConfig.instance.values!.delay,
        sendTimeout: FlavorConfig.instance.values!.delay,
        headers: {
          'content-disposition': 'attachment; filename="$fileName.$fileType"',
          'authorization': authToken,
        },
      );

      final dio = Dio(option)..interceptors.add(_logger);

      final Response response = await dio.download(
        uri,
        fileName,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      return response.data;
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
      if (e is DioException) {
        throw fromDioError(e);
      } else {
        rethrow;
      }
    }
  }
}
