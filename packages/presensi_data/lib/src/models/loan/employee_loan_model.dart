import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';

import 'employee_loan_schedule_model.dart';

part 'employee_loan_model.freezed.dart';
part 'employee_loan_model.g.dart';

@freezed
abstract class EmployeeLoanModel with _$EmployeeLoanModel {
  const factory EmployeeLoanModel({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'loan_number') String? loanNumber,
    @JsonKey(name: 'employee_id') String? employeeId,
    @JsonKey(name: 'employee_name') String? employeeName,
    @JsonKey(name: 'loan_type') String? loanType,
    @JsonKey(name: 'loan_type_label') String? loanTypeLabel,
    @JsonKey(name: 'principal_amount') double? principalAmount,
    @JsonKey(name: 'interest_rate') double? interestRate,
    @JsonKey(name: 'interest_type') String? interestType,
    @JsonKey(name: 'loan_term_months') int? loanTermMonths,
    @JsonKey(name: 'monthly_payment') double? monthlyPayment,
    @JsonKey(name: 'total_payment') double? totalPayment,
    @JsonKey(name: 'total_interest') double? totalInterest,
    @JsonKey(name: 'outstanding_balance') double? outstandingBalance,
    String? purpose,
    List<String>? attachments,
    @JsonKey(name: 'deduction_method') String? deductionMethod,
    @JsonKey(name: 'deduction_start_period') String? deductionStartPeriod,
    @JsonKey(name: 'disbursement_date') DateTime? disbursementDate,
    @JsonKey(name: 'payment_schedule')
    List<EmployeeLoanScheduleModel>? paymentSchedule,
    @JsonKey(name: 'approval_status') String? approvalStatus,
    @JsonKey(name: 'approved_at') DateTime? approvedAt,
    @JsonKey(name: 'rejected_reason') String? rejectedReason,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _EmployeeLoanModel;

  factory EmployeeLoanModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeLoanModelFromJson(json);

  const EmployeeLoanModel._();

  EmployeeLoan toEntity() {
    return EmployeeLoan(
      id: id,
      loanNumber: loanNumber,
      employeeId: employeeId,
      employeeName: employeeName,
      loanType: loanType,
      loanTypeLabel: loanTypeLabel,
      principalAmount: principalAmount,
      interestRate: interestRate,
      interestType: interestType,
      loanTermMonths: loanTermMonths,
      monthlyPayment: monthlyPayment,
      totalPayment: totalPayment,
      totalInterest: totalInterest,
      outstandingBalance: outstandingBalance,
      purpose: purpose,
      attachments: attachments,
      deductionMethod: deductionMethod,
      deductionStartPeriod: deductionStartPeriod,
      disbursementDate: disbursementDate,
      paymentSchedule: paymentSchedule?.map((e) => e.toEntity()).toList(),
      approvalStatus: approvalStatus,
      approvedAt: approvedAt,
      rejectedReason: rejectedReason,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
