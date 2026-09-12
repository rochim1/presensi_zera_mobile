import 'package:dio/dio.dart';
import 'package:presensi_data/presensi_data.dart';

class RestException implements Exception {
  final String? message;

  RestException({this.message});

  fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.cancel:
        throw RestException(message: EXCEPTION_CANCEL);
      case DioExceptionType.connectionTimeout:
        throw RestException(message: EXCEPTION_CONNECTION_RTO);
      case DioExceptionType.receiveTimeout:
        throw RestException(message: EXCEPTION_RECEIVE_RTO);
      case DioExceptionType.badResponse:
        throw _handleError(
          dioError.response!.statusCode!,
          dioError.response!.data,
        );
      case DioExceptionType.sendTimeout:
        throw RestException(message: EXCEPTION_SEND_RTO);
      case DioExceptionType.connectionError:
        throw RestException(message: EXCEPTION_OTHER);
      default:
        throw RestException(message: EXCEPTION_UNKNOWN);
    }
  }

  static RestException _handleError(int statusCode, dynamic error) {
    switch (statusCode) {
      case 400:
        throw RestException(message: error['message']);
      case 401:
        throw RestException(message: EXCEPTION_UNAUTHORIZED);
      case 404:
        throw RestException(message: EXCEPTION_NOT_FOUND);
      case 405:
        throw RestException(message: EXCEPTION_METHOD);
      case 415:
        throw RestException(message: EXCEPTION_MEDIA_TYPE);
      case 500:
        throw RestException(message: EXCEPTION_ISE);
      default:
        throw RestException(message: EXCEPTION_UNKNOWN);
    }
  }
}

class RestAuthException implements Exception {
  final String? message;

  RestAuthException({this.message});

  factory RestAuthException.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.cancel:
        throw RestAuthException(message: EXCEPTION_CANCEL);
      case DioExceptionType.connectionTimeout:
        throw RestAuthException(message: EXCEPTION_CONNECTION_RTO);
      case DioExceptionType.receiveTimeout:
        throw RestAuthException(message: EXCEPTION_RECEIVE_RTO);
      case DioExceptionType.badResponse:
        throw _handleError(
          dioError.response!.statusCode!,
          dioError.response!.data,
        );
      case DioExceptionType.sendTimeout:
        throw RestAuthException(message: EXCEPTION_SEND_RTO);
      case DioExceptionType.connectionError:
        throw RestAuthException(message: EXCEPTION_OTHER);
      default:
        throw RestAuthException(message: EXCEPTION_UNKNOWN);
    }
  }

  static RestAuthException _handleError(int statusCode, dynamic error) {
    if (statusCode < 200 || statusCode >= 300) {
      throw RestAuthException(message: error['message']);
    } else if (statusCode == 400) {
      throw RestAuthException(message: EXCEPTION_AUTH_INVALID);
    } else if (statusCode == 401) {
      return RestAuthException(message: EXCEPTION_LOGIN_INVALID);
    } else if (statusCode == 404) {
      throw RestAuthException(message: EXCEPTION_NOT_FOUND);
    } else if (statusCode == 405) {
      throw RestAuthException(message: EXCEPTION_METHOD);
    } else if (statusCode == 500) {
      throw RestAuthException(message: EXCEPTION_ISE);
    } else {
      throw RestAuthException(message: EXCEPTION_UNKNOWN);
    }
  }
}

class RestCacheException implements Exception {
  final String? message;

  RestCacheException({this.message});
}

class RestUnknownException implements Exception {
  final String? message;

  RestUnknownException({this.message});
}
