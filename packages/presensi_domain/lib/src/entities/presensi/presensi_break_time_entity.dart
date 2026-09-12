import 'package:equatable/equatable.dart';

class PresensiBreakTimeEntity extends Equatable {
  final String? mulaiIstirahat;
  final String? selesaiIstirahat;

  const PresensiBreakTimeEntity({this.mulaiIstirahat, this.selesaiIstirahat});

  @override
  List<Object?> get props => [mulaiIstirahat, selesaiIstirahat];
}
