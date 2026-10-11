import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

void main() {
  const id = '0123456789abcdef0123456789abcdef0123';
  const image = 'data:image/png;base64,iVBORw0KGgo=';
  final extensions = <String, dynamic>{
    'code': 'CAPTCHA_REQUIRED',
    'captcha': {'id': id, 'image': image},
  };

  test('CAPTCHA survives device metadata and is sent with login input', () {
    const params = LoginParamsEntity(
      username: 'user',
      password: 'pass',
      captchaId: id,
      captchaAnswer: 'ABC234',
    );
    final input =
        params.copyWith(macAddress: 'device').toJson()['input'] as Map;
    expect(input['captcha_id'], id);
    expect(input['captcha_answer'], 'ABC234');
    expect(input['mac_address'], 'device');
    expect(
      const LoginParamsEntity(
        username: 'user',
        password: 'pass',
      ).toJson()['input'],
      isNot(contains('captcha_id')),
    );
  });

  test('GraphQL challenge reaches the mobile failure intact', () {
    try {
      GraphQlException().fromGraphQlError(
        OperationException(
          graphqlErrors: [
            GraphQLError(
              message: 'Solve CAPTCHA',
              path: ['login'],
              extensions: extensions,
            ),
          ],
        ),
      );
      fail('Expected GraphQlException');
    } on GraphQlException catch (error) {
      expect(error.code, 'CAPTCHA_REQUIRED');
      final captcha = LoginCaptchaFailure.fromExtensions(error.extensions);
      expect(captcha?.captchaId, id);
      expect(captcha?.image, image);
    }
  });

  test('Missing or malformed CAPTCHA is rejected without decoding errors', () {
    expect(LoginCaptchaFailure.fromExtensions(null), isNull);
    expect(
      LoginCaptchaFailure.fromExtensions({
        'captcha': {'id': id, 'image': 'data:image/png;base64,???'},
      }),
      isNull,
    );
    expect(
      LoginCaptchaFailure.fromExtensions({
        'captcha': {'id': 'invalid', 'image': image},
      }),
      isNull,
    );
  });
}
