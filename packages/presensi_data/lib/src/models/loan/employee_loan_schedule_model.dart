import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'employee_loan_schedule_model.freezed.dart';
part 'employee_loan_schedule_model.g.dart';

@freezed
abstract class EmployeeLoanScheduleModel with _$EmployeeLoanScheduleModel {
  const factory EmployeeLoanScheduleModel({
    @JsonKey(name: '_id') String? id,
    int? period,
    @JsonKey(name: 'due_date') DateTime? dueDate,
    double? principal,
    double? interest,
    double? total,
    String? status,
    @JsonKey(name: 'paid_date') DateTime? paidDate,
    @JsonKey(name: 'paid_amount') double? paidAmount,
    @JsonKey(name: 'payment_method') String? paymentMethod,
  }) = _EmployeeLoanScheduleModel;

  factory EmployeeLoanScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeLoanScheduleModelFromJson(json);

  const EmployeeLoanScheduleModel._();

  EmployeeLoanSchedule toEntity() {
    return EmployeeLoanSchedule(
      id: id,
      period: period,
      dueDate: dueDate,
      principal: principal,
      interest: interest,
      total: total,
      status: status,
      paidDate: paidDate,
      paidAmount: paidAmount,
      paymentMethod: paymentMethod,
    );
  }
}
