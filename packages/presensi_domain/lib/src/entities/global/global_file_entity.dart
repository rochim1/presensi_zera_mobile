import 'package:equatable/equatable.dart';

class GlobalFileEntity extends Equatable {
  final String? base64;
  final String? filename;

  const GlobalFileEntity({this.base64, this.filename});

  @override
  List<Object?> get props => [base64, filename];
}
