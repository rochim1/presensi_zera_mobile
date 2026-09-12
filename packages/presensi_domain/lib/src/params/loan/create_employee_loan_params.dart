class CreateEmployeeLoanParams {
  final String employeeId;
  final String loanType;
  final double principalAmount;
  final double? interestRate;
  final String? interestType;
  final int loanTermMonths;
  final String purpose;
  final List<String>? attachments;
  final String? deductionMethod;
  final String? deductionStartPeriod;

  CreateEmployeeLoanParams({
    required this.employeeId,
    required this.loanType,
    required this.principalAmount,
    this.interestRate,
    this.interestType,
    required this.loanTermMonths,
    required this.purpose,
    this.attachments,
    this.deductionMethod,
    this.deductionStartPeriod,
  });
}
