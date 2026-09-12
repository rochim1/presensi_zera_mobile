import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:presensi_data/presensi_data.dart';

abstract class PayrollRemoteDatasource {
  Future<List<PayrollSlipResponse>> getPayrollSlips(
    GetPayrollSlipsRequest request,
    PaginationRequest pagination,
  );

  Future<PayrollSlipResponse> getPayrollSlipById(String id);

  Future<PayrollSlipPdfResponse> downloadPayrollSlipPdf({
    required String id,
    required String token,
  });
}

class PayrollRemoteDatasourceImpl
    with PayrollGraphQl
    implements PayrollRemoteDatasource {
  final GraphQlService gql;
  final Logger logger;

  PayrollRemoteDatasourceImpl({required this.gql, required this.logger});

  @override
  Future<List<PayrollSlipResponse>> getPayrollSlips(
    GetPayrollSlipsRequest request,
    PaginationRequest pagination,
  ) async {
    logger.d(
      "PayrollRemoteDatasourceImpl.getPayrollSlips request: ${request.toJson()}\n pagination: ${pagination.toJson()}",
    );

    final response = await gql.query(
      query: getPayrollSlipsQuery,
      variables: {
        "filter": {...request.toJson(), "my_only": true},
        "pagination": pagination.toJson(),
      },
    );
    logger.d('Payroll slip list berhasil dimuat');

    final payrollSlips =
        response["GetAllPayrollSlips"]["data"] as List<dynamic>;

    return payrollSlips
        .map((v) => PayrollSlipResponse.fromJson(v as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<PayrollSlipResponse> getPayrollSlipById(String id) async {
    logger.d("PayrollRemoteDatasourceImpl.getPayrollSlipById request: $id");

    final response = await gql.query(
      query: getPayrollSlipByIdQuery,
      variables: {"id": id, "myOnly": true},
    );
    logger.d('Detail slip payroll berhasil dimuat');

    return PayrollSlipResponse.fromJson(
      response["GetPayrollSlipById"] as Map<String, dynamic>,
    );
  }

  @override
  Future<PayrollSlipPdfResponse> downloadPayrollSlipPdf({
    required String id,
    required String token,
  }) async {
    logger.d("PayrollRemoteDatasourceImpl.downloadPayrollSlipPdf request: $id");

    try {
      // Use the runtime URL selected on the login/development screen first.
      // On a device, the bundled development URL may be localhost (the device
      // itself), while GraphQL is already connected through this override.
      final baseApi =
          FlavorConfig.instance.baseApi ??
          FlavorConfig.instance.values?.baseApi;
      if (baseApi == null || baseApi.isEmpty) {
        throw RestException(message: EXCEPTION_UNKNOWN);
      }

      final baseUri = Uri.parse(baseApi);
      if (!baseUri.hasScheme || baseUri.host.isEmpty) {
        throw RestException(message: 'Alamat server tidak valid');
      }
      final uri = baseUri.replace(
        path: '/api/payroll/slip/$id/pdf',
        query: null,
        fragment: null,
      );

      final dio = Dio(
        BaseOptions(
          responseType: ResponseType.bytes,
          headers: {'Authorization': 'Bearer $token'},
          receiveTimeout: const Duration(minutes: 5),
          connectTimeout: const Duration(minutes: 1),
          sendTimeout: const Duration(minutes: 1),
          validateStatus: (status) => status != null && status < 600,
        ),
      );

      final response = await dio.getUri<List<int>>(uri);
      final statusCode = response.statusCode ?? 0;
      if (statusCode < 200 || statusCode >= 300) {
        final message =
            _extractMessageFromDioResponseData(response.data) ??
            _messageFromStatusCode(statusCode);
        throw RestException(message: message);
      }

      final bytes = response.data;
      if (bytes == null || bytes.isEmpty) {
        throw RestException(message: EXCEPTION_NOT_FOUND);
      }

      final headerContentDisposition = response.headers.value(
        'content-disposition',
      );
      final fileName =
          _parseFileNameFromContentDisposition(headerContentDisposition) ??
          'slip_gaji_$id.pdf';

      logger.d(
        "PayrollRemoteDatasourceImpl.downloadPayrollSlipPdf success: ${bytes.length} bytes",
      );

      return PayrollSlipPdfResponse(
        bytes: Uint8List.fromList(bytes),
        fileName: fileName,
      );
    } on DioException catch (e, stackTrace) {
      logger.e(
        "PayrollRemoteDatasourceImpl.downloadPayrollSlipPdf dio",
        error: e,
        stackTrace: stackTrace,
      );
      final message = _extractMessageFromDioResponseData(e.response?.data);
      if (message != null && message.isNotEmpty) {
        throw RestException(message: message);
      }
      throw RestException().fromDioError(e);
    } on RestException {
      rethrow;
    } catch (e, stackTrace) {
      logger.e(
        "PayrollRemoteDatasourceImpl.downloadPayrollSlipPdf unknown",
        error: e,
        stackTrace: stackTrace,
      );
      throw RestException(message: EXCEPTION_UNKNOWN);
    }
  }

  String? _parseFileNameFromContentDisposition(String? value) {
    if (value == null || value.isEmpty) return null;

    final utf8Match = RegExp(
      "filename\\*=UTF-8''([^;]+)",
      caseSensitive: false,
    ).firstMatch(value);
    if (utf8Match != null) {
      return Uri.decodeFull(utf8Match.group(1)!);
    }

    final basicMatch = RegExp(
      'filename="?([^";]+)"?',
      caseSensitive: false,
    ).firstMatch(value);
    return basicMatch?.group(1);
  }

  String _messageFromStatusCode(int statusCode) {
    switch (statusCode) {
      case 401:
        return EXCEPTION_UNAUTHORIZED;
      case 404:
        return EXCEPTION_NOT_FOUND;
      case 405:
        return EXCEPTION_METHOD;
      case 415:
        return EXCEPTION_MEDIA_TYPE;
      case 500:
        return EXCEPTION_ISE;
      default:
        return EXCEPTION_UNKNOWN;
    }
  }

  String? _extractMessageFromDioResponseData(dynamic data) {
    if (data == null) return null;

    if (data is Map) {
      final message = data['message'];
      if (message is String && message.trim().isNotEmpty) {
        return message.trim();
      }
      return null;
    }

    if (data is List<int>) {
      final text = utf8.decode(data, allowMalformed: true).trim();
      if (text.isEmpty) return null;
      try {
        final decoded = jsonDecode(text);
        if (decoded is Map) {
          final message = decoded['message'];
          if (message is String && message.trim().isNotEmpty) {
            return message.trim();
          }
        }
      } catch (_) {
        return null;
      }
    }

    if (data is String && data.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map) {
          final message = decoded['message'];
          if (message is String && message.trim().isNotEmpty) {
            return message.trim();
          }
        }
      } catch (_) {
        return null;
      }
    }

    return null;
  }
}
