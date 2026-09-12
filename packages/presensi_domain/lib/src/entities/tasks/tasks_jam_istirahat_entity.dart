import 'package:equatable/equatable.dart';

class JamIstirahatEntity extends Equatable {
  final String? mulaiIstirahat;
  final String? selesaiIstirahat;

  const JamIstirahatEntity({this.mulaiIstirahat, this.selesaiIstirahat});

  @override
  List<Object?> get props => [mulaiIstirahat, selesaiIstirahat];
}
