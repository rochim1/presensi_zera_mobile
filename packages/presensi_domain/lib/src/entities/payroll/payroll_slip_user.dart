class PayrollSlipUser {
  final String id;
  final String name;
  final String? email;
  final String? departmentName;
  final String? positionName;

  const PayrollSlipUser({
    required this.id,
    required this.name,
    this.email,
    this.departmentName,
    this.positionName,
  });
}
