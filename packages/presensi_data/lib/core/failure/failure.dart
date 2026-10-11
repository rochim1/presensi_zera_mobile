import 'dart:convert';
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

class LoginCaptchaFailure extends Failure {
  final String captchaId;
  final String image;

  const LoginCaptchaFailure({
    required this.captchaId,
    required this.image,
    String message = 'Selesaikan CAPTCHA untuk melanjutkan login',
  }) : super(code: 'CAPTCHA_REQUIRED', message: message);

  static LoginCaptchaFailure? fromExtensions(
    Map<String, dynamic>? extensions, {
    String? message,
  }) {
    final challenge = extensions?['captcha'];
    if (challenge is! Map) return null;
    final id = challenge['id'];
    final image = challenge['image'];
    if (id is! String ||
        !RegExp(r'^[a-f0-9]{36}$').hasMatch(id) ||
        image is! String ||
        !image.startsWith('data:image/png;base64,') ||
        image.length > 256 * 1024)
      return null;
    try {
      if (base64Decode(
        image.substring('data:image/png;base64,'.length),
      ).isEmpty)
        return null;
    } on FormatException {
      return null;
    }
    return LoginCaptchaFailure(
      captchaId: id,
      image: image,
      message: message ?? 'Selesaikan CAPTCHA untuk melanjutkan login',
    );
  }

  @override
  List<Object?> get props => [code, message, captchaId, image];
}
