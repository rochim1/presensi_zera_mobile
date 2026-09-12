import 'package:equatable/equatable.dart';

class GlobalPostResponseEntity extends Equatable {
  final String? message;
  final bool? isSuccessed;

  GlobalPostResponseEntity({this.message, this.isSuccessed});

  @override
  List<Object?> get props => [message, isSuccessed];
}
