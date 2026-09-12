import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class InstansiSelectOption {
  const InstansiSelectOption({required this.value, required this.label});

  final String value;
  final String label;
}

/// Satu katalog pilihan untuk seluruh form instansi di aplikasi mobile.
/// Zona waktu bersumber dari basis data IANA yang juga dipakai oleh web admin.
class InstansiOptionCatalog {
  InstansiOptionCatalog._();

  static List<InstansiSelectOption>? _timezones;

  static List<InstansiSelectOption> get timezones {
    tz_data.initializeTimeZones();
    return _timezones ??=
        tz.timeZoneDatabase.locations.keys
            .map((name) => InstansiSelectOption(value: name, label: name))
            .toList()
          ..sort((a, b) => a.label.compareTo(b.label));
  }

  // Disamakan dengan src/components/translation/currency.json pada web admin.
  static const currencies = <InstansiSelectOption>[
    InstansiSelectOption(value: 'AED', label: 'AED — Dirham UEA'),
    InstansiSelectOption(value: 'ARS', label: 'ARS — Peso Argentina'),
    InstansiSelectOption(value: 'AUD', label: 'AUD — Dollar Australia'),
    InstansiSelectOption(value: 'BDT', label: 'BDT — Taka Bangladesh'),
    InstansiSelectOption(value: 'BHD', label: 'BHD — Dinar Bahrain'),
    InstansiSelectOption(value: 'BRL', label: 'BRL — Real Brasil'),
    InstansiSelectOption(value: 'CAD', label: 'CAD — Dollar Kanada'),
    InstansiSelectOption(value: 'CHF', label: 'CHF — Franc Swiss'),
    InstansiSelectOption(value: 'CLP', label: 'CLP — Peso Chile'),
    InstansiSelectOption(value: 'CNY', label: 'CNY — Yuan Tiongkok'),
    InstansiSelectOption(value: 'COP', label: 'COP — Peso Kolombia'),
    InstansiSelectOption(value: 'CZK', label: 'CZK — Koruna Ceko'),
    InstansiSelectOption(value: 'DKK', label: 'DKK — Krone Denmark'),
    InstansiSelectOption(value: 'EGP', label: 'EGP — Pound Mesir'),
    InstansiSelectOption(value: 'EUR', label: 'EUR — Euro'),
    InstansiSelectOption(value: 'GBP', label: 'GBP — Pound Inggris'),
    InstansiSelectOption(value: 'HKD', label: 'HKD — Dollar Hong Kong'),
    InstansiSelectOption(value: 'IDR', label: 'IDR — Rupiah'),
    InstansiSelectOption(value: 'ILS', label: 'ILS — Shekel Israel'),
    InstansiSelectOption(value: 'INR', label: 'INR — Rupee India'),
    InstansiSelectOption(value: 'JPY', label: 'JPY — Yen Jepang'),
    InstansiSelectOption(value: 'KRW', label: 'KRW — Won Korea'),
    InstansiSelectOption(value: 'KWD', label: 'KWD — Dinar Kuwait'),
    InstansiSelectOption(value: 'MXN', label: 'MXN — Peso Meksiko'),
    InstansiSelectOption(value: 'MYR', label: 'MYR — Ringgit Malaysia'),
    InstansiSelectOption(value: 'NGN', label: 'NGN — Naira Nigeria'),
    InstansiSelectOption(value: 'NOK', label: 'NOK — Krone Norwegia'),
    InstansiSelectOption(value: 'NZD', label: 'NZD — Dollar Selandia Baru'),
    InstansiSelectOption(value: 'PHP', label: 'PHP — Peso Filipina'),
    InstansiSelectOption(value: 'PKR', label: 'PKR — Rupee Pakistan'),
    InstansiSelectOption(value: 'PLN', label: 'PLN — Zloty Polandia'),
    InstansiSelectOption(value: 'QAR', label: 'QAR — Riyal Qatar'),
    InstansiSelectOption(value: 'RUB', label: 'RUB — Rubel Rusia'),
    InstansiSelectOption(value: 'SAR', label: 'SAR — Riyal Saudi'),
    InstansiSelectOption(value: 'SEK', label: 'SEK — Krona Swedia'),
    InstansiSelectOption(value: 'SGD', label: 'SGD — Dollar Singapura'),
    InstansiSelectOption(value: 'THB', label: 'THB — Baht Thailand'),
    InstansiSelectOption(value: 'TRY', label: 'TRY — Lira Turki'),
    InstansiSelectOption(value: 'TWD', label: 'TWD — Dollar Taiwan Baru'),
    InstansiSelectOption(value: 'USD', label: 'USD — Dollar Amerika'),
    InstansiSelectOption(value: 'VND', label: 'VND — Dong Vietnam'),
    InstansiSelectOption(value: 'ZAR', label: 'ZAR — Rand Afrika Selatan'),
  ];
}
