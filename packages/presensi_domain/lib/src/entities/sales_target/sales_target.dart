import 'package:equatable/equatable.dart';

class SalesTargetEntity extends Equatable {
  final String id;
  final String periode; // "2026-06"
  final String salesmanNama;
  final double targetSales; // target omzet bulanan (Rp)
  final double achievement; // pencapaian omzet aktual (Rp)
  final int targetCall; // target call bulanan
  final int actualCall;
  final int targetEc; // target effective call bulanan
  final int actualEc;
  final int targetNoo; // target NOO bulanan
  final int actualNoo;
  final String status; // in_progress, tercapai, tidak_tercapai
  final String runRate; // ahead, on-track, behind
  final List<DailyBreakdownEntity> dailyBreakdown;

  const SalesTargetEntity({
    required this.id,
    required this.periode,
    required this.salesmanNama,
    required this.targetSales,
    required this.achievement,
    required this.targetCall,
    required this.actualCall,
    required this.targetEc,
    required this.actualEc,
    required this.targetNoo,
    required this.actualNoo,
    required this.status,
    required this.runRate,
    required this.dailyBreakdown,
  });

  @override
  List<Object?> get props => [
        id,
        periode,
        salesmanNama,
        targetSales,
        achievement,
        targetCall,
        actualCall,
        targetEc,
        actualEc,
        targetNoo,
        actualNoo,
        status,
        runRate,
        dailyBreakdown,
      ];
}

class DailyBreakdownEntity extends Equatable {
  final DateTime date;
  final double dailyTargetSales;
  final double achievement;
  final int dailyTargetCall;
  final int actualCall;
  final int dailyTargetEc;
  final int actualEc;
  final int dailyTargetNoo;
  final int actualNoo;
  final bool isWorkingDay;
  final String reason;

  const DailyBreakdownEntity({
    required this.date,
    required this.dailyTargetSales,
    required this.achievement,
    required this.dailyTargetCall,
    required this.actualCall,
    required this.dailyTargetEc,
    required this.actualEc,
    required this.dailyTargetNoo,
    required this.actualNoo,
    required this.isWorkingDay,
    required this.reason,
  });

  @override
  List<Object?> get props => [
        date,
        dailyTargetSales,
        achievement,
        dailyTargetCall,
        actualCall,
        dailyTargetEc,
        actualEc,
        dailyTargetNoo,
        actualNoo,
        isWorkingDay,
        reason,
      ];
}
