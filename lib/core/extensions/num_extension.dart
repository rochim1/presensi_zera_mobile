import 'package:intl/intl.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

extension NumCurrencyExt on num {
  String toCurrency(CurrencySymbol currency, {int decimalDigits = 0}) {
    return NumberFormat.currency(
      locale: currency.locale,
      symbol: '${currency.symbol} ',
      decimalDigits: decimalDigits,
    ).format(this);
  }
}
