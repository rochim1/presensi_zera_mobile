import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presensi_mobile/l10n/generated/app_localizations.dart';
import 'package:presensi_mobile/l10n/hr_translation_lookup.dart';

void main() {
  test('all reviewed dynamic messages preserve their parameters', () {
    final fixtures =
        jsonDecode(
              File(
                'test/fixtures/hr_dynamic_translation.json',
              ).readAsStringSync(),
            )
            as List;
    final english = lookupAppLocalizations(const Locale('en'));
    for (final row in fixtures) {
      expect(
        translateHrText(row[0] as String, english),
        row[1],
        reason: row[2] as String,
      );
    }
  });
}
