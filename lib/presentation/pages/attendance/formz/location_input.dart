import 'package:presensi_mobile/core/formz/_formz.dart';
import 'package:presensi_domain/presensi_domain.dart';

enum LocationValidationError { empty }

class LocationInput
    extends AppFormzInput<AppLocation, LocationValidationError> {
  const LocationInput.pure() : super.pure(const AppLocation(lat: 0, long: 0));

  const LocationInput.dirty(super.value) : super.dirty();

  @override
  LocationValidationError? validator(AppLocation value) {
    final isEmpty = value.lat == 0 || value.long == 0;
    if (isEmpty) return LocationValidationError.empty;
    return null;
  }

  @override
  String? get errorMessage {
    if (isPure) return null;
    switch (error) {
      case LocationValidationError.empty:
        return 'Lokasi wajib diisi';
      default:
        return null;
    }
  }
}
