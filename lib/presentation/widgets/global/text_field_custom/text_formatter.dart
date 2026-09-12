import 'package:flutter/services.dart';
import 'package:presensi_mobile/core/_core.dart';

class CapitalizeTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.capitalize,
      selection: newValue.selection,
    );
  }
}

class IdrTextInputFormatter extends TextInputFormatter {
  static String digitsOnly(String value) =>
      value.replaceAll(RegExp(r'[^0-9]'), '');

  static double? tryParse(String value) => double.tryParse(digitsOnly(value));

  static String formatNumber(num value) {
    final digits = value.round().toString();
    return digits.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    String text = digitsOnly(newValue.text);
    if (text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Menggunakan NumberFormat dari intl yang otomatis load berdasarkan locale
    // Atau manual implement format ribuan:
    text = text.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );

    return newValue.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
