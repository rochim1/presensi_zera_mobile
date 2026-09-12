import 'package:equatable/equatable.dart';
import 'employee_loan_schedule.dart';

class EmployeeLoan extends Equatable {
  final String id;
  final String? loanNumber;
  final String? employeeId;
  final String? employeeName;
  final String? loanType;
  final String? loanTypeLabel;
  final double? principalAmount;
  final double? interestRate;
  final String? interestType;
  final int? loanTermMonths;
  final double? monthlyPayment;
  final double? totalPayment;
  final double? totalInterest;
  final double? outstandingBalance;
  final String? purpose;
  final List<String>? attachments;
  final String? deductionMethod;
  final String? deductionStartPeriod;
  final DateTime? disbursementDate;
  final List<EmployeeLoanSchedule>? paymentSchedule;
  final String? approvalStatus;
  final DateTime? approvedAt;
  final String? rejectedReason;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const EmployeeLoan({
    required this.id,
    this.loanNumber,
    this.employeeId,
    this.employeeName,
    this.loanType,
    this.loanTypeLabel,
    this.principalAmount,
    this.interestRate,
    this.interestType,
    this.loanTermMonths,
    this.monthlyPayment,
    this.totalPayment,
    this.totalInterest,
    this.outstandingBalance,
    this.purpose,
    this.attachments,
    this.deductionMethod,
    this.deductionStartPeriod,
    this.disbursementDate,
    this.paymentSchedule,
    this.approvalStatus,
    this.approvedAt,
    this.rejectedReason,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        loanNumber,
        employeeId,
        employeeName,
        loanType,
        loanTypeLabel,
        principalAmount,
        interestRate,
        interestType,
        loanTermMonths,
        monthlyPayment,
        totalPayment,
        totalInterest,
        outstandingBalance,
        purpose,
        attachments,
        deductionMethod,
        deductionStartPeriod,
        disbursementDate,
        paymentSchedule,
        approvalStatus,
        approvedAt,
        rejectedReason,
        createdAt,
        updatedAt,
      ];
}
