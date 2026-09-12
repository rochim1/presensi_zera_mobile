import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_domain/presensi_domain.dart';

abstract class RecordPaymentState {}

class RecordPaymentInitial extends RecordPaymentState {}

class RecordPaymentLoading extends RecordPaymentState {}

class RecordPaymentSuccess extends RecordPaymentState {
  final SalesOrderEntity order;
  RecordPaymentSuccess(this.order);
}

class RecordPaymentError extends RecordPaymentState {
  final String message;
  RecordPaymentError(this.message);
}

class RecordPaymentCubit extends Cubit<RecordPaymentState> {
  final RecordSalesPayment recordSalesPayment;

  RecordPaymentCubit({required this.recordSalesPayment}) : super(RecordPaymentInitial());

  Future<void> recordPayment({
    required String orderId,
    required double jumlahBayar,
    String? catatan,
  }) async {
    emit(RecordPaymentLoading());
    final result = await recordSalesPayment(
      orderId: orderId,
      jumlahBayar: jumlahBayar,
      catatan: catatan,
    );
    result.fold(
      (failure) => emit(RecordPaymentError(failure.message)),
      (order) => emit(RecordPaymentSuccess(order)),
    );
  }
}
