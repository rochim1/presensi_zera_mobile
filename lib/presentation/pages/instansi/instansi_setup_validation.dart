class InstansiSetupValidation {
  const InstansiSetupValidation._();

  static String? requiredText(String? value) =>
      value == null || value.trim().isEmpty ? 'Wajib diisi' : null;

  static String? email(String? value) {
    final required = requiredText(value);
    if (required != null) return required;
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value!.trim())
        ? null
        : 'Format email tidak valid';
  }

  static String? phone(String? value) {
    final required = requiredText(value);
    if (required != null) return required;
    return RegExp(r'^(?:0[0-9]{8,13}|62[0-9]{8,13})$').hasMatch(value!.trim())
        ? null
        : 'Gunakan nomor aktif yang diawali 0 atau 62';
  }

  static String? coordinate(String? value, {required bool isLatitude}) {
    final required = requiredText(value);
    if (required != null) return required;
    final coordinate = double.tryParse(value!.trim());
    final limit = isLatitude ? 90 : 180;
    if (coordinate == null ||
        !coordinate.isFinite ||
        coordinate.abs() > limit) {
      return isLatitude
          ? 'Latitude harus antara -90 dan 90'
          : 'Longitude harus antara -180 dan 180';
    }
    return null;
  }
}
