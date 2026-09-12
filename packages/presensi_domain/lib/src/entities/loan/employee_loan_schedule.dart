import 'package:equatable/equatable.dart';

class EmployeeLoanSchedule extends Equatable {
  final String? id;
  final int? period;
  final DateTime? dueDate;
  final double? principal;
  final double? interest;
  final double? total;
  final String? status;
  final DateTime? paidDate;
  final double? paidAmount;
  final String? paymentMethod;

  const EmployeeLoanSchedule({
    this.id,
    this.period,
    this.dueDate,
    this.principal,
    this.interest,
    this.total,
    this.status,
    this.paidDate,
    this.paidAmount,
    this.paymentMethod,
  });

  @override
  List<Object?> get props => [
        id,
        period,
        dueDate,
        principal,
        interest,
        total,
        status,
        paidDate,
        paidAmount,
        paymentMethod,
      ];
}
