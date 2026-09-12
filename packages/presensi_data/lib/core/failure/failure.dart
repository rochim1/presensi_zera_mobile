import 'package:equatable/equatable.dart';
import 'package:presensi_data/presensi_data.dart';

abstract class Failure extends Equatable {
  final String code;
  final String message;

  const Failure({this.message = '', this.code = ''});

  @override
  List<Object?> get props => [message, code];
}

class ServerFailure extends Failure {
  const ServerFailure({String? message, String? code})
    : super(message: message ?? '', code: code ?? '');

  @override
  List<Object?> get props => [message, code];
}

class AuthFailure extends Failure {
  const AuthFailure({String? message}) : super(message: message ?? '');

  @override
  List<Object?> get props => [message];
}

class ProsessFailure extends Failure {
  const ProsessFailure({String? message}) : super(message: message ?? '');

  @override
  List<Object?> get props => [message];
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({
    String message = FAILURE_NOT_FOUND,
    String code = NOT_FOUND,
  }) : super(message: message, code: code);

  @override
  List<Object?> get props => [message, code];
}

class CacheFailure extends Failure {
  const CacheFailure({String? message})
    : super(message: message ?? FAILURE_UNKNOWN_DATA);

  @override
  List<Object?> get props => [message];
}

class UnknownFailure extends Failure {
  const UnknownFailure({String? message, String? code})
    : super(message: message ?? FAILURE_UNKNOWN, code: code ?? E000);

  @override
  List<Object?> get props => [message, code];
}

class CustomFailure extends Failure {
  const CustomFailure({required String message}) : super(message: message);

  @override
  List<Object?> get props => [message];
}

class LocationFailure extends Failure {
  LocationFailure({required String message}) : super(message: message);
}
