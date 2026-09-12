mixin RequiredValidator {
  bool isEmpty(String value) => value.trim().isEmpty;
}

mixin RequiredNullableValidator<T> {
  bool isNull(T? value) => value == null;
}

mixin EmailValidator {
  final RegExp emailRegex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$');

  bool isValidEmail(String value) => emailRegex.hasMatch(value);
}

mixin MinLengthValidator {
  bool hasMinLength(String value, int min) => value.length >= min;
}

mixin MaxLengthValidator {
  bool hasMaxLength(String value, int max) => value.length <= max;
}

mixin RequiredListValidator<T> {
  bool isEmptyList(List<T> value) => value.isEmpty;
}

mixin MaxLengthListValidator<T> {
  bool hasMaxLength(List<T> value, int max) => value.length <= max;
}

mixin FileExtensionValidator {
  bool hasValidExtension(String? extension, List<String> allowed) {
    if (extension == null) return false;
    return allowed.contains(extension.toLowerCase());
  }
}
