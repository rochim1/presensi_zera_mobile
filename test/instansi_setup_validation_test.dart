import 'package:flutter_test/flutter_test.dart';
import 'package:presensi_mobile/presentation/pages/instansi/instansi_setup_validation.dart';

void main() {
  test('kontak instansi menerima email dan nomor yang valid', () {
    expect(InstansiSetupValidation.email(' kontak@example.org '), isNull);
    expect(InstansiSetupValidation.email('email-tidak-valid'), isNotNull);
    expect(InstansiSetupValidation.phone('081234567890'), isNull);
    expect(InstansiSetupValidation.phone('6281234567890'), isNull);
    expect(InstansiSetupValidation.phone('12345'), isNotNull);
    expect(InstansiSetupValidation.phone('0812abc456'), isNotNull);
  });

  test('koordinat instansi harus berada dalam rentang geografis', () {
    expect(
      InstansiSetupValidation.coordinate('-6.2', isLatitude: true),
      isNull,
    );
    expect(
      InstansiSetupValidation.coordinate('106.8', isLatitude: false),
      isNull,
    );
    expect(
      InstansiSetupValidation.coordinate('91', isLatitude: true),
      isNotNull,
    );
    expect(
      InstansiSetupValidation.coordinate('181', isLatitude: false),
      isNotNull,
    );
    expect(
      InstansiSetupValidation.coordinate('NaN', isLatitude: true),
      isNotNull,
    );
  });
}
