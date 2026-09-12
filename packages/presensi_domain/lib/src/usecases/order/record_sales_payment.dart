import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

class RecordSalesPayment {
  final OrderRepository repository;
  RecordSalesPayment(this.repository);

  Future<Either<Failure, SalesOrderEntity>> call({
    required String orderId,
    required double jumlahBayar,
    String? catatan,
  }) {
    return repository.recordSalesPayment(
      orderId: orderId,
      jumlahBayar: jumlahBayar,
      catatan: catatan,
    );
  }
}
