// ignore: deprecated_member_use
import 'dart:html' as html;
import 'dart:typed_data';

bool openPdfBytesInBrowser(Uint8List bytes) {
  final blob = html.Blob(<Object>[bytes], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.window.open(url, '_blank');
  Future<void>.delayed(const Duration(minutes: 1), () {
    html.Url.revokeObjectUrl(url);
  });
  return true;
}
