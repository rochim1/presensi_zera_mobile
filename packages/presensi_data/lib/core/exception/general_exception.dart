class CacheException implements Exception {
  final String? message;
  final String? code;

  CacheException({this.message, this.code});
}

class UnknownException implements Exception {
  final String? message;
  final String? code;

  UnknownException({this.message, this.code});
}

class NotFoundException implements Exception {
  final String? message;
  final String? code;

  NotFoundException({this.message, this.code});
}
