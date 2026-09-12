import 'package:presensi_domain/src/entities/sales_target/sales_target.dart';

class SalesTargetModel extends SalesTargetEntity {
  const SalesTargetModel({
    required super.id,
    required super.periode,
    required super.salesmanNama,
    required super.targetSales,
    required super.achievement,
    required super.targetCall,
    required super.actualCall,
    required super.targetEc,
    required super.actualEc,
    required super.targetNoo,
    required super.actualNoo,
    required super.status,
    required super.runRate,
    required super.dailyBreakdown,
  });

  factory SalesTargetModel.fromJson(Map<String, dynamic> json) {
    return SalesTargetModel(
      id: json['_id'] ?? '',
      periode: json['periode'] ?? '',
      salesmanNama: json['salesman_nama'] ?? '',
      targetSales: (json['target_sales'] ?? 0).toDouble(),
      achievement: (json['achievement'] ?? 0).toDouble(),
      targetCall: json['target_call'] ?? 0,
      actualCall: json['actual_call'] ?? 0,
      targetEc: json['target_ec'] ?? 0,
      actualEc: json['actual_ec'] ?? 0,
      targetNoo: json['target_noo'] ?? 0,
      actualNoo: json['actual_noo'] ?? 0,
      status: json['status'] ?? 'in_progress',
      runRate: json['run_rate'] ?? 'on-track',
      dailyBreakdown: (json['daily_breakdown'] as List<dynamic>?)
              ?.map((e) => DailyBreakdownModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class DailyBreakdownModel extends DailyBreakdownEntity {
  const DailyBreakdownModel({
    required super.date,
    required super.dailyTargetSales,
    required super.achievement,
    required super.dailyTargetCall,
    required super.actualCall,
    required super.dailyTargetEc,
    required super.actualEc,
    required super.dailyTargetNoo,
    required super.actualNoo,
    required super.isWorkingDay,
    required super.reason,
  });

  factory DailyBreakdownModel.fromJson(Map<String, dynamic> json) {
    return DailyBreakdownModel(
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      dailyTargetSales: (json['daily_target_sales'] ?? 0).toDouble(),
      achievement: (json['achievement'] ?? 0).toDouble(),
      dailyTargetCall: json['daily_target_call'] ?? 0,
      actualCall: json['actual_call'] ?? 0,
      dailyTargetEc: json['daily_target_ec'] ?? 0,
      actualEc: json['actual_ec'] ?? 0,
      dailyTargetNoo: json['daily_target_noo'] ?? 0,
      actualNoo: json['actual_noo'] ?? 0,
      isWorkingDay: json['is_working_day'] ?? false,
      reason: json['reason'] ?? '',
    );
  }
}
