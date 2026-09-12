import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

import 'payroll_detail_state.dart';

class PayrollDetailCubit extends Cubit<PayrollDetailState> {
  final GetPayrollSlipById getPayrollSlipByIdUseCase;
  final DownloadPayrollSlipPdf downloadPayrollSlipPdfUseCase;
  final Logger logger;

  PayrollDetailCubit({
    required this.getPayrollSlipByIdUseCase,
    required this.downloadPayrollSlipPdfUseCase,
    required this.logger,
  }) : super(const PayrollDetailState());

  String? _slipId;

  Future<void> init(String slipId) async {
    _slipId = slipId;
    await getPayrollSlipById();
  }

  Future<void> getPayrollSlipById() async {
    if (_slipId == null || _slipId!.isEmpty) {
      emit(
        state.copyWith(payrollSlip: BaseState.failure(const NotFoundFailure())),
      );
      return;
    }

    emit(state.copyWith(payrollSlip: BaseState.loading()));

    final result = await getPayrollSlipByIdUseCase.call(_slipId!);

    result.fold(
      (failure) {
        emit(state.copyWith(payrollSlip: BaseState.failure(failure)));
      },
      (value) {
        emit(state.copyWith(payrollSlip: BaseState.success(value)));
      },
    );
  }

  Future<void> onRefresh() async {
    await getPayrollSlipById();
  }

  Future<void> downloadPayrollSlipPdf() async {
    if (_slipId == null || _slipId!.isEmpty) {
      emit(
        state.copyWith(
          downloadSlipPdf: BaseState.failure(const NotFoundFailure()),
        ),
      );
      return;
    }

    if (state.downloadSlipPdf.isLoading) return;

    emit(state.copyWith(downloadSlipPdf: BaseState.loading()));

    try {
      final result = await downloadPayrollSlipPdfUseCase.call(_slipId!);
      await result.fold<Future<void>>(
        (failure) async {
          emit(state.copyWith(downloadSlipPdf: BaseState.failure(failure)));
        },
        (value) async {
          try {
            final fileName = _sanitizeFileName(value.fileName);
            final savedLocation = await _saveSlipPdf(
              bytes: value.bytes,
              fileName: fileName,
            );
            emit(
              state.copyWith(downloadSlipPdf: BaseState.success(savedLocation)),
            );
          } on PlatformException catch (e, stackTrace) {
            logger.e(
              "PayrollDetailCubit.downloadPayrollSlipPdf platform",
              error: e,
              stackTrace: stackTrace,
            );
            emit(
              state.copyWith(
                downloadSlipPdf: BaseState.failure(
                  UnknownFailure(
                    message: e.message?.trim().isNotEmpty == true
                        ? e.message!.trim()
                        : FAILURE_UNKNOWN,
                  ),
                ),
              ),
            );
          } catch (e, stackTrace) {
            logger.e(
              "PayrollDetailCubit.downloadPayrollSlipPdf save",
              error: e,
              stackTrace: stackTrace,
            );
            emit(
              state.copyWith(
                downloadSlipPdf: BaseState.failure(
                  UnknownFailure(message: _extractErrorMessage(e)),
                ),
              ),
            );
          }
        },
      );
    } catch (e, stackTrace) {
      logger.e(
        "PayrollDetailCubit.downloadPayrollSlipPdf unexpected",
        error: e,
        stackTrace: stackTrace,
      );
      emit(
        state.copyWith(
          downloadSlipPdf: BaseState.failure(const UnknownFailure()),
        ),
      );
    } finally {
      // Safety net: never leave button in loading state on unexpected flow.
      if (state.downloadSlipPdf.isLoading) {
        emit(
          state.copyWith(
            downloadSlipPdf: BaseState.failure(const UnknownFailure()),
          ),
        );
      }
    }
  }

  void clearDownloadSlipPdfState() {
    emit(state.copyWith(downloadSlipPdf: BaseState.initial()));
  }

  String _sanitizeFileName(String value) {
    final name = value.trim().isEmpty
        ? 'slip_gaji_${_slipId ?? "file"}.pdf'
        : value.trim();
    final cleaned = name.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
    if (cleaned.toLowerCase().endsWith('.pdf')) return cleaned;
    return '$cleaned.pdf';
  }

  Future<String> _saveSlipPdf({
    required Uint8List bytes,
    required String fileName,
  }) async {
    Directory? directory;
    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    if (directory == null) {
      throw Exception('Gagal mendapatkan direktori penyimpanan');
    }

    final payrollDirectory = Directory('${directory.path}/SlipGaji');
    if (!await payrollDirectory.exists()) {
      await payrollDirectory.create(recursive: true);
    }

    final filePath = '${payrollDirectory.path}/$fileName';
    final file = File(filePath);
    await file.writeAsBytes(bytes, flush: true);
    return filePath;
  }

  String _extractErrorMessage(Object e) {
    final text = e.toString().replaceFirst('Exception: ', '').trim();
    if (text.isEmpty) return FAILURE_UNKNOWN;
    return text;
  }
}
