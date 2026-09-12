import 'package:presensi_domain/presensi_domain.dart';

class PayrollSlip {
  final String id;
  final PayrollSlipUser? user;
  final String? period;
  final int? month;
  final int? year;
  final PayrollSlipStatus status;
  final PayrollAttendanceSummary? attendance;
  final double baseSalary;
  final double totalAllowance;
  final double totalOvertime;
  final double totalIncentive;
  final double totalIncome;
  final double totalDeduction;
  final double netSalary;
  final double totalIncomeAdjustment;
  final double totalDeductionAdjustment;
  final PayrollDeductionSummary? deductions;
  final String? notes;
  final String? cancelReason;

  const PayrollSlip({
    required this.id,
    required this.status,
    this.user,
    this.period,
    this.month,
    this.year,
    this.attendance,
    this.baseSalary = 0,
    this.totalAllowance = 0,
    this.totalOvertime = 0,
    this.totalIncentive = 0,
    this.totalIncome = 0,
    this.totalDeduction = 0,
    this.netSalary = 0,
    this.totalIncomeAdjustment = 0,
    this.totalDeductionAdjustment = 0,
    this.deductions,
    this.notes,
    this.cancelReason,
  });
}
