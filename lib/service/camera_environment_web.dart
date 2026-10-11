import 'dart:js_interop';

@JS('isSecureContext')
external bool get _isSecureContext;

String? cameraEnvironmentError() => _isSecureContext
    ? null
    : 'Kamera web memerlukan HTTPS atau localhost. Buka aplikasi melalui alamat HTTPS.';
