import 'dart:typed_data';

class PayrollSlipPdfResponse {
  final Uint8List bytes;
  final String fileName;

  const PayrollSlipPdfResponse({required this.bytes, required this.fileName});
}
