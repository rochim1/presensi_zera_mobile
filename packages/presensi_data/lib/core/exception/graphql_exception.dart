import 'dart:async';
import 'dart:io';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import 'package:presensi_data/presensi_data.dart';

class GraphQlException implements Exception {
  final String? message;
  final String? code;
  final StackTrace? stacktrace;
  final String? error;
  final String? dataE;

  GraphQlException({
    this.code,
    this.stacktrace,
    this.message,
    this.error,
    this.dataE,
  });

  GraphQlException fromGraphQlError(OperationException exception) {
    final List<GraphQLError> errors = exception.graphqlErrors;
    final LinkException? linkException = exception.linkException;

    if (errors.isNotEmpty) {
      final firstError = errors.first;
      throw GraphQlException(
        message: firstError.message,
        code: firstError.extensions?['code']?.toString() ?? E001,
        error:
            '\n|--- path: [${firstError.path?.first}],\n|--- console: ${firstError.message},\n|--- extensions: ${firstError.extensions}',
      );
    } else if (linkException != null) {
      print(
        "GraphQlException: originalException = ${linkException.originalException}",
      );
      print(
        "GraphQlException: originalException.runtimeType = ${linkException.originalException?.runtimeType}",
      );
      if (linkException.originalException is TimeoutException) {
        //! Exception RTO from Client to Server
        FlavorConfig.instance.onConnectionError?.call(
          "Koneksi timeout, server tidak merespon",
        );
        throw GraphQlException(
          message: "E002 Timeout: ${linkException.originalException}",
          code: E002,
          error: linkException.originalException.toString(),
          stacktrace: linkException.originalStackTrace,
        );
      } else if (linkException.originalException is SocketException) {
        //! OS Error: Software caused connection abort
        FlavorConfig.instance.onConnectionError?.call(
          "Server tidak merespon, hubungi admin",
        );
        throw GraphQlException(
          message: "Server tidak merespon, hubungi admin",
          code: "E004",
          error: linkException.originalException.toString(),
          stacktrace: linkException.originalStackTrace,
        );
      } else if (linkException.originalException is ClientException) {
        //! ClientException — often wraps SocketException (connection refused)
        final originalMsg = linkException.originalException.toString();
        final isConnectionError =
            originalMsg.contains('SocketException') ||
            originalMsg.contains('Connection refused') ||
            originalMsg.contains('Connection reset') ||
            originalMsg.contains('Connection closed') ||
            originalMsg.contains('No address associated') ||
            originalMsg.contains('Network is unreachable');
        if (isConnectionError) {
          FlavorConfig.instance.onConnectionError?.call(
            "Server tidak merespon, hubungi admin",
          );
          throw GraphQlException(
            message: "Server tidak merespon, hubungi admin",
            code: "E004",
            error: originalMsg,
            stacktrace: linkException.originalStackTrace,
          );
        }
        FlavorConfig.instance.onConnectionError?.call(
          "Terjadi kesalahan koneksi, coba lagi nanti",
        );
        throw GraphQlException(
          message: "Terjadi kesalahan koneksi, coba lagi nanti",
          code: E003,
          error: originalMsg,
          stacktrace: linkException.originalStackTrace,
        );
      } else if (linkException.originalException is HandshakeException) {
        throw GraphQlException(
          message:
              "E010 HandshakeException: ${linkException.originalException}",
          code: E010,
          error: linkException.originalException.toString(),
          stacktrace: linkException.originalStackTrace,
        );
      } else if (linkException is ServerException) {
        //! Exception from Server
        if (linkException.parsedResponse != null) {
          throw _handleError(
            linkException.parsedResponse?.errors?.first,
            linkException.parsedResponse?.data,
          );
        } else {
          throw GraphQlException(
            message: E004 + EXCEPTION_UNKNOWN,
            code: E004,
            error: linkException.originalException.toString(),
            stacktrace: linkException.originalStackTrace,
          );
        }
      } else {
        throw GraphQlException(
          message:
              "E005 Unknown Link Exception: ${linkException.originalException}",
          error: linkException.originalException.toString(),
          stacktrace: linkException.originalStackTrace,
        );
      }
    } else {
      throw GraphQlException(message: E006 + EXCEPTION_UNKNOWN, code: E006);
    }
  }

  static GraphQlException _handleError(
    GraphQLError? error,
    Map<String, dynamic>? data,
  ) {
    if (error == null)
      throw GraphQlException(message: E007 + EXCEPTION_UNKNOWN, code: E007);

    if (error.extensions!.isEmpty) {
      throw GraphQlException(message: error.message);
    } else {
      switch (error.extensions!["code"]) {
        case 'UNAUTHORIZED':
          FlavorConfig.instance.onUnauthorized?.call();
          throw GraphQlException(
            code: error.extensions!["code"],
            message: EXCEPTION_UNAUTHORIZED,
            error: error.message,
            dataE: '${data?.entries.first.value}: ${data?.entries.last.key}',
            stacktrace: StackTraceUtil.fromListString(
              error.extensions?['stacktrace'],
            ),
          );
        case BAD_USER_INPUT:
          throw GraphQlException(
            code: error.extensions!["code"],
            message: EXCEPTION_USER_INPUT,
            error: error.message,
            dataE: '${data?.entries.first.value}: ${data?.entries.last.key}',
            stacktrace: StackTraceUtil.fromListString(
              error.extensions?['stacktrace'],
            ),
          );
        case PERSISTED_QUERY_NOT_FOUND:
          throw GraphQlException(
            code: error.extensions!["code"],
            message: E008 + EXCEPTION_METHOD,
            error: error.message,
            dataE: '${data?.entries.first.value}: ${data?.entries.last.key}',
            stacktrace: StackTraceUtil.fromListString(
              error.extensions?['stacktrace'],
            ),
          );
        case INTERNAL_SERVER_ERROR:
          throw GraphQlException(
            code: error.extensions!["code"],
            message: error.message,
            error: error.message,
            dataE: '${data?.entries.first.value}: ${data?.entries.last.key}',
            stacktrace: StackTraceUtil.fromListString(
              error.extensions?['stacktrace'],
            ),
          );
        case MISDIRECTED_REQUEST:
          throw GraphQlException(
            code: error.extensions!["code"],
            message: E009 + EXCEPTION_METHOD,
            error: error.message,
            dataE: '${data?.entries.first.value}: ${data?.entries.last.key}',
            stacktrace: StackTraceUtil.fromListString(
              error.extensions?['stacktrace'],
            ),
          );
        default:
          throw GraphQlException(
            code: error.extensions!["code"],
            message: error.message,
            error: error.message,
            dataE: '${data?.entries.first.value}: ${data?.entries.last.key}',
            stacktrace: StackTraceUtil.fromListString(
              error.extensions?['stacktrace'],
            ),
          );
      }
    }
  }

  @override
  String toString() =>
      'GraphQlException(\n|- message: $message,\n|- code: $code,\n|- dataE: $dataE,\n|- error: $error,\n|- stacktrace: $stacktrace\n)';
}

class GraphQlCacheException implements Exception {
  final String? message;
  final String? code;

  GraphQlCacheException({this.message, this.code});

  @override
  String toString() =>
      'GraphQlCacheException(\n|- message: $message,\n|- code: $code)';
}

class GraphQlUnknownException implements Exception {
  final String? message;
  final String? code;

  GraphQlUnknownException({this.message, this.code});

  @override
  String toString() =>
      'GraphQlUnknownException(\n|- message: $message,\n|- code: $code)';
}
