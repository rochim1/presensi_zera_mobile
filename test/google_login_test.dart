import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/presentation/widgets/login/google_registration_details.dart';

void main() {
  test('Google login retains device rules and omits password credentials', () {
    final params = const LoginParamsEntity.google(
      idToken: 'test-id-token',
      phoneNumber: ' 081234567890 ',
      legalConsent: true,
    ).copyWith(macAddress: 'registered-device');
    final input = params.toJson()['input'] as Map;
    expect(input['provider'], 'google');
    expect(input['tokenId'], 'test-id-token');
    expect(input['mac_address'], 'registered-device');
    expect(input['remember_me'], isTrue);
    expect(input['telp_number'], '081234567890');
    expect(input['legal_consent'], isTrue);
    expect(input['primary_product'], 'hrms');
    expect(input['registration_source'], 'mobile_zera');
    expect(input.containsKey('password'), isFalse);
    expect(input.containsKey('email_or_username'), isFalse);
    expect(input.containsKey('captcha_answer'), isFalse);
  });

  test('first Google attempt never silently consents to registration', () {
    final input =
        const LoginParamsEntity.google(idToken: 'token').toJson()['input']
            as Map;
    expect(input['legal_consent'], isFalse);
    expect(input['telp_number'], isNull);
  });

  test('server registration challenge survives GraphQL error mapping', () {
    expect(
      () => GraphQlException().fromGraphQlError(
        OperationException(
          graphqlErrors: [
            GraphQLError(
              message: 'Lengkapi akun',
              extensions: const {
                'code': 'GOOGLE_REGISTRATION_DETAILS_REQUIRED',
              },
            ),
          ],
        ),
      ),
      throwsA(
        isA<GraphQlException>().having(
          (error) => error.code,
          'code',
          'GOOGLE_REGISTRATION_DETAILS_REQUIRED',
        ),
      ),
    );
  });

  testWidgets('new Google account needs a valid phone and explicit consent', (
    tester,
  ) async {
    String? submittedPhone;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () async {
                submittedPhone = await showModalBottomSheet<String>(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => const GoogleRegistrationDetails(),
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Buat akun dan lanjutkan'));
    await tester.pumpAndSettle();
    expect(submittedPhone, isNull);
    expect(find.text('Masukkan nomor telepon 8–15 digit.'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField), '081234567890');
    await tester.tap(find.text('Buat akun dan lanjutkan'));
    await tester.pumpAndSettle();
    expect(submittedPhone, isNull);
    expect(
      find.text('Persetujuan diperlukan untuk membuat akun.'),
      findsOneWidget,
    );
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Buat akun dan lanjutkan'));
    await tester.pumpAndSettle();
    expect(submittedPhone, '081234567890');
    expect(tester.takeException(), isNull);
  });
}
