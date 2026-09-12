import 'dart:typed_data';

class PayrollSlipPdf {
  final Uint8List bytes;
  final String fileName;

  const PayrollSlipPdf({required this.bytes, required this.fileName});
}
