import 'package:equatable/equatable.dart';

class DivisiIdEntity extends Equatable {
  final String? namaDivisi;
  final String? anakDevisi;
  final String? jobDesk;

  DivisiIdEntity({this.namaDivisi, this.anakDevisi, this.jobDesk});

  @override
  List<Object?> get props => [namaDivisi, anakDevisi, jobDesk];
}
